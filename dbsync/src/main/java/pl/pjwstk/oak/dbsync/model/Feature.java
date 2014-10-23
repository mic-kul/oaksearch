package pl.pjwstk.oak.dbsync.model;

public class Feature extends OakModel {

	private String name;

	private String value;

	public Feature(Long id, String name, String value) {
		super();
		super.setId(id);
		this.name = name;
		this.value = value;
	}

	public String getName() {
		return name;
	}

	public String getValue() {
		return value;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public String toString() {
		return "Feature [name=" + name + ", value=" + value + ", getId()=" + getId() + "]";
	}
}
