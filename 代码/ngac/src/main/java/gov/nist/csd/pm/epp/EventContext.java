package gov.nist.csd.pm.epp;

import gov.nist.csd.pm.pdp.PolicyReviewer;
import gov.nist.csd.pm.policy.events.*;
import gov.nist.csd.pm.policy.exceptions.PMException;
import gov.nist.csd.pm.policy.model.access.UserContext;
import gov.nist.csd.pm.policy.model.obligation.event.EventPattern;
import gov.nist.csd.pm.policy.model.obligation.event.EventSubject;
import gov.nist.csd.pm.policy.model.obligation.event.Target;

public class EventContext implements PolicyEvent {

    private final UserContext userCtx;
    private final String eventName;
    private final String target;
    private final PolicyEvent event;

    public EventContext(UserContext userCtx, String target, PolicyEvent event) {
        this.userCtx = userCtx;
        this.eventName = event.getEventName();
        this.target = target;
        this.event = event;
    }

    public EventContext(UserContext userCtx, PolicyEvent event) {
        this.userCtx = userCtx;
        this.eventName = event.getEventName();
        this.target = "";
        this.event = event;
    }

    public UserContext getUserCtx() {
        return userCtx;
    }

    public String getEventName() {
        return eventName;
    }

    public String getTarget() {
        return target;
    }

    public PolicyEvent getEvent() {
        return event;
    }

    public boolean matchesPattern(EventPattern pattern, PolicyReviewer policyReviewer) throws PMException {
        if (pattern.getOperations().isEmpty() || pattern.getOperations().get(0).isEmpty()) {
            return true; // an empty event pattern will match all events
        } else if (pattern.getOperations() != null &&
                !pattern.getOperations().contains(eventName)) {
            return false;
        }

        EventSubject patternSubject = pattern.getSubject();
        Target patternTarget = pattern.getTarget();

        return patternSubject.matches(userCtx, policyReviewer) &&
                patternTarget.matches(target, policyReviewer);
    }

    @Override
    public String toString() {
        return "EventContext{" +
                "userCtx=" + userCtx +
                ", eventName='" + eventName + '\'' +
                ", target=" + target +
                ", event=" + event +
                '}';
    }
}
