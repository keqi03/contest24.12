package gov.nist.csd.pm.policy.author.pal.statement;

import gov.nist.csd.pm.policy.author.pal.model.context.ExecutionContext;
import gov.nist.csd.pm.policy.author.pal.model.expression.Value;
import gov.nist.csd.pm.policy.author.pal.model.scope.*;
import gov.nist.csd.pm.policy.exceptions.PMException;
import gov.nist.csd.pm.policy.author.PolicyAuthor;

import java.util.List;
import java.util.Objects;

import static gov.nist.csd.pm.policy.author.pal.PALExecutor.executeStatementBlock;
import static gov.nist.csd.pm.policy.author.pal.PALFormatter.statementsToString;

public class ForeachStatement extends PALStatement {

    private final String varName;
    private final String valueVarName;
    private final Expression iter;
    private final List<PALStatement> statements;

    public ForeachStatement(String varName, String valueVarName, Expression iter, List<PALStatement> statements) {
        this.varName = varName;
        this.valueVarName = valueVarName;
        this.iter = iter;
        this.statements = statements;
    }

    @Override
    public Value execute(ExecutionContext ctx, PolicyAuthor policyAuthor) throws PMException {
        if (statements.isEmpty()) {
            return new Value();
        }

        Value iterValue = iter.execute(ctx, policyAuthor);
        if (iterValue.isArray()) {
            for (Value v : iterValue.getArrayValue()) {
                ExecutionContext localExecutionCtx;
                try {
                    localExecutionCtx = ctx.copy();
                } catch (PALScopeException e) {
                    throw new RuntimeException(e);
                }

                localExecutionCtx.scope().addValue(varName, v);

                Value value = executeStatementBlock(localExecutionCtx, policyAuthor, statements);

                if (value.isBreak()) {
                    break;
                } else if (value.isReturn()) {
                    return value;
                }

                ctx.scope().overwriteValues(localExecutionCtx.scope());
            }
        } else if (iterValue.isMap()) {
            for (Value key : iterValue.getMapValue().keySet()) {
                ExecutionContext localExecutionCtx;
                try {
                    localExecutionCtx = ctx.copy();
                } catch (PALScopeException e) {
                    throw new RuntimeException(e);
                }

                Value mapValue = iterValue.getMapValue().get(key);

                localExecutionCtx.scope().addValue(varName, key);
                if (valueVarName != null) {
                    localExecutionCtx.scope().addValue(valueVarName, mapValue);
                }

                Value value = executeStatementBlock(localExecutionCtx, policyAuthor, statements);

                if (value.isBreak()) {
                    break;
                } else if (value.isReturn()) {
                    return value;
                }

                ctx.scope().overwriteValues(localExecutionCtx.scope());
            }
        }

        return new Value();
    }

    @Override
    public String toString() {
        return String.format("foreach %s in %s {%s}",
                (valueVarName != null ? String.format("%s, %s", varName, valueVarName) : varName),
                iter,
                statementsToString(statements)
        );
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ForeachStatement that = (ForeachStatement) o;
        return Objects.equals(varName, that.varName) && Objects.equals(valueVarName, that.valueVarName) && Objects.equals(iter, that.iter) && Objects.equals(statements, that.statements);
    }

    @Override
    public int hashCode() {
        return Objects.hash(varName, valueVarName, iter, statements);
    }

}
