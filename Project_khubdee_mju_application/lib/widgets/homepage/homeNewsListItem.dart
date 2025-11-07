import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_final/model/news.dart';
import 'package:project_final/constants/constant_value.dart';

class HomeNewsListItem extends StatelessWidget {
  final News news;

  const HomeNewsListItem({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final postDate = DateFormat('dd MMM yyyy').format(DateTime.parse('${news.post_date}'));
    // เพิ่มส่วนนี้เพื่อเรียกให้รูปภาพผ่าน URL ซึ่งใช้รูปที่มาจาก Folder: C:file:///C:/img/img_news
    const String imageURL = baseURL + "/img_news/";

    List<String> images = news.image!.split(',');
    String newsImages = images[0];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              '$imageURL${newsImages}',
              width: 90,
              height: 65,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${news.title}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Mitr'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Text('${news.officer?.firstname} ${news.officer?.lastname} • $postDate',
                        style: TextStyle(fontSize: 12, fontFamily: 'Mitr')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
