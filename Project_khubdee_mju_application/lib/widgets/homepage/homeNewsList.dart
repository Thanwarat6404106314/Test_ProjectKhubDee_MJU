import 'package:flutter/material.dart';
import 'package:project_final/controller/NewsController.dart';
import 'package:project_final/model/news.dart';
import 'package:project_final/screens/news_detail_screen.dart';
import 'package:project_final/widgets/homepage/homeNewsListItem.dart';

class HomeNewsList extends StatefulWidget {
  const HomeNewsList({super.key});

  @override
  State<HomeNewsList> createState() => _HomeNewsListState();
}

class _HomeNewsListState extends State<HomeNewsList> {
  final NewsController newsController = NewsController();
  List<News>? newsList;

  Future<void> _loadNews() async {
    try {
      final news = await newsController.getListNews();
      setState(() {
        newsList = news;
      });
    } catch (error) {
      setState(() {
        newsList = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  @override
  Widget build(BuildContext context) {
    if (newsList == null) {
      return Center(child: CircularProgressIndicator());
    } else if (newsList!.isEmpty) {
      return Center(child: Text('ไม่พบข้อมูล'));
    } else {
      return Container(
        child: Column(
          children: newsList!.take(5).map((news) { // จำกัดจำนวนข่าวที่จะแสดงเพียง 5 ข่าว
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(news: news),
                  ),
                );
              },
              child: HomeNewsListItem(news: news),
            );
          }).toList(),
        ),
      );
    }
  }
}
