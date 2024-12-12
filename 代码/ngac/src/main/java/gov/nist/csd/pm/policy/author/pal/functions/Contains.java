package gov.nist.csd.pm.policy.author.pal.functions;

import gov.nist.csd.pm.policy.author.pal.statement.FunctionDefinitionStatement;
import gov.nist.csd.pm.policy.author.pal.model.expression.Type;
import gov.nist.csd.pm.policy.author.pal.model.expression.Value;
import gov.nist.csd.pm.policy.author.pal.model.function.FormalArgument;

import java.util.Arrays;

public class Contains extends FunctionDefinitionStatement {

    public Contains() {
        super(
                name("contains"),
                returns(Type.bool()),
                args(
                        new FormalArgument("arr", Type.array(Type.any())),
                        new FormalArgument("element", Type.any())
                ),
                (ctx, author) -> {
                    Value[] valueArr = ctx.scope().getValue("arr").getArrayValue();
                    Value element = ctx.scope().getValue("element");
                    boolean contains = Arrays.asList(valueArr).contains(element);
                    return new Value(contains);
                }
        );
    }

}

