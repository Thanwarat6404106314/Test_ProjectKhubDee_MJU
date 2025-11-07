class Student {
  String? student_id;
  String? firstname;
  String? lastname;
  int? student_score;
  String? major;
  String? faculty;
  String? img_student;
  String? email;
  String? password;

  Student(
      {this.student_id,
      this.firstname,
      this.lastname,
      this.student_score,
      this.major,
      this.faculty,
      this.img_student,
      this.email,
      this.password});

  Map<String, dynamic> fromStudentToJson() {
    return <String, dynamic>{
      'student_id': student_id,
      'firstname': firstname,
      'lastname': lastname,
      'student_score': student_score,
      'major': major,
      'faculty': faculty,
      'img_student': img_student,
      'email': email,
      'password': password,
    };
  }

  factory Student.fromJsonToStudent(Map<String, dynamic> json) => Student(
      student_id: json['student_id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      student_score: json['student_score'],
      major: json['major'],
      faculty: json['faculty'],
      img_student: json['img_student'],
      email: json['email'],
      password: json['password']);
}
