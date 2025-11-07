import 'package:flutter/material.dart';
import 'package:project_final/model/news.dart';
import 'package:project_final/widgets/newspage/newsDetailItem.dart';

class NewsDetailScreen extends StatefulWidget {
  final News news;

  const NewsDetailScreen({Key? key, required this.news}) : super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  double _borderRadiusMultiplier = 1;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final maxScreenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: NewsDetailItem(
              news: widget.news,
              minExtent: topPadding + 56,
              maxExtent: maxScreenSizeHeight / 2,
              topPadding: topPadding,
              borderRadiusAnimationValue: (value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _borderRadiusMultiplier = value;
                  });
                });
              },
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: AnimatedContainer(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25 * _borderRadiusMultiplier),
                color: Colors.white,
              ),
              duration: Duration(milliseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.news.officer?.firstname} ${widget.news.officer?.lastname}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Mitr', // ใช้ฟอนต์ Mitr
                    ),
                  ),
                  Divider(),
                  Text(
                    '${widget.news.description}',
                    style: TextStyle(
                      fontFamily: 'Mitr', // ใช้ฟอนต์ Mitr
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
