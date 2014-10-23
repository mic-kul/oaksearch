package pl.pjwstk.oak.dbsync.model;

import java.util.HashSet;
import java.util.Set;

public class Gadget extends OakModel {

	private Set<Feature> features;

	private String name;

	private Set<String> tokens;

	private Long id;

	public Gadget(Long gadgetId, String gadgetName) {
		this.id = gadgetId;
		this.name = gadgetName;
		this.tokens = new HashSet<String>();
		this.features = new HashSet<Feature>();
	}

	public Gadget(String name) {
		super();
		this.name = name;
		this.tokens = new HashSet<String>();
		this.features = new HashSet<Feature>();
	}

	public Set<Feature> getFeatures() {
		return features;
	}

	public Long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public Set<String> getTokens() {
		return tokens;
	}

	public void setFeatures(Set<Feature> features) {
		this.features = features;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setTokens(Set<String> tokens) {
		this.tokens = tokens;
	}

	@Override
	public String toString() {
		return "Gadget [features=" + features + ", name=" + name + ", tokens=" + tokens + ", getId()=" + getId() + "]";
	}

}
