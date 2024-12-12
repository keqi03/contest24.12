package gov.nist.csd.pm.policy.author.pal.functions;

import gov.nist.csd.pm.policy.author.pal.model.expression.Type;
import gov.nist.csd.pm.policy.author.pal.statement.FunctionDefinitionStatement;
import gov.nist.csd.pm.policy.author.pal.model.expression.Value;
import gov.nist.csd.pm.policy.author.pal.model.function.FormalArgument;

import java.util.Map;

public class ContainsKey extends FunctionDefinitionStatement {

    public ContainsKey() {
        super(
              name("containsKey"),
                returns(Type.bool()),
                args(
                        new FormalArgument("map", Type.map(Type.any(), Type.any())),
                        new FormalArgument("key", Type.any())
                ),
                (ctx, author) -> {
                    Map<Value, Value> valueMap = ctx.scope().getValue("map").getMapValue();
                    Value element = ctx.scope().getValue("key");
                    boolean contains = valueMap.containsKey(element);
                    return new Value(contains);
                }
        );
    }

}
