package com.itsci.khubdeemju.repository;

import com.itsci.khubdeemju.model.RecordViolation;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RecordViolationRepository extends JpaRepository<RecordViolation, String> {

    @Transactional
    @Modifying
    @Query(value = "SELECT * FROM RecordViolation WHERE student_id = :student_id", nativeQuery = true)
    List<RecordViolation> findByStudent(@Param("student_id") String student_id);

    @Query("FROM RecordViolation rv JOIN rv.student s WHERE s.student_id = :student_id ORDER BY rv.record_date DESC")
    List<RecordViolation> findRecordViolationByStudentID(@Param("student_id") String student_id);


}
