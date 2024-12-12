package gov.nist.csd.pm.policy.model.graph.dag.walker;

import gov.nist.csd.pm.policy.exceptions.PMException;
import gov.nist.csd.pm.policy.model.graph.dag.ShortCircuit;

public interface GraphWalker {

    /**
     * Traverse a graph starting at the start node.
     */
    void walk(String start) throws PMException;

}
