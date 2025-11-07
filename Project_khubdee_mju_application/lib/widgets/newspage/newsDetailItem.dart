import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:project_final/model/news.dart';
import 'package:project_final/widgets/newspage/leadingButton.dart';
import 'package:project_final/widgets/newspage/leadingButtonBlur.dart';
import 'package:project_final/constants/constant_value.dart';

class NewsDetailItem extends SliverPersistentHeaderDelegate {
  final News news;
  final double topPadding;
  final Function(double value) borderRadiusAnimationValue;

  @override
  final double maxExtent;
  @override
  final double minExtent;

  NewsDetailItem({
    required this.news,
    required this.maxExtent,
    required this.minExtent,
    required this.topPadding,
    required this.borderRadiusAnimationValue,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final postDate =
        DateFormat('dd MMM yyyy').format(DateTime.parse('${news.post_date}'));
    final screenWidth = MediaQuery.of(context).size.width;
    const animationDuration = Duration(milliseconds: 200);

    final showCategoryDate = shrinkOffset > 100;
    final calcForTitleAnimations =
        (maxExtent - shrinkOffset - topPadding - 56 - 100) / 100;
    final titleAnimationValue = calcForTitleAnimations > 1.0
        ? 1.0
        : calcForTitleAnimations < 0.0
            ? 0.0
            : calcForTitleAnimations;

    final calcForTopBarAnimations =
        (maxExtent - shrinkOffset - topPadding - 56) / 50;
    final topBarAnimationValue = calcForTopBarAnimations > 1.0
        ? 1.0
        : calcForTopBarAnimations < 0.0
            ? 0.0
            : calcForTopBarAnimations;

    borderRadiusAnimationValue(topBarAnimationValue);
    
    // เพิ่มส่วนนี้เพื่อเรียกให้รูปภาพผ่าน URL ซึ่งใช้รูปที่มาจาก Folder: C:file:///C:/img/img_news
    const String imageURL = baseURL + "/img_news/";

    List<String> images = news.image!.split(',');
    String newsImages = images[0];

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          ('$imageURL${newsImages}'),
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: maxExtent / 2,
            width: screenWidth,
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
        ),
        Positioned(
          bottom: 0,
          child: AnimatedOpacity(
            opacity: titleAnimationValue,
            duration: animationDuration,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Text(
                      '${news.title}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontFamily: 'Mitr', // ใช้ฟอนต์ Mitr
                          ),
                    ),
                  ),
                  AnimatedContainer(
                      duration: animationDuration,
                      height: showCategoryDate ? 10 : 0),
                  AnimatedSwitcher(
                    duration: animationDuration,
                    child: !showCategoryDate
                        ? Text(
                            postDate,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Color(0xFFDADADA),
                                  fontFamily: 'Mitr', // ใช้ฟอนต์ Mitr
                                ),
                          )
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: AnimatedContainer(
            duration: animationDuration,
            height: 56 + topPadding,
            color: Color(0xFF006D0D).withOpacity(1 - topBarAnimationValue),
            width: screenWidth,
            child: Column(
              children: [
                SizedBox(
                  height: topPadding,
                ),
                Row(
                  children: [
                    AnimatedContainer(
                      duration: animationDuration,
                      width: topBarAnimationValue * 10,
                    ),
                    AnimatedCrossFade(
                      duration: animationDuration,
                      crossFadeState: topBarAnimationValue > 0
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: LeadingButtonBlur(
                        iconData: Icons.arrow_back,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      secondChild: LeadingButton(
                        iconData: Icons.arrow_back,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: AnimatedCrossFade(
                          duration: animationDuration,
                          crossFadeState: topBarAnimationValue > 0
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: SizedBox.shrink(),
                          secondChild: Text(
                            '${news.title}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontFamily: 'Mitr', // ใช้ฟอนต์ Mitr
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();
}
