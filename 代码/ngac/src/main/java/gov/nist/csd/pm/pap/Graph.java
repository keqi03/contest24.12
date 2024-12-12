package gov.nist.csd.pm.pap;

import gov.nist.csd.pm.pap.store.PolicyStore;
import gov.nist.csd.pm.policy.author.GraphAuthor;
import gov.nist.csd.pm.policy.events.*;
import gov.nist.csd.pm.policy.exceptions.*;
import gov.nist.csd.pm.policy.model.access.AccessRightSet;
import gov.nist.csd.pm.policy.model.graph.nodes.Node;
import gov.nist.csd.pm.policy.model.graph.nodes.NodeType;
import gov.nist.csd.pm.policy.model.graph.relationships.Assignment;
import gov.nist.csd.pm.policy.model.graph.relationships.Association;
import gov.nist.csd.pm.policy.model.obligation.Obligation;
import gov.nist.csd.pm.policy.model.obligation.Rule;
import gov.nist.csd.pm.policy.model.obligation.event.EventPattern;
import gov.nist.csd.pm.policy.model.obligation.event.EventSubject;
import gov.nist.csd.pm.policy.model.obligation.event.Target;
import gov.nist.csd.pm.policy.model.prohibition.ContainerCondition;
import gov.nist.csd.pm.policy.model.prohibition.Prohibition;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import static gov.nist.csd.pm.pap.SuperPolicy.*;
import static gov.nist.csd.pm.policy.model.access.AdminAccessRights.*;
import static gov.nist.csd.pm.policy.model.graph.nodes.NodeType.*;
import static gov.nist.csd.pm.policy.model.graph.nodes.Properties.noprops;

class Graph extends GraphAuthor implements PolicyEventEmitter {

    private final PolicyStore store;
    private final List<PolicyEventListener> listeners;

    Graph(PolicyStore store) {
        this.store = store;
        this.listeners = new ArrayList<>();
    }

    protected PolicyStore store() {
        return store;
    }

    @Override
    public void setResourceAccessRights(AccessRightSet accessRightSet) throws PMException {
        for (String ar : accessRightSet) {
            if (isAdminAccessRight(ar) || isWildcardAccessRight(ar)) {
                throw new AdminAccessRightExistsException(ar);
            }
        }

        store.graph().setResourceAccessRights(accessRightSet);

        // notify listeners of policy modification
        emitEvent(new SetResourceAccessRightsEvent(accessRightSet));
    }

    @Override
    public AccessRightSet getResourceAccessRights() throws PMException {
        return store.graph().getResourceAccessRights();
    }

    @Override
    public String createPolicyClass(String name, Map<String, String> properties) throws PMException {
        if (nodeExists(name)) {
            throw new NodeNameExistsException(name);
        }

        SuperPolicy.createPolicyClass(this, name, properties);

        return name;
    }

    @Override
    public String createPolicyClass(String name) throws PMException {
        return createPolicyClass(name, noprops());
    }

    @Override
    public String createObjectAttribute(String name, Map<String, String> properties, String parent, String... parents) throws PMException {
        return createNode(name, OA, properties, parent, parents);
    }

    @Override
    public String createObjectAttribute(String name, String parent, String... parents) throws PMException {
        return createObjectAttribute(name, noprops(), parent, parents);
    }

    @Override
    public String createUserAttribute(String name, Map<String, String> properties, String parent, String... parents) throws PMException {
        return createNode(name, UA, properties, parent, parents);
    }

    @Override
    public String createUserAttribute(String name, String parent, String... parents) throws PMException {
        return createUserAttribute(name, noprops(), parent, parents);
    }

    @Override
    public String createObject(String name, Map<String, String> properties, String parent, String... parents) throws PMException {
        return createNode(name, O, properties, parent, parents);
    }

    @Override
    public String createObject(String name, String parent, String... parents) throws PMException {
        return createObject(name, noprops(), parent, parents);
    }

    @Override
    public String createUser(String name, Map<String, String> properties, String parent, String... parents) throws PMException {
        return createNode(name, U, properties, parent, parents);
    }

    @Override
    public String createUser(String name, String parent, String... parents) throws PMException {
        return createUser(name, noprops(), parent, parents);
    }

