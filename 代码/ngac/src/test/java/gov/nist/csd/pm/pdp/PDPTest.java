package gov.nist.csd.pm.pdp;

import gov.nist.csd.pm.pdp.memory.MemoryPDP;
import gov.nist.csd.pm.pdp.memory.MemoryPolicyReviewer;
import gov.nist.csd.pm.policy.exceptions.PMException;
import gov.nist.csd.pm.policy.model.access.AccessRightSet;
import gov.nist.csd.pm.policy.model.access.UserContext;
import gov.nist.csd.pm.pap.memory.MemoryPAP;
import org.junit.jupiter.api.Test;

import static gov.nist.csd.pm.pap.SuperPolicy.SUPER_USER;
import static gov.nist.csd.pm.policy.model.access.AdminAccessRights.CREATE_OBJECT_ATTRIBUTE;
import static org.junit.jupiter.api.Assertions.*;

class PDPTest {

    @Test
    void testRunTx() throws PMException {
        MemoryPAP memoryPAP = new MemoryPAP();
        PDP pdp = new MemoryPDP(memoryPAP);

        UserContext superUser = new UserContext(SUPER_USER);
        pdp.runTx(superUser, (policy) -> {
            policy.graph().createPolicyClass("pc1");
            policy.graph().createUserAttribute("ua1", "pc1");
            policy.graph().createObjectAttribute("oa1", "pc1");
            policy.graph().createObjectAttribute("oa2", "pc1");
            policy.graph().createUser("u1", "ua1");
            policy.graph().createObject("o1", "oa1");
        });

        assertThrows(PMException.class, () -> pdp.runTx(new UserContext("u1"), ((policy) ->
                policy.graph().associate("ua1", "oa1", new AccessRightSet(CREATE_OBJECT_ATTRIBUTE)))));

        assertTrue(memoryPAP.graph().nodeExists("pc1"));
        assertTrue(memoryPAP.graph().nodeExists("oa1"));
    }
}