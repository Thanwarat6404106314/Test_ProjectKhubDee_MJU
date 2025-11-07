import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_final/controller/NewsController.dart';
import 'package:project_final/model/news.dart';
import 'package:project_final/screens/news_detail_screen.dart';
import 'package:project_final/widgets/homepage/homeSliderIndicator.dart';
import 'package:project_final/widgets/homepage/homeSliderItem.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  List<News>? newsList;
  final NewsController newsController = NewsController();

  late final ScrollController _scrollController;
  late final double _indicatorVisibleWidth;

  late final PageController _pageController;
  late Timer _timer;
  int _pageIndex = 0;

  final _displayIndicatorCount = 5.0;
  final _indicatorWidth = 10.0;
  final _activeIndicatorWidth = 32.0;
  final _indicatorMargin = const EdgeInsets.symmetric(horizontal: 1);

  Future<void> _loadNews() async {
    newsController.getListNews().then((news) {
      setState(() {
        newsList = news;
      });
    }).catchError((error) {
      setState(() {
        newsList = null;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1000);
    _scrollController =
        ScrollController(initialScrollOffset: _calculateIndicatorOffset());
    _indicatorVisibleWidth = _calculateIndicatorWidth();
    _loadNews();

    // ตั้ง Timer เพื่อเลื่อน slider อัตโนมัติ
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _timer.cancel(); // ยกเลิก Timer เมื่อไม่ต้องการใช้งานอีกต่อไป
    super.dispose();
  }

  void _onPageChanged(int index, int newsLength) {
    setState(() {
      _pageIndex = index % newsLength;
    });
  }

  double _calculateIndicatorWidth() {
    final indicatorTotalWidth =
        _indicatorWidth + _indicatorMargin.left + _indicatorMargin.right;
    final activeIndicatorTotalWidth =
        _activeIndicatorWidth + _indicatorMargin.left + _indicatorMargin.right;
    return activeIndicatorTotalWidth +
        ((_displayIndicatorCount - 1) * indicatorTotalWidth);
  }

  double _calculateIndicatorOffset() {
    final indicatorsCountBeforeCental = (_displayIndicatorCount - 1) / 2;
    final offset =
        (_indicatorWidth + _indicatorMargin.left + _indicatorMargin.right) *
            (_pageIndex + 999 - indicatorsCountBeforeCental);
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    if (newsList == null) {
      return Center(child: CircularProgressIndicator());
    } else if (newsList!.isEmpty) {
      return Center(
        child: Text('ไม่พบข้อมูล',style: TextStyle(fontFamily: 'Mitr'),
      ));
    } else {
      final news = newsList!;
      return Column(
        children: [
          SizedBox(
            height: 175,
            child: PageView.builder(
              onPageChanged: (value) {
                _onPageChanged(value, news.length);
                _scrollController.animateTo(_calculateIndicatorOffset(),
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn);
              },
              controller: _pageController,
              itemCount: news.length * 1000,
              itemBuilder: (context, index) {
                final i = index % news.length;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(news: news[i]),
                      ),
                    );
                  },
                  child: HomeSliderItem(
                    isActive: _pageIndex == i,
                    news: news[i],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: _indicatorVisibleWidth,
            height: _indicatorWidth,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemCount: news.length * 1000,
              itemBuilder: (context, index) {
                return HomeSliderIndicator(
                  isActive: index == _pageIndex + 999,
                  activeWidth: _activeIndicatorWidth,
                  width: _indicatorWidth,
                  magin: _indicatorMargin,
                );
              },
            ),
          ),
        ],
      );
    }
  }
}
