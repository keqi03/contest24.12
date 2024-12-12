package gov.nist.csd.pm.policy.author.pal.model.exception;

import gov.nist.csd.pm.policy.author.pal.compiler.error.CompileError;
import gov.nist.csd.pm.policy.author.pal.compiler.error.ErrorLog;
import gov.nist.csd.pm.policy.exceptions.PMException;

import java.util.*;

public class PALCompilationException extends PMException {

    private final List<CompileError> errors;

    public PALCompilationException(ErrorLog errorLog) {
        super(errorLog.toString());
        this.errors = new ArrayList<>(errorLog.getErrors());
    }

    public PALCompilationException(CompileError error) {
        super(error.errorMessage());
        this.errors = Arrays.asList(error);
    }

    public List<CompileError> getErrors() {
        return errors;
    }

    @Override
    public String getMessage() {
        StringBuilder s = new StringBuilder();
        for (CompileError e : errors) {
            s.append(e.toString()).append("\n");
        }
        return s.toString();
    }
}
