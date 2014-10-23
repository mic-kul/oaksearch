package pl.pjwstk.oak.dbsync;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

import org.neo4j.jdbc.Driver;
import org.neo4j.jdbc.internal.Neo4jConnection;

import pl.pjwstk.oak.dbsync.model.EventDTO;
import pl.pjwstk.oak.dbsync.task.DBReader;
import pl.pjwstk.oak.dbsync.task.DBWriter;

public class DBSync {

	private static final int QUEUE_SIZE = 5000;

	public static void main(String[] args) throws SQLException {
		try {
			DBSync sync = new DBSync(null);
		} catch (DBSyncException e) {
			// TODO log4j log
			e.printStackTrace();
		}
	}

	private Properties props;

	private DBWriter dbWriter;

	private Thread dbWriterThread;

	private DBReader dbReader;

	private Thread dbReaderThread;

	private BlockingQueue<EventDTO> syncQueue;

	Neo4jConnection n4jConnection;

	Connection sqlConnection;

	DBSync(Properties props) throws DBSyncException {
		this.props = props;

		syncQueue = new ArrayBlockingQueue<EventDTO>(QUEUE_SIZE);

		try {
			n4jConnection = new Driver().connect("jdbc:neo4j://localhost:7474", new Properties());

			// TODO stdout > log4j
			System.out.print("Initializing Neo4J connection...");
			dbWriter = new DBWriter(n4jConnection, this, syncQueue);
			dbWriterThread = new Thread(dbWriter);
			dbWriterThread.start();
			System.out.println(" [OK]");

			try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
			} catch (ClassNotFoundException e) {
				System.out.println("CRITICAL: Oracle JDBC Driver not available");
				throw new DBSyncException("Oracle JDBC Driver not available");
			}

			System.out.print("Initializing SQL connection...");
			sqlConnection = DriverManager.getConnection("jdbc:oracle:thin:@oracle:1521/oracle", "developer",
					"***");
			dbReader = new DBReader(sqlConnection, this, syncQueue);
			dbReaderThread = new Thread(dbReader);
			dbReaderThread.start();
			System.out.println(" [OK]");

		} catch (SQLException e) {
			throw new DBSyncException(e);
		}
	}

}