    private String createNode(String name, NodeType type, Map<String, String> properties, String parent, String ... parents) throws PMException {
        if (nodeExists(name)) {
            throw new NodeNameExistsException(name);
        } else if (!nodeExists(parent)) {
            throw new NodeDoesNotExistException(parent);
        }

        // collect any parents that are of type PC
        // this will also check if the nodes exist by calling getNode
        List<String> pcParents = new ArrayList<>();
        List<String> parentsList = new ArrayList<>(Arrays.asList(parents));
        parentsList.add(parent);
        for (String p : parentsList) {
            Node parentNode = getNode(p);
            if (parentNode.getType() != PC) {
                continue;
            }

            pcParents.add(p);
        }

        switch (type) {
            case OA -> {
                store.graph().createObjectAttribute(name, properties, parent, parents);
                emitEvent(new CreateObjectAttributeEvent(name, properties, parent, parents));
            }
            case UA -> {
                store.graph().createUserAttribute(name, properties, parent, parents);
                emitEvent(new CreateUserAttributeEvent(name, properties, parent, parents));
            }
            case O -> {
                store.graph().createObject(name, properties, parent, parents);
                emitEvent(new CreateObjectEvent(name, properties, parent, parents));
            }
            case U -> {
                store.graph().createUser(name, properties, parent, parents);
                emitEvent(new CreateUserEvent(name, properties, parent, parents));
            }
            default -> { /* PC and ANY should not ever be passed to this private method */ }
        }

        // for any pc parents, create any necessary super policy configurations
        for (String pc : pcParents) {
            SuperPolicy.assignedToPolicyClass(this, name, pc);
        }

        return name;
    }

    @Override
    public void setNodeProperties(String name, Map<String, String> properties) throws PMException {
        if (!nodeExists(name)) {
            throw new NodeDoesNotExistException(name);
        }

        store.graph().setNodeProperties(name, properties);

        emitEvent(new SetNodePropertiesEvent(name, properties));
    }

    @Override
    public void deleteNode(String name) throws PMException {
        if (!nodeExists(name)) {
            return;
        }

        List<String> children = getChildren(name);
        if (!children.isEmpty()) {
            throw new NodeHasChildrenException(name);
        }

        checkIfNodeInProhibition(name);
        checkIfNodeInObligation(name);

        NodeType type = getNode(name).getType();

        // delete the rep node if node is a PC
        store.beginTx();

        if (type == PC) {
            String rep = pcRepObjectAttribute(name);
            store.graph().deleteNode(rep);
            emitEvent(new DeleteNodeEvent(rep));
        }

        store.graph().deleteNode(name);
        emitEvent(new DeleteNodeEvent(name));

        store.commit();
    }

    private void checkIfNodeInProhibition(String name) throws PMException {
        Map<String, List<Prohibition>> prohibitions = store.prohibitions().getAll();
        for (List<Prohibition> subjPros : prohibitions.values()) {
            for (Prohibition p : subjPros) {
                if (nodeInProhibition(name, p)) {
                    throw new NodeReferencedInProhibitionException(name, p.getLabel());
                }
            }
        }
    }

    private boolean nodeInProhibition(String name, Prohibition prohibition) {
        if (prohibition.getSubject().name().equals(name)) {
            return true;
        }

        for (ContainerCondition containerCondition : prohibition.getContainers()) {
            if (containerCondition.name().equals(name)) {
                return true;
            }
        }

        return false;
    }

    private void checkIfNodeInObligation(String name) throws PMException {
        List<Obligation> obligations = store.obligations().getAll();
        for (Obligation obligation : obligations) {
            // if the node is the author of the obligation or referenced in any rules throw an exception
            if (obligation.getAuthor().getUser().equals(name)
                    || nodeInObligation(name, obligation)) {
                throw new NodeReferencedInObligationException(name, obligation.getLabel());
            }
        }
    }

    private boolean nodeInObligation(String name, Obligation obligation) {
        for (Rule rule : obligation.getRules()) {
            if (nodeInEvent(name, rule.getEvent())) {
                return true;
            }
        }

        return false;
    }

    private boolean nodeInEvent(String name, EventPattern event) {
        // check subject
        EventSubject subject = event.getSubject();
        if ((subject.getType() == EventSubject.Type.ANY_USER_WITH_ATTRIBUTE && subject.anyUserWithAttribute().equals(name))
                || (subject.getType() == EventSubject.Type.USERS && subject.users().contains(name))) {
            return true;
        }

        // check the target
        Target target = event.getTarget();
        return (target.getType() == Target.Type.ANY_CONTAINED_IN && target.anyContainedIn().equals(name))
                || (target.getType() == Target.Type.ANY_OF_SET && target.anyOfSet().contains(name))
                || (target.getType() == Target.Type.POLICY_ELEMENT && target.policyElement().equals(name));
    }

