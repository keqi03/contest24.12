package gov.nist.csd.pm.policy.model.obligation.event;


import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

public class EventPattern implements Serializable {

    private final EventSubject subject;
    private final List<String> operations;
    private final Target target;

    public EventPattern(EventSubject subject, Performs performs) {
        this.subject = subject;
        this.operations = Arrays.asList(performs.events());
        this.target = Target.anyPolicyElement();
    }
    public EventPattern(EventSubject subject, Performs performs, Target target) {
        this.subject = subject;
        this.operations = Arrays.asList(performs.events());
        this.target = target;
    }

    public EventPattern(EventPattern eventPattern) {
        this.subject = eventPattern.subject;
        this.operations = new ArrayList<>(eventPattern.operations);
        this.target = eventPattern.target;
    }

    public EventSubject getSubject() {
        return subject;
    }

    public List<String> getOperations() {
        return operations;
    }

    public Target getTarget() {
        return target;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        EventPattern that = (EventPattern) o;
        return Objects.equals(subject, that.subject) && Objects.equals(operations, that.operations) && Objects.equals(target, that.target);
    }

    @Override
    public int hashCode() {
        return Objects.hash(subject, operations, target);
    }
}
