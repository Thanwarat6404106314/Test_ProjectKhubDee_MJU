package com.springmvc.manager;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import com.springmvc.model.*;

public class StudentManager {
	
	@SuppressWarnings("unchecked")
	public List<Student> getListStudent() {
		List<Student> list = new ArrayList<>();
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();

			list = session.createQuery("FROM Student ORDER BY student_id ASC").list();

			session.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public Student getStudentByID(String student_id) {
		Student student = null;
		try {
			SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
			Session session = sessionfactory.openSession();
			session.beginTransaction();

			@SuppressWarnings("unchecked")
			List<Student> list = session.createQuery("FROM Student WHERE student_id = '" + student_id + "'").list();
			student = list.get(0);

			session.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return student;
	}
	
	public List<Student> getSearchStudent(String searchtext) {
	    List<Student> list = new ArrayList<>();
	    try {
	        SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
	        Session session = sessionfactory.openSession();
	        session.beginTransaction();
	        list = session.createQuery("FROM Student WHERE student_id LIKE '%" + searchtext + "%' "
	        		+ "OR major LIKE '%" + searchtext + "%'"
	        		+ "OR faculty LIKE '%" + searchtext + "%'").list();
	        
	        session.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public boolean deductStudentScore(String student_id, int deductScore) {
        try {
            SessionFactory sessionfactory = HibernateConnection.doHibernateConnection();
            Session session = sessionfactory.openSession();
            session.beginTransaction();

            Student student = session.get(Student.class, student_id);
            if (student != null) {
                // หักคะแนน และป้องกันคะแนนติดลบ
                int currentScore = student.getStudent_score(); 
                student.setStudent_score(Math.max(currentScore - deductScore, 0)); 
                session.update(student);

                session.getTransaction().commit();
            }
            session.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

	
	
	
}
