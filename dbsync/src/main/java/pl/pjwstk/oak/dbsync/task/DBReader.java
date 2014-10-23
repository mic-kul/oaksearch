package pl.pjwstk.oak.dbsync.task;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.concurrent.BlockingQueue;

import pl.pjwstk.oak.dbsync.DBSync;
import pl.pjwstk.oak.dbsync.model.EventDTO;
import pl.pjwstk.oak.dbsync.model.EventType;
import pl.pjwstk.oak.dbsync.model.OakModel;
import pl.pjwstk.oak.dbsync.model.OakModelFactory;

public class DBReader implements Runnable {

	private Connection conn;

	private BlockingQueue<EventDTO> queue;

	private static final String selectQuery = "SELECT WORKER_TASK_ID, EVENT_TYPE, to_clob((EVENT_DESC)) FROM WORKER_TASKS";

	private static final String deleteQuery = "DELETE FROM WORKER_TASKS WHERE WORKER_TASK_ID = ?";

	public DBReader(Connection conn, DBSync sync, BlockingQueue<EventDTO> queue) {
		this.conn = conn;
		this.queue = queue;
	}

	private void addToQueue() {
		Statement stmt = null;
		try {
			stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(selectQuery);
			if (null != rs.getWarnings())
				System.out.println(rs.getWarnings().getMessage());
			while (rs.next()) {
				System.out.println("NEXT");
				String eventType = rs.getString("EVENT_TYPE");
				int taskId = rs.getInt("WORKER_TASK_ID");
				String res = rs.getString(3);

				if (null == eventType || null == res) {
					// TODO log error
					continue;
				}

				try {
					EventType eventTypeEnum = EventType.valueOf(eventType.toUpperCase());
					OakModel[] oakModels = OakModelFactory.getOakModel(eventTypeEnum, res);
					EventDTO event = null;
					for (OakModel oakModel : oakModels) {
						event = new EventDTO(taskId, eventTypeEnum, oakModel);

						while (false == queue.offer(event)) {
							try {
								Thread.sleep(100);
							} catch (InterruptedException e) {
								// ignore
							}
						}
					}
					if (null != event)
						removeTask(event);
				} catch (IllegalArgumentException e) {
					// TODO log error
					continue;
				}

			}
		} catch (SQLException e) {
			// TODO ?
			e.printStackTrace();
		} finally {
			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException e) {
					// ignore
				}
			}
		}
	}

	private void removeTask(EventDTO dto) {
		if (null == dto)
			return;

		PreparedStatement stmt = null;
		try {
			stmt = conn.prepareStatement(deleteQuery);
			stmt.setLong(1, dto.getTaskId());
			stmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void run() {
		while (true) {
			try {
				addToQueue();
				Thread.sleep(300);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	}
}
