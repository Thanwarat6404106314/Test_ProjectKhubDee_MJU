package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.Student;
import com.itsci.khubdeemju.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.*;

@Service
public class StudentServiceImpl implements StudentService {

    @Autowired
    private StudentRepository studentRepository;

    public StudentServiceImpl(StudentRepository studentRepository) {
        this.studentRepository = studentRepository;
    }


    @Override
    public Student getStudentByEmail(String email) {
        return studentRepository.getStudentByEmail(email);
    }

    @Override
    public Student getStudentById(String student_id) {
        return studentRepository.getReferenceById(student_id);
    }

    private final String img_student_FOLDER_PATH = "C:/img/img_student/";

    @Override
    public Student addStudent(Map<String, String> map) {
        String student_id = map.get("student_id");
        String firstname = map.get("firstname");
        String lastname = map.get("lastname");
        String major = map.get("major");
        String faculty = map.get("faculty");
        Integer student_score = Integer.parseInt(map.get("student_score"));
        String img_student = map.get("img_student");
        String email = map.get("email");
        String password = map.get("password");

        Student student = new Student(student_id,firstname,lastname,major,faculty, student_score, img_student,email,password);
        return studentRepository.save(student);
    }

    @Override
    public Student updateStudent(Student student) {
        return studentRepository.save(student);
    }

    @Override
    public List<Student> getListStudents() {
        return studentRepository.findAll();
    }

    @Override
    public Student doLoginStudent(Map<String, String> map) {
        String email = map.get("email");
        String password = map.get("password");

        Student student = studentRepository.getStudentByEmail(email);
        if (student != null && student.getPassword().equals(password)) {
            return student;
        }else {
            return null;
        }
    }

    @Override
    public void deleteStudent(String student_id) {
        Student student =studentRepository.getReferenceById(student_id);
        studentRepository.delete(student);
    }

    @Override
    public String uploadImgStudent(MultipartFile file) throws IOException {
        System.out.println("FILE NAME IS : " + file.getOriginalFilename());
        String newFileName = System.currentTimeMillis() + ".png";
        file.transferTo(new File(img_student_FOLDER_PATH + newFileName));
        return img_student_FOLDER_PATH + newFileName;
    }

    @Override
    public Student updateStudentImage(String student_id, MultipartFile file) throws IOException {
        Student student = studentRepository.getReferenceById(student_id);
//        System.out.println("SS: " + student.getStudent_id());
        String img_student = uploadImgStudent(file);
        studentRepository.updateImgStudent(student_id,img_student);
        student.setImg_student(img_student);
        return student;
    }

}

