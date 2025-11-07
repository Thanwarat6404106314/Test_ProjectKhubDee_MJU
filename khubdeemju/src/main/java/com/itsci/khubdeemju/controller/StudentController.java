package com.itsci.khubdeemju.controller;

import com.itsci.khubdeemju.model.Student;
import com.itsci.khubdeemju.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.*;

@RestController
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private StudentService studentService;

    private final String img_student_FOLDER_PATH = "C:/img/img_student/";

    @GetMapping("/getbyemail/{email}")
    public ResponseEntity getStudentByEmail(@PathVariable("email") String email) throws IllegalStateException{
        try{
            Student student = studentService.getStudentByEmail(email);
            return new ResponseEntity<>(student, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("ชื่อผู้ใช้หรืออีเมลไม่ถูกต้อง!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/getbyid/{student_id}")
    public ResponseEntity getStudentById(@PathVariable("student_id") String student_id) throws IllegalStateException{
        try{
            Student student = studentService.getStudentById(student_id);
            return new ResponseEntity<>(student, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("Failed to get By Id Student data!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/add")
    public ResponseEntity addStudent(@RequestBody Map<String,String> map){
        try{
            Student student = studentService.addStudent(map);
            return new ResponseEntity<>(student, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/update")
    public ResponseEntity updateStudent(@RequestBody Student student){
        try {
            Student updateStudent = studentService.updateStudent(student);
            return  new  ResponseEntity<>(updateStudent, HttpStatus.OK);

        }catch (Exception e){
            e.printStackTrace();
            return  new ResponseEntity<>("Failed to update Member data!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/list")
    public ResponseEntity getListStudent(){
        try{
            List<Student> student =  studentService.getListStudents();
            return new ResponseEntity<>(student, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping("/loginstudent")
    public ResponseEntity LoginStudent(@RequestBody Map<String,String> map) throws IllegalStateException{
        try{
            Student student = studentService.doLoginStudent(map);
            if(student != null){
                return new ResponseEntity<>(student,HttpStatus.OK);
            }else{
                return new ResponseEntity<>("This email wasn't found in the database",HttpStatus.FORBIDDEN);
            }
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("Login Failed!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @DeleteMapping("/delete/{student_id}")
    public ResponseEntity deleteStudent(@PathVariable("student_id") String student_id) {
        try {
            studentService.deleteStudent(student_id);
            return new ResponseEntity<>("student ID " + student_id + " was deleted!", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Failed to delete!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/upload")
    public String uploadImgStudent(@RequestParam("images") MultipartFile[] images) throws IOException {
        StringBuilder fileNames = new StringBuilder();
        for (MultipartFile image : images) {
            String newFileName = System.currentTimeMillis() + "_" + image.getOriginalFilename();
            File destFile = new File(img_student_FOLDER_PATH + newFileName);
            image.transferTo(destFile);
            fileNames.append(newFileName).append(",");
        }
        // ตัด "," ที่ต่อท้ายออกจาก fileNames
        if (fileNames.length() > 0) {
            fileNames.deleteCharAt(fileNames.length() - 1);
        }
        return img_student_FOLDER_PATH + fileNames.toString();
    }

    @PutMapping("/updateimage/{student_id}")
    public ResponseEntity<String> updateStudentImage(@PathVariable("student_id") String student_id,@RequestParam("img_student") MultipartFile file) {
        try {
            studentService.updateStudentImage(student_id, file);
            return new ResponseEntity<>("Update succeed!", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("Failed to update!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


}
