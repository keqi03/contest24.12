package gov.nist.csd.pm.policy.exceptions;

public class NodesAlreadyAssignedException extends PMException {
    public NodesAlreadyAssignedException(String ua, String target) {
        super("cannot associate \"" + ua + "\" with \"" + target + "\", \"" + ua + "\" is already assigned to \"" + target + "\"");
    }
}
