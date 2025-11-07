class Officer {
  String? officer_id;
  String? firstname;
  String? lastname;
  String? position;
  String? signature;
  String? img_officer;
  String? email;
  String? password;

  Officer(
      {this.officer_id,
      this.firstname,
      this.lastname,
      this.position,
      this.signature,
      this.img_officer,
      this.email,
      this.password});

  Map<String, dynamic> fromOfficerToJson() {
    return <String, dynamic>{
      'officer_id': officer_id,
      'firstname': firstname,
      'lastname': lastname,
      'position': position,
      'signature': signature,
      'img_officer' : img_officer,
      'email': email,
      'password': password,
    };
  }

  factory Officer.fromJsonToOfficer(Map<String, dynamic> json) => Officer(
        officer_id: json['officer_id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        position: json['position'],
        signature: json['signature'],
        img_officer: json['img_officer'],
        email: json['email'],
        password: json['password'],
      );
}
