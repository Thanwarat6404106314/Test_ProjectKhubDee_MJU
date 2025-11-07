package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.Location;
import com.itsci.khubdeemju.model.Officer;
import com.itsci.khubdeemju.model.RecordViolation;
import com.itsci.khubdeemju.model.Student;
import com.itsci.khubdeemju.model.ViolationType;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Path;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

public interface RecordViolationService {

    RecordViolation getRecordViolationById(String record_id);

    Student getStudentById(String student_id);

    Officer getOfficerById(String officer_id);

    ViolationType getViolationTypeById(String violation_id);

    Location getLocationById(String location_id);

    RecordViolation addRecordViolation (Map<String,String> map) throws ParseException;

    List<RecordViolation> getListRecordViolation();

    List<RecordViolation> getListRecordViolationByStudentId(String student_id);

    RecordViolation updateRecordViolation(RecordViolation recordViolation);

    void deleteRecordViolation(String record_id);

    String uploadPictureEvidence(MultipartFile file) throws IOException;

    Path downloadPictureEvidence(String filePath);

}
