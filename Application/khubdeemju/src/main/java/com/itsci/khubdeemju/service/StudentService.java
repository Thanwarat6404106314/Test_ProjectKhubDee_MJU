package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.Student;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.text.ParseException;
import java.util.*;

public interface StudentService {

    Student getStudentByEmail (String email);

    Student getStudentById(String student_id);

    Student addStudent(Map<String, String> map) throws ParseException;

    Student updateStudent(Student student);

    List<Student> getListStudents();

    Student doLoginStudent(Map<String, String> map);

    void deleteStudent(String student_id);

    String uploadImgStudent(MultipartFile file) throws IOException;

    Student updateStudentImage(String student_id, MultipartFile file) throws IOException;
}
