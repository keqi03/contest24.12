package gov.nist.csd.pm.pap.memory;

import gov.nist.csd.pm.pap.store.ObligationsStore;
import gov.nist.csd.pm.policy.events.*;
import gov.nist.csd.pm.policy.exceptions.PMException;
import gov.nist.csd.pm.policy.model.access.UserContext;
import gov.nist.csd.pm.policy.model.obligation.Obligation;
import gov.nist.csd.pm.policy.model.obligation.Rule;

import java.util.List;

class TxObligations extends ObligationsStore implements PolicyEventEmitter {

    private final MemoryObligationsStore store;
    private final TxPolicyEventListener txPolicyEventListener;

    public TxObligations(MemoryObligationsStore store, TxPolicyEventListener txPolicyEventListener) {
        this.store = store;
        this.txPolicyEventListener = txPolicyEventListener;
    }

    void setObligations(List<Obligation> obligations) {
        store.setObligations(obligations);
    }

    @Override
    public void create(UserContext author, String label, Rule... rules) throws PMException {
        emitEvent(new CreateObligationEvent(author, label, List.of(rules)));
        store.create(author, label, rules);
    }

    @Override
    public void update(UserContext author, String label, Rule... rules) throws PMException {
        emitEvent(new TxEvents.MemoryUpdateObligationEvent(new Obligation(author, label, List.of(rules)), store.get(label)));
        store.update(author, label, rules);
    }

    @Override
    public void delete(String label) throws PMException {
        emitEvent(new TxEvents.MemoryDeleteObligationEvent(label, store.get(label)));
        store.delete(label);
    }

    @Override
    public List<Obligation> getAll() throws PMException {
        return store.getAll();
    }

    @Override
    public Obligation get(String label) throws PMException {
        return store.get(label);
    }

    @Override
    public void beginTx() throws PMException {

    }

    @Override
    public void commit() throws PMException {

    }

    @Override
    public void rollback() throws PMException {

    }

    @Override
    public void addEventListener(PolicyEventListener listener, boolean sync) throws PMException {

    }

    @Override
    public void removeEventListener(PolicyEventListener listener) {

    }

    @Override
    public void emitEvent(PolicyEvent event) throws PMException {
        txPolicyEventListener.handlePolicyEvent(event);
    }
}
