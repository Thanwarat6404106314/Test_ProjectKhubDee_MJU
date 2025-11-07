import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_final/model/news.dart';
import 'package:project_final/constants/constant_value.dart';

class HomeSliderItem extends StatelessWidget {
  final bool isActive;
  final News news;

  const HomeSliderItem({super.key, required this.isActive, required this.news});

  @override
  Widget build(BuildContext context) {
    final post_date = DateFormat('dd MMM yyyy').format(DateTime.parse('${news.post_date}'));
    // เพิ่มส่วนนี้เพื่อเรียกให้รูปภาพผ่าน URL ซึ่งใช้รูปที่มาจาก Folder: C:file:///C:/img/img_news
    const String imageURL = baseURL + "/img_news/";

    List<String> images = news.image!.split(',');
    String newsImages = images[0];

    return AnimatedScale(
      duration: Duration(milliseconds: 400),
      scale: isActive ? 1 : 0.92,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // รูป
            Image.network(
              '$imageURL${newsImages}',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x003C3C3C),
                    Color(0x9A161616),
                    Color(0xE1000000)
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // รหัสเจ้าหน้าที่และวันที่
                  Row(
                    children: [
                      Text(
                        '${news.officer?.firstname} ${news.officer?.lastname}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Mitr'),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        post_date,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Mitr'),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // ชื่อข่าว
                  Text(
                    '${news.title}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mitr'),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
