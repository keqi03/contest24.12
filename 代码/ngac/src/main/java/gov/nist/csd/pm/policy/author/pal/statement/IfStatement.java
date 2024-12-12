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

public class IfStatement extends PALStatement {

    private final ConditionalBlock ifBlock;
    private final List<ConditionalBlock> ifElseBlocks;
    private final List<PALStatement> elseBlockStatements;

    public IfStatement(ConditionalBlock ifBlock, List<ConditionalBlock> ifElseBlocks, List<PALStatement> elseBlock) {
        this.ifBlock = ifBlock;
        this.ifElseBlocks = ifElseBlocks;
        this.elseBlockStatements = elseBlock;
    }

    public ConditionalBlock getIfBlock() {
        return ifBlock;
    }

    public List<ConditionalBlock> getIfElseBlocks() {
        return ifElseBlocks;
    }

    public List<PALStatement> getElseBlockStatements() {
        return elseBlockStatements;
    }

    @Override
    public Value execute(ExecutionContext ctx, PolicyAuthor policyAuthor) throws PMException {
        boolean condition = ifBlock.condition.execute(ctx, policyAuthor).getBooleanValue();
        if (condition) {
            return executeBlock(ctx, policyAuthor, ifBlock.block);
        }

        // check else ifs
        for (ConditionalBlock conditionalBlock : ifElseBlocks) {
            condition = conditionalBlock.condition.execute(ctx, policyAuthor).getBooleanValue();
            if (condition) {
                return executeBlock(ctx, policyAuthor, conditionalBlock.block);
            }
        }

        return executeBlock(ctx, policyAuthor, elseBlockStatements);
    }

    @Override
    public String toString() {
        return String.format(
                "%s%s%s",
                ifBlockToString(),
                elseIfBlockToString(),
                elseBlockToString()
        );
    }

    private String elseBlockToString() {
        if (elseBlockStatements.isEmpty()) {
            return "";
        }
        return String.format("else {%s}", statementsToString(elseBlockStatements));
    }

    private String elseIfBlockToString() {
        StringBuilder s = new StringBuilder();
        for (ConditionalBlock b : ifElseBlocks) {
            s.append(String.format(" else if %s {%s} ", b.condition, statementsToString(b.block)));
        }

        return s.toString();
    }

    private String ifBlockToString() {
        return String.format("if %s {%s}", ifBlock.condition, statementsToString(ifBlock.block));
    }

    private Value executeBlock(ExecutionContext ctx, PolicyAuthor policyAuthor, List<PALStatement> block) throws PMException {
        ExecutionContext copy = null;
        try {
            copy = ctx.copy();
        } catch (PALScopeException e) {
            throw new PMException(e.getMessage());
        }
        Value value = executeStatementBlock(copy, policyAuthor, block);

        ctx.scope().overwriteValues(copy.scope());

        return value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        IfStatement ifStmt = (IfStatement) o;
        return Objects.equals(ifBlock, ifStmt.ifBlock) && Objects.equals(ifElseBlocks, ifStmt.ifElseBlocks) && Objects.equals(elseBlockStatements, ifStmt.elseBlockStatements);
    }

    @Override
    public int hashCode() {
        return Objects.hash(ifBlock, ifElseBlocks, elseBlockStatements);
    }

    public record ConditionalBlock(Expression condition, List<PALStatement> block) { }
}
