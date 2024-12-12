package gov.nist.csd.pm.policy.author.pal.model.scope;

public class VariableAlreadyDefinedInScopeException extends PALScopeException{

    public VariableAlreadyDefinedInScopeException(String varName) {
        super(String.format("variable '%s' already defined in scope", varName));
    }
}