    @Override
    public Node getNode(String name) throws PMException {
        if (!nodeExists(name)) {
            throw new NodeDoesNotExistException(name);
        }

        return store.graph().getNode(name);
    }

    @Override
    public List<String> search(NodeType type, Map<String, String> properties) throws PMException {
        return store.graph().search(type, properties);
    }

    @Override
    public List<String> getPolicyClasses() throws PMException {
        return store.graph().getPolicyClasses();
    }

    @Override
    public boolean nodeExists(String name) throws PMException {
        return store.graph().nodeExists(name);
    }

    @Override
    public void assign(String child, String parent) throws PMException {
        Node childNode = getNode(child);
        Node parentNode = getNode(parent);

        // ignore if assignment already exists
        if (getParents(child).contains(parent)) {
            return;
        }

        // check node types make a valid assignment relation
        Assignment.checkAssignment(childNode.getType(), parentNode.getType());

        store().graph().assign(child, parent);
        emitEvent(new AssignEvent(child, parent));

        // if the parent is a policy class, need to associate the super ua with the child
        if (parentNode.getType() == PC) {
            SuperPolicy.assignedToPolicyClass(this, child, parent);
        }
    }

    @Override
    public void deassign(String child, String parent) throws PMException {
        if ((!nodeExists(child) || !nodeExists(parent))
                || (!getParents(child).contains(parent))) {
            return;
        }

        List<String> parents = store.graph().getParents(child);
        if (parents.size() == 1) {
            throw new DisconnectedNodeException(child, parent);
        }

        store.graph().deassign(child, parent);

        emitEvent(new DeassignEvent(child, parent));
    }

    @Override
    public List<String> getChildren(String node) throws PMException {
        if (!nodeExists(node)) {
            throw new NodeDoesNotExistException(node);
        }

        return store.graph().getChildren(node);
    }

    @Override
    public List<String> getParents(String node) throws PMException {
        if (!nodeExists(node)) {
            throw new NodeDoesNotExistException(node);
        }

        return store.graph().getParents(node);
    }

    @Override
    public void associate(String ua, String target, AccessRightSet accessRights) throws PMException {
        Node uaNode = getNode(ua);
        Node targetNode = getNode(target);

        // check the access rights are valid
        checkAccessRightsValid(store.graph(), accessRights);

        // check the types of each node make a valid association
        Association.checkAssociation(uaNode.getType(), targetNode.getType());

        // associate and emit event
        store.graph().associate(ua, target, accessRights);
        emitEvent(new AssociateEvent(ua, target, accessRights));
    }

    static void checkAccessRightsValid(GraphAuthor graph, AccessRightSet accessRightSet) throws PMException {
        AccessRightSet resourceAccessRights = graph.getResourceAccessRights();

        for (String ar : accessRightSet) {
            if (!resourceAccessRights.contains(ar)
                    && !allAdminAccessRights().contains(ar)
                    && !wildcardAccessRights().contains(ar)) {
                throw new UnknownAccessRightException(ar);
            }
        }
    }

    @Override
    public void dissociate(String ua, String target) throws PMException {
        if ((!nodeExists(ua) || !nodeExists(target))
                || (!getAssociationsWithSource(ua).contains(new Association(ua, target)))) {
            return;
        }

        store.graph().dissociate(ua, target);

        emitEvent(new DissociateEvent(ua, target));
    }

    @Override
    public List<Association> getAssociationsWithSource(String ua) throws PMException {
        if (!nodeExists(ua)) {
            throw new NodeDoesNotExistException(ua);
        }

        return store.graph().getAssociationsWithSource(ua);
    }

    @Override
    public List<Association> getAssociationsWithTarget(String target) throws PMException {
        if (!nodeExists(target)) {
            throw new NodeDoesNotExistException(target);
        }

        return store.graph().getAssociationsWithTarget(target);
    }

    @Override
    public void addEventListener(PolicyEventListener listener, boolean sync) {
        listeners.add(listener);
    }

    @Override
    public void removeEventListener(PolicyEventListener listener) {
        listeners.remove(listener);
    }

    @Override
    public void emitEvent(PolicyEvent event) throws PMException {
        for (PolicyEventListener listener : listeners) {
            listener.handlePolicyEvent(event);
        }
    }
}
