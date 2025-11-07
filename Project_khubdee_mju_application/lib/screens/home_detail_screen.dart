import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:project_final/controller/NewsController.dart';
import 'package:project_final/model/news.dart';
import 'package:project_final/screens/login_screen.dart';
import 'package:project_final/screens/news_detail_screen.dart';
import 'package:project_final/widgets/homepage/homeNewsList.dart';
import 'package:project_final/widgets/homepage/homeSlider.dart';
import 'package:project_final/widgets/homepage/homeStatistis.dart';

class HomeDetailScreen extends StatefulWidget {
  const HomeDetailScreen({Key? key}) : super(key: key);

  @override
  State<HomeDetailScreen> createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  final NewsController newsController = NewsController();
  TextEditingController searchController = TextEditingController();
  List<News>? newsList;
  bool isDataLoaded = false;
  bool hasSearched = false;

  @override
  void initState() {
    super.initState();
    fetchNews();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() async {
    if (searchController.text.isEmpty) {
      setState(() {
        hasSearched = false;
        newsList = null;
      });
      fetchNews(); // ดึงข้อมูลข่าวใหม่เมื่อเคลียร์ช่องค้นหา
    } else {
      List<News> news =
          await newsController.getSearchNews(searchController.text);
      setState(() {
        newsList = news;
        isDataLoaded = true;
        hasSearched = true;
      });
    }
  }

  Future fetchNews() async {
    List<News> news = await newsController.getListNews();
    setState(() {
      newsList = news;
      isDataLoaded = true;
    });
  }

  void _clearSearch() {
    searchController.clear();
    setState(() {
      hasSearched = false;
      newsList = null;
    });
    fetchNews();
  }

  void logout() async {
    await SessionManager().remove("email");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) {
        return LoginScreen(); // Navigate to the login screen
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ขับดี มหาวิทยาลัยแม่โจ้",
          style: TextStyle(
            fontFamily: 'Mitr',
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF006D0D),
        elevation: 0,
        actions: [
          onLogout(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 80,
                    color: Color(0xFF006D0D),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 17, // ตำแหน่งจากด้านซ้าย
                  right: 17, // ตำแหน่งจากด้านขวา
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.grey[400]!, // ขอบสีเทา
                        width: 2.0, // ขอบหนาขึ้น
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'ค้นหา',
                        hintStyle: TextStyle(
                            color: Colors.grey[600], fontFamily: 'Mitr'),
                        border: InputBorder.none,
                        prefixIcon: searchController.text.isEmpty
                            ? Icon(
                                Icons.search,
                                color: Colors.grey[600],
                              )
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          color: Colors.grey[600],
                          onPressed: _clearSearch,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasSearched)
                    newsList != null && newsList!.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: newsList!.length,
                            itemBuilder: (context, index) {
                              final news = newsList![index];
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5.0,
                                          spreadRadius: 1.0,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        "${news.title}",
                                        style: TextStyle(fontFamily: 'Mitr'),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                NewsDetailScreen(news: news),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Divider(height: 0.5, color: Colors.grey),
                                ],
                              );
                            },
                          )
                        // กรณี ค้นหาไม่พบข้อมูล
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 30),
                                Icon(
                                  Icons.info_outline,
                                  size: 40.0,
                                  color: Colors.grey[600],
                                ),
                                Text(
                                  'ไม่พบข้อมูลข่าวสาร',
                                  style: TextStyle(fontFamily: 'Mitr'),
                                ),
                              ],
                            ),
                          )
                  else if (!hasSearched && isDataLoaded)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ข่าวยอดนิยม',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Mitr',
                          ),
                        ),
                        SizedBox(height: 16),
                        HomeSlider(),
                        SizedBox(height: 8),
                        Text(
                          'รายการข่าว',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Mitr',
                          ),
                        ),
                        SizedBox(height: 8),
                        HomeNewsList(),
//  MARKKKKK สถิติ
                        Text(
                          'สถิติการละเมิดกฎจราจรประจำปี 2567',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Mitr',
                          ),
                        ),
                        SizedBox(height: 8),
                        HomeStatistic(),
                      ],
                    )
                  else
                    Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget onLogout() {
    return Padding(
       padding: EdgeInsets.only(top: 4, right: 6,),
      child: IconButton(
        icon: Icon(Icons.logout,
            color: Color(0xFFFFFFFF),
            size: 22.25),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('ออกจากระบบ', style: TextStyle(fontFamily: 'Mitr')),
                content: Text('คุณต้องการออกจากระบบหรือไม่?',
                    style: TextStyle(fontFamily: 'Mitr')),
                actions: [
                  SizedBox(
                    width: 100, // Set the width of the button
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF627CFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          Text('ยกเลิก', style: TextStyle(fontFamily: 'Mitr')),
                    ),
                  ),
                  SizedBox(
                    width: 100, // Set the width of the button
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        logout();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('ตกลง', style: TextStyle(fontFamily: 'Mitr')),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 10); // จุดสิ้นสุดของคลื่น
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height - 10);
    path.quadraticBezierTo(
        size.width * 0.75, size.height - 20, size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
