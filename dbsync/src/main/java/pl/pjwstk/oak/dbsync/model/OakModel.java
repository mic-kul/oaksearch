package pl.pjwstk.oak.dbsync.model;

public class OakModel {

	protected Long id;

	public OakModel() {
		super();
	}

	public OakModel(Long id) {
		super();
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Override
	public String toString() {
		return "OakModel [id=" + id + "]";
	}
}
