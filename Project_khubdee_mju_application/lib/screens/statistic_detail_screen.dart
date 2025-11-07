import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project_final/model/recordviolation.dart';

class StatisticDetailScreen extends StatelessWidget {
  final List<RecordViolation>? recordviolationList;

  const StatisticDetailScreen({super.key, required this.recordviolationList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ข้อมูลสถิติการละเมิดกฎจราจร',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Mitr',
          ),
        ),
        backgroundColor: const Color(0xFF006D0D),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: recordviolationList == null || recordviolationList!.isEmpty
          ? SingleChildScrollView(
              child: Center(
                child: Text(
                  "ไม่พบข้อมูล",
                  style: TextStyle(fontFamily: 'Mitr'),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "สถิติการละเมิดแต่ละประเภท",
                      style: TextStyle(
                        fontFamily: 'Mitr',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: _buildBarChart(),
                      ),
                    ),
                    buildViolationList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBarChart() {
    if (recordviolationList!.isEmpty) {
      return Center(child: Text('ไม่มีข้อมูลการละเมิด'));
    }

    final violationCounts = <String, int>{};
    for (var record in recordviolationList!) {
      final type = record.violationType?.violation_name ?? "ไม่ระบุประเภท";
      violationCounts[type] = (violationCounts[type] ?? 0) + 1;
    }

    final barGroups = violationCounts.entries
        .map((entry) => BarChartGroupData(
              x: violationCounts.keys.toList().indexOf(entry.key),
              barRods: [
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  color: _getColorForType(entry.key),
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ))
        .toList();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 50,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (_, __, rod, ___) => BarTooltipItem(
                '${rod.toY.toInt()} ครั้ง',
                const TextStyle(color: Colors.white),
              ),
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final violationType =
                      violationCounts.keys.toList()[value.toInt()];
                  return Center(
                    child: _getIconForType(violationType),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
        ),
      ),
    );
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
      default:
        return Colors.grey;
    }
  }

  Widget buildViolationList() {
  final violationCounts = <String, int>{};
  for (var record in recordviolationList!) {
    final type = record.violationType?.violation_name ?? "ไม่ระบุประเภท";
    violationCounts[type] = (violationCounts[type] ?? 0) + 1;
  }

  // คำนวณจำนวนเรคคอร์ดทั้งหมด
  final totalRecords = recordviolationList?.length ?? 0;

  return Padding(
    padding: EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "คำอธิบายประเภทการละเมิด",
          style: TextStyle(
            fontFamily: 'Mitr',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "   ข้อมูลสถิติการละเมิดกฎจราจรของนักศึกษาปี 2567 มีรายละเอียดดังนี้",
          style: const TextStyle(
            fontFamily: 'Mitr',
            fontSize: 14,
          ),
        ),
        SizedBox(height: 10),
        ...violationCounts.entries.map((entry) {
          // คำนวณค่าเฉลี่ย
          final average = totalRecords > 0
              ? (entry.value / totalRecords) * 100 // คำนวณเปอร์เซ็นต์
              : 0;

          return Row(
            children: [
              _getIconForType(entry.key),
              SizedBox(width: 8),
              Text(
                '${entry.key}: ${entry.value} ครั้ง (${average.toStringAsFixed(2)} %)',
                style: const TextStyle(fontFamily: 'Mitr', fontSize: 12),
              ),
            ],
          );
        }).toList(),
      ],
    ),
  );
}


  Icon _getIconForType(String type) {
    switch (type) {
      case "ขับขี่ไม่สวมหมวกกันน็อค":
        return Icon(Icons.motorcycle, color: Colors.red);
      case "ขับขี่ด้วยความเร็วเกินกำหนด":
        return Icon(Icons.speed, color: Colors.orange);
      case "ขับขี่ย้อนศร":
        return Icon(Icons.turn_left, color: Colors.blue);
      case "ขับขี่โดยประมาท":
        return Icon(Icons.dangerous, color: Colors.green);
      default:
        return Icon(Icons.help_outline, color: Colors.grey);
    }
  }
}
