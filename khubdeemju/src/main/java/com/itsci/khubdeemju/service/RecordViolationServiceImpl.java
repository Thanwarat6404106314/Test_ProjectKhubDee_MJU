package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.*;
import com.itsci.khubdeemju.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class RecordViolationServiceImpl implements RecordViolationService {

    @Autowired
    private RecordViolationRepository recordViolationRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private OfficerRepository officerRepository;

    @Autowired
    private ViolationTypeRepository violationTypeRepository;

    @Autowired
    private LocationRepository locationRepository;

    public RecordViolationServiceImpl(RecordViolationRepository recordViolationRepository) {
        this.recordViolationRepository = recordViolationRepository;
    }

    @Override
    public Student getStudentById(String student_id) {
        return studentRepository.getReferenceById(student_id);
    }

    @Override
    public Officer getOfficerById(String officer_id) {
        return officerRepository.getReferenceById(officer_id);
    }

    @Override
    public ViolationType getViolationTypeById(String violation_id) {
        return violationTypeRepository.getReferenceById(violation_id);
    }

    @Override
    public Location getLocationById(String location_id) {
        return locationRepository.getReferenceById(location_id);
    }

    private final String Picture_Evidence_FOLDER_PATH = "C:/img/picture_evidence/";

    @Override
    public RecordViolation getRecordViolationById(String record_id) {
        return recordViolationRepository.getReferenceById(record_id);
    }

    @SuppressWarnings("unused")
    @Override
    public RecordViolation addRecordViolation(Map<String, String> map) throws ParseException {
        SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss", Locale.US);

//      รูปแบบวันที่
        Date record_date;
        try {
            record_date = format.parse(map.get("record_date"));
//            System.out.println("วันที่และเวลาที่แปลงแล้ว: " + record_date);
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
        String picture_evidence = map.get("picture_evidence");
        String status_type = "กำลังพิจารณา";

//        Date deduct_date = null;

        String student_id = map.get("student");
        if (student_id == null) {
            throw new IllegalArgumentException("Student ID ว่างเปล่า");
        }
        Integer remaining_score = getStudentById(student_id).getStudent_score();

        String officer_id = map.get("officer");
        if (student_id == null) {
            throw new IllegalArgumentException("Officer ID ว่างเปล่า");
        }

        Student student = getStudentById(student_id);
        Officer officer = getOfficerById(officer_id);

        // กำหนด deduct_no โดยเพิ่ม 1 ถ้ามีบันทึกแล้ว
        List<RecordViolation> existingViolations = recordViolationRepository.findByStudent(student_id);
        int deduct_no = 1; // ค่าเริ่มต้นเป็น 1
        if (existingViolations != null && !existingViolations.isEmpty()) {
            // ถ้าพบข้อมูลการละเมิดแล้ว เพิ่ม deduct_no ตามจำนวนการละเมิดที่พบ
            deduct_no = existingViolations.size() + 1;
        }

        String location_id = map.get("location");
        if (location_id == null) {
            throw new IllegalArgumentException("Location ID ว่างเปล่า");
        }
        Location location = getLocationById(location_id);

        String violation_id = map.get("violationType");
        if (violation_id == null) {
            throw new IllegalArgumentException("Violation Type ID ว่างเปล่า");
        }
        ViolationType violationType = getViolationTypeById(violation_id);

        RecordViolation recordViolation = new RecordViolation(null, record_date, remaining_score, picture_evidence, status_type, deduct_no, null, student, officer,  location, violationType);
        return recordViolationRepository.save(recordViolation);
    }

    @Override
    public List<RecordViolation> getListRecordViolationByStudentId(String student_id) {
        return recordViolationRepository.findRecordViolationByStudentID(student_id);
    }

    @Override
    public List<RecordViolation> getListRecordViolation() {
        return recordViolationRepository.findAll();
    }

    @Override
    public RecordViolation updateRecordViolation(RecordViolation recordViolation) {
        return recordViolationRepository.save(recordViolation);
    }

    @Override
    public void deleteRecordViolation(String record_id) {
        RecordViolation recordViolation = recordViolationRepository.getReferenceById(record_id);
        recordViolationRepository.delete(recordViolation);
    }

//    แก้ส่วนนี้ก่อน
    public String uploadPictureEvidence(MultipartFile file) throws IOException {
        Date dd = new Date();
        Calendar c1 = Calendar.getInstance();
        c1.setTime(dd);
        dd = c1.getTime();
        String date1 = new SimpleDateFormat("dd-MM-yyyy-HH.mm.ss").format(dd);
        String newFilename = "RC_" + date1 + ".png";
        file.transferTo(new File(Picture_Evidence_FOLDER_PATH + newFilename));
        return newFilename;
    }

    @Override
    public Path downloadPictureEvidence(String filePath) {
        return new File(Picture_Evidence_FOLDER_PATH + filePath).toPath();
    }
}
