package gov.nist.csd.pm.policy.model.obligation;

import gov.nist.csd.pm.policy.model.obligation.event.EventPattern;
import gov.nist.csd.pm.policy.model.obligation.event.Performs;
import gov.nist.csd.pm.policy.model.obligation.event.EventSubject;
import gov.nist.csd.pm.policy.model.obligation.event.Target;

import java.io.Serializable;
import java.util.Objects;

public class Rule implements Serializable {

    private final String label;
    private final EventPattern eventPattern;
    private final Response response;

    public Rule(String label, EventPattern eventPattern, Response response) {
        this.label = label;
        this.eventPattern = eventPattern;
        this.response = response;
    }

    public Rule(String label, EventSubject subject, Performs performs, Target target, Response response) {
        this.label = label;
        this.eventPattern = new EventPattern(subject, performs, target);
        this.response = response;
    }

    public Rule(String label, EventSubject subject, Performs performs, Response response) {
        this.label = label;
        this.eventPattern = new EventPattern(subject, performs);
        this.response = response;
    }

    public Rule(Rule rule) {
        this.label = rule.label;
        this.eventPattern = new EventPattern(rule.eventPattern);
        this.response = new Response(rule.response);
    }

    public String getLabel() {
        return label;
    }

    public EventPattern getEvent() {
        return eventPattern;
    }

    public Response getResponse() {
        return response;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Rule rule = (Rule) o;
        return label.equals(rule.label) && eventPattern.equals(rule.eventPattern) && response.equals(rule.response);
    }

    @Override
    public int hashCode() {
        return Objects.hash(label, eventPattern, response);
    }
}