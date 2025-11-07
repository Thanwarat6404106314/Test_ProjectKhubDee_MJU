package com.itsci.khubdeemju.repository;

import com.itsci.khubdeemju.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

public interface StudentRepository extends JpaRepository<Student, String> {

    Student getStudentByEmail(String email);

    @Transactional
    @Modifying
    @Query(value = "UPDATE Student SET img_student = :img_student WHERE student_id = :student_id", nativeQuery = true)
    void updateImgStudent(@Param("student_id") String student_id, @Param("img_student") String img_student);

}
