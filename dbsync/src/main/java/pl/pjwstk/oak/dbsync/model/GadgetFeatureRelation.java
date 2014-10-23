package pl.pjwstk.oak.dbsync.model;

public class GadgetFeatureRelation extends OakModel {

	private Long featureId;

	private Long gadgetId;

	public GadgetFeatureRelation(Long featureId, Long gadgetId) {
		super();
		this.featureId = featureId;
		this.gadgetId = gadgetId;
	}

	public GadgetFeatureRelation(Long linkId, Long gadgetId, Long featureId) {
		super();
		this.featureId = featureId;
		this.gadgetId = gadgetId;
		super.id = linkId;
	}

	public Long getFeatureId() {
		return featureId;
	}

	public Long getGadgetId() {
		return gadgetId;
	}

	public void setFeatureId(Long featureId) {
		this.featureId = featureId;
	}

	public void setGadgetId(Long gadgetId) {
		this.gadgetId = gadgetId;
	}
}
