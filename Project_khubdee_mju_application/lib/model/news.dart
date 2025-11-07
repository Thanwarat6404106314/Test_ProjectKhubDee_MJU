import 'package:project_final/model/officer.dart';

class News {
  String? new_id;
  String? title;
  String? description;
  String? image;
  DateTime? post_date;
  Officer? officer;

  News(
      {this.new_id,
      this.title,
      this.description,
      this.image,
      this.post_date,
      this.officer});

  get length => null;

  Map<String, dynamic> fromNewsToJson() {
    return <String, dynamic>{
      'new_id': new_id,
      'title': title,
      'description': description,
      'image': image,
      'post_date': post_date!.toIso8601String(),
      'officer_id': officer?.fromOfficerToJson(),
    };
  }

  factory News.fromJsonToNews(Map<String, dynamic> json) => News(
      new_id: json['new_id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      post_date: DateTime.parse(json['post_date']),
      officer: Officer.fromJsonToOfficer(json['officer'])
  );
}
