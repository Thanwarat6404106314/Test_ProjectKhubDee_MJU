package com.itsci.khubdeemju.controller;

import com.itsci.khubdeemju.model.RecordViolation;
import com.itsci.khubdeemju.service.RecordViolationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.*;

@RestController
@RequestMapping("/recordviolation")
public class RecordViolationController {
    private final String picture_evidence_FOLDER_PATH = "C:/img/picture_evidence/";

    @Autowired
    private RecordViolationService recordViolationService;

    @GetMapping("/getbyid/{record_id}")
    public ResponseEntity getRecordViolationById(@PathVariable("record_id") String record_id) throws IllegalStateException{
        try{
            RecordViolation recordViolation = recordViolationService.getRecordViolationById(record_id);
            return new ResponseEntity<>(recordViolation, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("รหัสบันทึกการละเมิดไม่ถูกต้อง!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/add")
    public ResponseEntity addRecordViolation(@RequestBody Map<String,String> map){
        try{
            RecordViolation recordViolation = recordViolationService.addRecordViolation(map);
            return new ResponseEntity<>(recordViolation, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("Failed to add RecordViolation Data!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/list")
    public ResponseEntity getListRecordViolation(){
        try{
            List<RecordViolation> recordViolation =  recordViolationService.getListRecordViolation();
            return new ResponseEntity<>(recordViolation, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/list/{student_id}")
    public ResponseEntity getListRecordViolationByStudentId(@PathVariable("student_id") String student_id){
        try {
            List<RecordViolation> recordViolation =  recordViolationService.getListRecordViolationByStudentId(student_id);
            return new ResponseEntity<>(recordViolation, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("ไม่พบข้อมูลรายการละเมิดกฎจราจรสำหรับนักศึกษารหัส " + student_id, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/update")
    public ResponseEntity updateRecordViolation(@RequestBody RecordViolation recordViolation){
        try {
            RecordViolation updateRecordViolation = recordViolationService.updateRecordViolation(recordViolation);
            return new ResponseEntity<>(updateRecordViolation, HttpStatus.OK);

        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("Failed to update Record Violation data!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @DeleteMapping("/delete/{record_id}")
    public ResponseEntity deleteNews(@PathVariable("record_id") String record_id) {
        try {
            recordViolationService.deleteRecordViolation(record_id);
            return new ResponseEntity<>("record ID " + record_id + " was deleted!", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Failed to delete!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/upload")
    public ResponseEntity<?> uploadPictureEvidence(@RequestParam("images") MultipartFile image) {
        try {
            String imagePath = recordViolationService.uploadPictureEvidence(image);
            return ResponseEntity.ok().body(imagePath);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to upload image");
        }
    }

    public byte[] downloadPictureEvidence(@PathVariable("filePath") String filePath) throws IOException {
        byte[] image = Files.readAllBytes(recordViolationService.downloadPictureEvidence(filePath));
        return image;
    }

}
