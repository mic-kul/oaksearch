package pl.pjwstk.oak.dbsync.model;

import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public class OakModelFactory {

	public static OakModel[] getOakModel(EventType eventType, String xmlString) {
		if (null == eventType)
			return null;

		switch (eventType) {
			case FEATURE_ADD:
			case FEATURE_DELETE:
			case FEATURE_MOD:
				return parseFeature(xmlString);
			case PRODUCT_ADD:
			case PRODUCT_DELETE:
			case PRODUCT_MOD:
				return parseGadget(xmlString);
			case PROD_FEAT_ADD:
			case PROD_FEAT_DELETE:
			case PROD_FEAT_MOD:
				return parseGadgetFeatureRelation(xmlString);
			default:
				return null;
		}
	}

	private static Feature[] parseFeature(String xmlString) {
		Document doc = string2document(xmlString);

		if (null == doc)
			return null;
		List<Feature> featuresList = new ArrayList<Feature>();

		NodeList nList = doc.getElementsByTagName("ROW");
		for (int temp = 0; temp < nList.getLength(); temp++) {
			Node nNode = nList.item(temp);
			if (nNode.getNodeType() == Node.ELEMENT_NODE) {
				Element eElement = (Element) nNode;
				String featureIdStr = eElement.getElementsByTagName("FEATURE_ID").item(0).getTextContent();
				String featureType = eElement.getElementsByTagName("FEATURE_TYPE").item(0).getTextContent();
				String featureName = eElement.getElementsByTagName("FEATURE_NAME").item(0).getTextContent();
				Long featureId = null;
				try {
					featureId = Long.parseLong(featureIdStr);
					featuresList.add(new Feature(featureId, featureType, featureName));
				} catch (NumberFormatException e) {
					// TODO log
				}
			}
		}
		return featuresList.toArray(new Feature[0]);
	}

	private static Gadget[] parseGadget(String xmlString) {
		Document doc = string2document(xmlString);
		if (null == doc)
			return null;

		NodeList nList = doc.getElementsByTagName("ROW");
		List<Gadget> ret = new ArrayList<Gadget>();
		for (int temp = 0; temp < nList.getLength(); temp++) {
			Node nNode = nList.item(temp);
			if (nNode.getNodeType() == Node.ELEMENT_NODE) {
				Element eElement = (Element) nNode;
				String gadgetIdStr = eElement.getElementsByTagName("PRODUCT_ID").item(0).getTextContent();
				String gadgetName = eElement.getElementsByTagName("NAME").item(0).getTextContent();
				Long gadgetId = null;
				try {
					gadgetId = Long.parseLong(gadgetIdStr);
					ret.add(new Gadget(gadgetId, gadgetName));
					// TODO return Gadget
				} catch (NumberFormatException e) {
					// TODO log
				}

			}
		}
		return ret.toArray(new Gadget[0]);
	}

	private static GadgetFeatureRelation[] parseGadgetFeatureRelation(String xmlString) {
		Document doc = string2document(xmlString);
		if (null == doc)
			return null;
		List<GadgetFeatureRelation> relList = new ArrayList<GadgetFeatureRelation>();
		NodeList nList = doc.getElementsByTagName("ROW");
		for (int temp = 0; temp < nList.getLength(); temp++) {
			Node nNode = nList.item(temp);
			if (nNode.getNodeType() == Node.ELEMENT_NODE) {
				Element eElement = (Element) nNode;
				String gadgetIdStr = eElement.getElementsByTagName("PRODUCT_ID").item(0).getTextContent();
				String featureIdStr = eElement.getElementsByTagName("FEATURE_ID").item(0).getTextContent();
				String linkIdStr = eElement.getElementsByTagName("PROD_FEAT_ID").item(0).getTextContent();
				Long gadgetId = null;
				Long featureId = null;
				Long linkId = null;
				try {
					gadgetId = Long.parseLong(gadgetIdStr);
					featureId = Long.parseLong(featureIdStr);
					linkId = Long.parseLong(linkIdStr);
					relList.add(new GadgetFeatureRelation(linkId, gadgetId, featureId));
				} catch (NumberFormatException e) {
					// TODO log
				}

			}
		}
		return relList.toArray(new GadgetFeatureRelation[0]);
	}

	private static Document string2document(String xmlString) {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder;
		Document document = null;
		try {
			builder = factory.newDocumentBuilder();
			document = builder.parse(new InputSource(new StringReader(xmlString)));
			document.getDocumentElement().normalize();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return document;
	}

}
