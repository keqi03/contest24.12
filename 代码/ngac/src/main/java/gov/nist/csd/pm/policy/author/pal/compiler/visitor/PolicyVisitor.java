package gov.nist.csd.pm.policy.author.pal.compiler.visitor;

import gov.nist.csd.pm.policy.author.pal.antlr.PALBaseVisitor;
import gov.nist.csd.pm.policy.author.pal.antlr.PALParser;
import gov.nist.csd.pm.policy.author.pal.model.context.VisitorContext;
import gov.nist.csd.pm.policy.author.pal.statement.PALStatement;

import java.util.ArrayList;
import java.util.List;

public class PolicyVisitor extends PALBaseVisitor<List<PALStatement>> {

    private final VisitorContext visitorCtx;

    public PolicyVisitor(VisitorContext visitorCtx) {
        this.visitorCtx = visitorCtx;
    }

    @Override
    public List<PALStatement> visitPal(PALParser.PalContext ctx) {
        List<PALStatement> statements = new ArrayList<>();
        for (PALParser.StmtContext stmtCtx : ctx.stmt()) {
            StatementVisitor statementVisitor = new StatementVisitor(visitorCtx);
            PALStatement statement = statementVisitor.visitStmt(stmtCtx);
            statements.add(statement);
        }
        return statements;
    }

}
