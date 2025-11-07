import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project_final/controller/RecordViolationController.dart';
import 'package:project_final/model/recordviolation.dart';
import 'package:project_final/screens/statistic_detail_screen.dart';

class HomeStatistic extends StatefulWidget {
  const HomeStatistic({super.key});

  @override
  State<HomeStatistic> createState() => _HomeStatisticState();
}

class _HomeStatisticState extends State<HomeStatistic> {
  final RecordViolationController _controller = RecordViolationController();
  List<RecordViolation>? _recordViolationList;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadRecordViolations();
  }

  Future<void> _loadRecordViolations() async {
    try {
      final violations = await _controller.getListRecordViolation();
      setState(() {
        _recordViolationList = violations;
      });
    } catch (e) {
      setState(() {
        _recordViolationList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StatisticDetailScreen(
            recordviolationList: _recordViolationList,
          ),
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.39,
        width: double.infinity,
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _recordViolationList == null
                ? const Center(child: CircularProgressIndicator())
                : _buildPieChart(),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
  if (_recordViolationList!.isEmpty) {
    return Center(child: Text('ไม่มีข้อมูลการละเมิด'));
  }

  final violationCounts = <String, int>{};
  for (var record in _recordViolationList!) {
    final type = record.violationType?.violation_name ?? "ไม่ระบุประเภท";
    violationCounts[type] = (violationCounts[type] ?? 0) + 1;
  }

  // คำนวณจำนวนทั้งหมด
  final total = violationCounts.values.fold(0, (sum, count) => sum + count);

  return Column(
    children: [
      AspectRatio(
        aspectRatio: 1.7,
        child: Row(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 5,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex =
                              pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sectionsSpace: 1,
                    centerSpaceRadius: 30,
                    sections: _generateSections(violationCounts, total),
                  ),
                ),
              ),
            ),
            SizedBox(width: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: violationCounts.keys.map((type) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.1),
                  child: Row(
                    children: [
                      _getIconForType(type),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(width: 30),
          ],
        ),
      ),
      SizedBox(height: 16),
      Text(
        "แตะเพื่อดูรายละเอียดเพิ่มเติม",
        style: TextStyle(fontFamily: 'Mitr', fontSize: 14),
      ),
    ],
  );
}

List<PieChartSectionData> _generateSections(Map<String, int> violationCounts, int total) {
  return violationCounts.entries.map((entry) {
    final index = violationCounts.keys.toList().indexOf(entry.key);
    final isTouched = index == touchedIndex;
    final fontSize = isTouched ? 18.0 : 12.0;
    final radius = isTouched ? 60.0 : 50.0;

    // คำนวณเปอร์เซ็นต์ของแต่ละประเภท
    final percentage = (entry.value / total) * 100;

    return PieChartSectionData(
      color: _getColorForType(entry.key),
      value: percentage,
      title: '${percentage.toStringAsFixed(1)}%', // แสดงเปอร์เซ็นต์
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }).toList();
}


  Color _getColorForType(String type) {
    switch (type) {
      case "ขับขี่ไม่สวมหมวกกันน็อค":
        return Colors.red;
      case "ขับขี่ด้วยความเร็วเกินกำหนด":
        return Colors.orange;
      case "ขับขี่ย้อนศร":
        return Colors.blue;
      case "ขับขี่โดยประมาท":
        return Colors.green;
      // case "ขับขี่ในขณะเสพยาเสพติด":
      //   return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Icon _getIconForType(String type) {
  switch (type) {
    case "ขับขี่ไม่สวมหมวกกันน็อค":
      return Icon(Icons.motorcycle, color: Colors.red); // ไอคอนสำหรับการไม่สวมหมวก
    case "ขับขี่ด้วยความเร็วเกินกำหนด":
      return Icon(Icons.speed, color: Colors.orange); // ไอคอนความเร็ว
    case "ขับขี่ย้อนศร":
      return Icon(Icons.turn_left, color: Colors.blue); // ไอคอนสำหรับการย้อนศร
    case "ขับขี่โดยประมาท":
      return Icon(Icons.dangerous, color: Colors.green); // ไอคอนสำหรับความประมาท
    default:
      return Icon(Icons.help_outline, color: Colors.grey); // ไอคอนสำหรับค่าเริ่มต้น
  }
}

}
