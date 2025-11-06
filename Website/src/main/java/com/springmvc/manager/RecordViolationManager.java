package com.springmvc.manager;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;

import com.springmvc.model.*;

public class RecordViolationManager {
//	List All
	@SuppressWarnings("unchecked")
    public List<RecordViolation> getListRV(int page, int size) {
        List<RecordViolation> list = new ArrayList<>();
        try (Session session = HibernateConnection.doHibernateConnection().openSession()) {
            int offset = (page - 1) * size;

            list = session.createQuery("FROM RecordViolation rv " +  // เพิ่ม alias rv
					            	    "WHERE rv.status_type = 'กำลังพิจารณา'" +
					            	    "ORDER BY rv.record_date DESC", 
                    RecordViolation.class)
                    .setFirstResult(offset)
                    .setMaxResults(size)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
	
//	Search Record All
	public List<RecordViolation> getSearchRecordViolation(String searchText, String startDate, int page, int size) {
	    List<RecordViolation> list = new ArrayList<>();
	    SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
	    try (Session session = sessionfactory.openSession()) {
	        session.beginTransaction();

	        int offset = (page - 1) * size;

	        String hql = "FROM RecordViolation rv WHERE rv.status_type = 'กำลังพิจารณา' AND " +
			             "(rv.student.student_id LIKE :searchText " +
			             "OR rv.student.firstname LIKE :searchText " +
			             "OR rv.student.major LIKE :searchText " +
			             "OR rv.student.faculty LIKE :searchText) ";

	        if (startDate != null && !startDate.isEmpty()) {
	            hql += "AND DATE(rv.record_date) = :startDate "; 
	        }

	        hql += "ORDER BY rv.record_date DESC";

//	        System.out.println("Generated HQL: " + hql);

	        Query<RecordViolation> query = session.createQuery(hql, RecordViolation.class)
	                                               .setParameter("searchText", "%" + searchText + "%")
	                                               .setFirstResult(offset)
	                                               .setMaxResults(size);

	        if (startDate != null && !startDate.isEmpty()) {
	            query.setParameter("startDate", java.sql.Date.valueOf(startDate))
						            						 .setFetchSize(offset)
						            						 .setMaxResults(size);
	        }

	        list = query.getResultList();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
//	Update Status
	public boolean updateRVStatusType(String record_id, String status_type, Date deduct_date, String officer_id) {
	    try {
	        SessionFactory sessionFactory = HibernateConnection.doHibernateConnection();
	        Session session = sessionFactory.openSession();
	        session.beginTransaction();

	        RecordViolation RV = session.get(RecordViolation.class, record_id);
	        if (RV == null) {
	            session.close();
	            return false;
	        }

	        if ("อนุมัติหักคะแนนพฤติกรรม".equals(status_type)) {
	            // กระบวนการอนุมัติหักคะแนนพฤติกรรม
	            if (!"อนุมัติหักคะแนนพฤติกรรม".equals(RV.getStatus_type())) {
	                ViolationType violationType = RV.getViolationType();
	                int deductScore = violationType != null ? violationType.getDeduct_score() : 0;

	                if (deductScore > 0) {
	                    StudentManager sm = new StudentManager();
	                    boolean deductResult = sm.deductStudentScore(RV.getStudent().getStudent_id(), deductScore);
	                    if (!deductResult) {
	                        session.getTransaction().rollback();
	                        session.close();
	                        return false;
	                    }
	                }
	            }
	            RV.setDeduct_date(deduct_date);

	        } else if ("ไม่อนุมัติหักคะแนนพฤติกรรม".equals(status_type)) {
	            // กระบวนการไม่อนุมัติหักคะแนนพฤติกรรม
	            RV.setDeduct_date(null); // กรณีไม่อนุมัติ ไม่ต้องมีวันที่หักคะแนน
	        } else {
	            session.getTransaction().rollback();
	            session.close();
	            return false;
	        }

	        // อัปเดตสถานะ
	        RV.setStatus_type(status_type);
	        session.update(RV);

	        Officer officer = session.get(Officer.class, officer_id);
	        if (officer == null) {
	            session.getTransaction().rollback();
	            session.close();
	            return false;
	        }

	        // เพิ่ม Notification
	        Notification notification = new Notification();
	        notification.setNotification_id(null);
	        notification.setNotification_date(new Date());
	        notification.setNotification_status(
	                "อนุมัติหักคะแนนพฤติกรรม".equals(status_type) ? 
	                "อนุมัติหักคะแนนพฤติกรรม" : 
	                "ไม่อนุมัติหักคะแนนพฤติกรรม"
	            );
	        notification.setMessage(
	            "อนุมัติหักคะแนนพฤติกรรม".equals(status_type) ? 
	            "แจ้งเตือนการอนุมัติหักคะแนนพฤติกรรม เนื่องจากละเมิดกฎจราจรภายในมหาวิทยาลัยแม่โจ้" : 
	            "แจ้งเตือนไม่ถูกหักคะแนนพฤติกรรม เนื่องจากคำร้องขอถูกปฏิเสธ");
	        notification.setStatus_view("ยังไม่ได้อ่าน");
	        notification.setRecordViolation(RV);
	        session.save(notification);

	        session.getTransaction().commit();
	        session.close();
	        return true;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}
	
//	Get QTY Search
    public long getTotalSearchRV(String searchText, String startDate) {
        long totalRecords = 0;
        SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
        try (Session session = sessionfactory.openSession()) {
            session.beginTransaction();

            String hql = "SELECT COUNT(rv) FROM RecordViolation rv WHERE rv.status_type = 'กำลังพิจารณา' AND " +
	                     "(rv.student.student_id LIKE :searchText " +
	                     "OR rv.student.firstname LIKE :searchText " +
	                     "OR rv.student.major LIKE :searchText " +
	                     "OR rv.student.faculty LIKE :searchText) ";

            // ตรวจสอบเงื่อนไขวันที่
            if (startDate != null && !startDate.isEmpty()) {
                hql += "AND rv.record_date = :startDate ";
            }

            Query<Long> query = session.createQuery(hql, Long.class)
                                       .setParameter("searchText", "%" + searchText + "%");

            // กำหนดพารามิเตอร์สำหรับวันที่
            if (startDate != null && !startDate.isEmpty()) {
                query.setParameter("startDate", java.sql.Date.valueOf(startDate));
            }

            totalRecords = query.getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalRecords;
    }
	
//   Get Record ID
	public RecordViolation getRecordViolationByID(String record_id) {
		RecordViolation recordViolation = null;
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();

			@SuppressWarnings("unchecked")
			List<RecordViolation> list = session.createQuery("FROM RecordViolation WHERE record_id = '" + record_id + "'").list();
			recordViolation = list.get(0);

			session.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return recordViolation;
	}
	
//  Get Total All
    public long getTotalRVPending() {
        long count = 0;
        try (Session session = HibernateConnection.doHibernateConnection().openSession()) {
            count = (long) session.createQuery("SELECT COUNT(r) FROM RecordViolation r WHERE r.status_type = 'กำลังพิจารณา'").uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    
    @SuppressWarnings("unchecked")
    public List<RecordViolation> getListRVByStatus(String status) {
        List<RecordViolation> list = new ArrayList<>();
        try {
            SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
            Session session = sessionfactory.openSession();
            session.beginTransaction();

            list = session.createQuery("FROM RecordViolation WHERE status_type = :status ORDER BY record_date DESC")
                          .setParameter("status", status)
                          .list();

            session.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
//-------------------------- APPROVED --------------------------------
// List Approved Records
    @SuppressWarnings("unchecked")
    public List<RecordViolation> getListRVApproved(int page, int size) {
        List<RecordViolation> list = new ArrayList<>();
        try (Session session = HibernateConnection.doHibernateConnection().openSession()) {
            int offset = (page - 1) * size;

            list = session.createQuery("FROM RecordViolation rv " +
                                       "WHERE rv.status_type = 'อนุมัติหักคะแนนพฤติกรรม' " +
                                       "ORDER BY rv.record_date DESC", 
                                       RecordViolation.class)
                          .setFirstResult(offset)
                          .setMaxResults(size)
                          .list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Search Approved Records
    public List<RecordViolation> getSearchRecordViolationApproved(String searchText, String startDate, int page, int size) {
        List<RecordViolation> list = new ArrayList<>();
        SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
        try (Session session = sessionfactory.openSession()) {
            session.beginTransaction();

            int offset = (page - 1) * size;

            String hql = "FROM RecordViolation rv WHERE rv.status_type = 'อนุมัติหักคะแนนพฤติกรรม' AND " +
                         "(rv.student.student_id LIKE :searchText " +
                         "OR rv.student.firstname LIKE :searchText " +
                         "OR rv.student.major LIKE :searchText " +
                         "OR rv.student.faculty LIKE :searchText) ";

            if (startDate != null && !startDate.isEmpty()) {
                hql += "AND DATE(rv.record_date) = :startDate ";
            }

            hql += "ORDER BY rv.record_date DESC";

            Query<RecordViolation> query = session.createQuery(hql, RecordViolation.class)
                                                   .setParameter("searchText", "%" + searchText + "%")
                                                   .setFirstResult(offset)
                                                   .setMaxResults(size);

            if (startDate != null && !startDate.isEmpty()) {
                query.setParameter("startDate", java.sql.Date.valueOf(startDate))
											                 .setFetchSize(offset)
												             .setMaxResults(size);
            }

            list = query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get Total Approved Records
    public long getTotalRVApproved() {
        long count = 0;
        try (Session session = HibernateConnection.doHibernateConnection().openSession()) {
            count = (long) session.createQuery("SELECT COUNT(r) FROM RecordViolation r WHERE r.status_type = 'อนุมัติหักคะแนนพฤติกรรม'").uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // Get Total Search Approved Records
    public long getTotalSearchRVApproved(String searchText, String startDate) {
        long totalRecords = 0;
        SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
        try (Session session = sessionfactory.openSession()) {
            session.beginTransaction();

            String hql = "SELECT COUNT(rv) FROM RecordViolation rv WHERE rv.status_type = 'อนุมัติหักคะแนนพฤติกรรม' AND " +
                         "(rv.student.student_id LIKE :searchText " +
                         "OR rv.student.firstname LIKE :searchText " +
                         "OR rv.student.major LIKE :searchText " +
                         "OR rv.student.faculty LIKE :searchText) ";

            if (startDate != null && !startDate.isEmpty()) {
                hql += "AND rv.record_date = :startDate ";
            }

            Query<Long> query = session.createQuery(hql, Long.class)
                                       .setParameter("searchText", "%" + searchText + "%");

            if (startDate != null && !startDate.isEmpty()) {
                query.setParameter("startDate", java.sql.Date.valueOf(startDate));
            }

            totalRecords = query.getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalRecords;
    }

//-------------------------- REJECTED --------------------------------
 // List Rejected Records
    @SuppressWarnings("unchecked")
    public List<RecordViolation> getListRVRejected(int page, int size) {
        List<RecordViolation> list = new ArrayList<>();
        try (Session session = HibernateConnection.doHibernateConnection().openSession()) {
            int offset = (page - 1) * size;

            list = session.createQuery("FROM RecordViolation rv " +
                                       "WHERE rv.status_type = 'ไม่อนุมัติหักคะแนนพฤติกรรม' " +
                                       "ORDER BY rv.record_date DESC", 
                                       RecordViolation.class)
                          .setFirstResult(offset)
                          .setMaxResults(size)
                          .list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Search Rejected Records
    public List<RecordViolation> getSearchRecordViolationRejected(String searchText, String startDate, int page, int size) {
        List<RecordViolation> list = new ArrayList<>();
        SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
        try (Session session = sessionfactory.openSession()) {
            session.beginTransaction();

            int offset = (page - 1) * size;

            String hql = "FROM RecordViolation rv WHERE rv.status_type = 'ไม่อนุมัติหักคะแนนพฤติกรรม' AND " +
                         "(rv.student.student_id LIKE :searchText " +
                         "OR rv.student.firstname LIKE :searchText " +
                         "OR rv.student.major LIKE :searchText " +
                         "OR rv.student.faculty LIKE :searchText) ";

            if (startDate != null && !startDate.isEmpty()) {
                hql += "AND DATE(rv.record_date) = :startDate ";
            }

            hql += "ORDER BY rv.record_date DESC";

            Query<RecordViolation> query = session.createQuery(hql, RecordViolation.class)
                                                   .setParameter("searchText", "%" + searchText + "%")
                                                   .setFirstResult(offset)
                                                   .setMaxResults(size);

            if (startDate != null && !startDate.isEmpty()) {
                query.setParameter("startDate", java.sql.Date.valueOf(startDate))
										                	 .setFetchSize(offset)
										                	 .setMaxResults(size);
            }

            list = query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get Total Rejected Records
    public long getTotalRVRejected() {
        long count = 0;
        try (Session session = HibernateConnection.doHibernateConnection().openSession()) {
            count = (long) session.createQuery("SELECT COUNT(r) FROM RecordViolation r WHERE r.status_type = 'ไม่อนุมัติหักคะแนนพฤติกรรม'").uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // Get Total Search Rejected Records
    public long getTotalSearchRVRejected(String searchText, String startDate) {
        long totalRecords = 0;
        SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
        try (Session session = sessionfactory.openSession()) {
            session.beginTransaction();

            String hql = "SELECT COUNT(rv) FROM RecordViolation rv WHERE rv.status_type = 'ไม่อนุมัติหักคะแนนพฤติกรรม' AND " +
                         "(rv.student.student_id LIKE :searchText " +
                         "OR rv.student.firstname LIKE :searchText " +
                         "OR rv.student.major LIKE :searchText " +
                         "OR rv.student.faculty LIKE :searchText) ";

            if (startDate != null && !startDate.isEmpty()) {
                hql += "AND rv.record_date = :startDate ";
            }

            Query<Long> query = session.createQuery(hql, Long.class)
                                       .setParameter("searchText", "%" + searchText + "%");

            if (startDate != null && !startDate.isEmpty()) {
                query.setParameter("startDate", java.sql.Date.valueOf(startDate));
            }

            totalRecords = query.getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalRecords;
    }
    
    
//-------------------------- STATISTIC --------------------------------    
// Get Count by Type: Dynamic Date Range
    public Map<String, Long> getCountRVByTypeBetweenDates(String startDate, String endDate) {
        Map<String, Long> countByType = new HashMap<>();
        try (Session session = HibernateConnection.doHibernateConnection().openSession()) {
            List<Object[]> results = session.createQuery(
                "SELECT vt.violation_name, COUNT(r.id) " +
                "FROM RecordViolation r JOIN r.violationType vt " +
                "WHERE DATE(r.record_date) BETWEEN DATE(:startDate) AND DATE(:endDate) " +
                "GROUP BY vt.violation_name", 
                Object[].class
            )
            .setParameter("startDate", startDate)
            .setParameter("endDate", endDate)
            .list();
            
            for (Object[] result : results) {
                String violationName = (String) result[0];
                Long count = (Long) result[1];
                countByType.put(violationName, count);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return countByType;
    }

// Get Total Count: Dynamic Date Range
    public long getTotalRVBetweenDates(String startDate, String endDate) {
        long count = 0;
        try (Session session = HibernateConnection.doHibernateConnection().openSession()) {
            count = (long) session.createQuery(
                "SELECT COUNT(r) " +
                "FROM RecordViolation r " +
                "WHERE DATE(r.record_date) BETWEEN DATE(:startDate) AND DATE(:endDate)"
            )
            .setParameter("startDate", startDate)
            .setParameter("endDate", endDate)
            .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
        
    }

    
    
}
