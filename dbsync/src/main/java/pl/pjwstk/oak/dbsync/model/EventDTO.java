package pl.pjwstk.oak.dbsync.model;

public class EventDTO {

	private long taskId;

	private EventType eventType;

	private OakModel thing;

	public EventDTO(EventType eventType, OakModel thing) {
		super();
		this.eventType = eventType;
		this.thing = thing;
	}

	public EventDTO(long taskId, EventType eventType, OakModel thing) {
		super();
		this.taskId = taskId;
		this.eventType = eventType;
		this.thing = thing;
	}

	public EventType getEventType() {
		return eventType;
	}

	public long getTaskId() {
		return taskId;
	}

	public OakModel getThing() {
		return thing;
	}

	public void setEventType(EventType eventType) {
		this.eventType = eventType;
	}

	public void setTaskId(long taskId) {
		this.taskId = taskId;
	}

	public void setThing(OakModel thing) {
		this.thing = thing;
	}

	@Override
	public String toString() {
		if (thing != null) {
			if (thing instanceof Gadget) {
				return "EventDTO [eventType=" + eventType + ", thing=" + (Gadget) thing + "]";
			} else if (thing instanceof Feature) {
				return "EventDTO [eventType=" + eventType + ", thing=" + (Feature) thing + "]";
			}
		}
		return "EventDTO [eventType=" + eventType + ", thing=" + thing + "]";
	}
}
