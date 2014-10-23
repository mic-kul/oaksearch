package pl.pjwstk.oak.dbsync.task;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.concurrent.BlockingQueue;

import org.neo4j.graphdb.GraphDatabaseService;

import pl.pjwstk.oak.dbsync.DBSync;
import pl.pjwstk.oak.dbsync.model.EventDTO;
import pl.pjwstk.oak.dbsync.model.Feature;
import pl.pjwstk.oak.dbsync.model.Gadget;
import pl.pjwstk.oak.dbsync.model.GadgetFeatureRelation;

public class DBWriter implements Runnable {

	private Connection conn;

	private BlockingQueue<EventDTO> queue;

	private GraphDatabaseService dbService;

	public DBWriter(Connection conn, DBSync sync, BlockingQueue<EventDTO> queue) {
		this.conn = conn;
		this.queue = queue;
	}

	private void doQuery(String query, Long[] values) throws SQLException {
		PreparedStatement preparedStatement = conn.prepareStatement(query);
		int i = 0;
		for (i = 0; i < values.length; i++)
			preparedStatement.setLong(i + 1, values[i]);
		preparedStatement.executeQuery();
	}

	private void doQuery(String query, String[] values, Long id) throws SQLException {
		PreparedStatement preparedStatement = conn.prepareStatement(query);
		int i = 0;
		for (i = 0; i < values.length; i++)
			preparedStatement.setString(i + 1, values[i]);
		if (null != id)
			preparedStatement.setLong(i + 1, id);
		preparedStatement.executeQuery();
	}

	public void run() {
		while (true) {
			try {
				EventDTO event = queue.poll();
				if (null == event) {
					Thread.sleep(300);
					continue;
				}

				System.out.println("DBWriter: " + event);

				String queryStr = null;
				Feature f = null;
				Gadget p = null;
				GadgetFeatureRelation rel = null;
				switch (event.getEventType()) {
					case FEATURE_ADD:
						f = (Feature) event.getThing();

						if (f == null || null == f.getId() || f.getName() == null || f.getValue() == null)
							continue;

						String name = f.getName().replaceAll("\"", "\\\"");

						if (name.equals("_name"))
							continue;
						String value = f.getValue().replaceAll("\"", "\\\"");
						queryStr = "CREATE (n:Feature {name: {1}, value: {2}, dbid: {3}})";

						try {
							doQuery(queryStr, new String[] { name, value }, f.getId());
						} catch (SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}

						break;
					case FEATURE_DELETE:
						f = (Feature) event.getThing();
						if (f == null || null == f.getId())
							continue;
						queryStr = "MATCH (n:Featre {dbid: {1}) DELETE n";
						try {
							doQuery(queryStr, new Long[] { f.getId() });
						} catch (SQLException e) {
							e.printStackTrace();
						}
						break;
					case FEATURE_MOD:
						f = (Feature) event.getThing();
						queryStr = "MATCH (a:Feature) WHERE a.dbid = {3} SET a.name = {1}, a.value = {2}";
						try {
							doQuery(queryStr, new String[] { f.getName(), f.getValue() }, f.getId());
						} catch (SQLException e) {
							e.printStackTrace();
						}
						break;
					case PRODUCT_ADD:
						p = (Gadget) event.getThing();

						queryStr = "CREATE (n:Product {name: {1}, dbid: {2}})";

						try {
							doQuery(queryStr, new String[] { p.getName() }, p.getId());
						} catch (SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						break;
					case PRODUCT_DELETE:
						p = (Gadget) event.getThing();
						queryStr = "MATCH (a:Product)-[r:HAS_FEATURE]-() WHERE r.dbid = {1} DELETE r, a";
						try {
							doQuery(queryStr, new Long[] { p.getId() });
						} catch (SQLException e) {
							e.printStackTrace();
						}
						break;
					case PRODUCT_MOD:
						p = (Gadget) event.getThing();
						queryStr = "MATCH (a:Product) WHERE a.dbid = {2} SET a.name = {1}";
						try {
							doQuery(queryStr, new String[] { p.getName() }, p.getId());
						} catch (SQLException e) {
							e.printStackTrace();
						}
						break;
					case PROD_FEAT_ADD:
						rel = (GadgetFeatureRelation) event.getThing();
						queryStr = "MATCH (n:Product),(m:Feature) WHERE HAS (n.dbid) AND HAS (m.dbid) AND n.dbid={1} AND m.dbid={2} CREATE (n)-[:HAS_FEATURE {dbid: {3}}]->(m)";
						try {
							doQuery(queryStr, new Long[] { rel.getGadgetId(), rel.getFeatureId(), rel.getId() });
						} catch (SQLException e) {
							e.printStackTrace();
						}
						break;
					case PROD_FEAT_DELETE:
						rel = (GadgetFeatureRelation) event.getThing();
						queryStr = "MATCH a-[r:HAS_FEATURE]-() WHERE r.dbid = {1} DELETE r";
						try {
							doQuery(queryStr, new Long[] { rel.getId() });
						} catch (SQLException e) {
							e.printStackTrace();
						}

						break;
					case PROD_FEAT_MOD:
						System.out.println("PROD_FEAT_MOD!!!!");
						break;
					default:
						break;

				}
				if (queryStr == null)
					continue;

			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}
