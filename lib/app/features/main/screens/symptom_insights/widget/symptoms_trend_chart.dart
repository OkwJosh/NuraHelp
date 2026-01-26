import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/features/main/controllers/symptom_insight_controller/symptom_insight_controller.dart';
import '../../../../../utilities/constants/colors.dart';

class SymptomTrendChart extends StatelessWidget {
  const SymptomTrendChart({super.key, required this.controller});

  final SymptomInsightController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.chartTrigger.value;
      final spots = controller.symptomSpots;
      final isMonthly = controller.isMonthlyView.value;

      return Column(
        children: [
          AspectRatio(
            aspectRatio: 1.3,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(mainData(spots, isMonthly)),
            ),
          ),
          SizedBox(height: 10),
        ],
      );
    });
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontFamily: 'Poppins-Medium', fontSize: 10);
    Widget text;

    if (controller.isMonthlyView.value) {
      // Monthly view: show week labels at positions 0, 3, 6, 9, 12
      final intValue = value.toInt();
      if (intValue == 0 ||
          intValue == 3 ||
          intValue == 6 ||
          intValue == 9 ||
          intValue == 12) {
        final weekIndex = intValue ~/ 3;
        if (weekIndex < controller.numberOfWeeks) {
          text = Text(controller.getWeekLabel(weekIndex), style: style);
        } else {
          text = const Text('', style: style);
        }
      } else {
        text = const Text('', style: style);
      }
    } else {
      // FIXED: Daily view shows labels at positions 0.5, 2.5, 4.5, 6.5, 8.5, 10.5, 12.5
      // These correspond to day indices 0-6 (chronological order from start date)
      final intValue = value.toInt();
      if (intValue % 2 == 1 && intValue >= 1 && intValue <= 13) {
        final dayIndex = (intValue - 1) ~/ 2; // 1->0, 3->1, 5->2, etc.
        if (dayIndex < 7) {
          // Get the label for this day index (chronologically)
          text = Text(controller.getWeekdayLabel(dayIndex), style: style);
        } else {
          text = const Text('', style: style);
        }
      } else {
        text = const Text('', style: style);
      }
    }

    return SideTitleWidget(
      meta: meta,
      child: Transform.translate(offset: Offset(-10, 10), child: text),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontFamily: 'Poppins-Light', fontSize: 12);
    String text;
    switch (value.toInt()) {
      case 1:
        text = '0';
        break;
      case 4:
        text = '2';
        break;
      case 7:
        text = '4';
        break;
      case 10:
        text = '6';
        break;
      case 13:
        text = '8';
        break;
      case 16:
        text = '10';
      default:
        return Container();
    }

    return Transform.translate(
      offset: Offset(0, 5),
      child: Text(text, style: style, textAlign: TextAlign.left),
    );
  }

  LineChartData mainData(RxMap<String, List<FlSpot>> spots, bool isMonthly) {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 3.3,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.greyColor.withOpacity(0.5),
            strokeWidth: 1,
            dashArray: [5, 5],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          right: BorderSide.none,
          left: BorderSide.none,
          top: BorderSide(
            width: 0.5,
            color: AppColors.greyColor.withOpacity(0.6),
          ),
          bottom: BorderSide(
            width: 0.5,
            color: AppColors.greyColor.withOpacity(0.6),
          ),
        ),
      ),
      minX: 0,
      maxX: 13,
      minY: 0,
      maxY: 16,

      lineBarsData: spots.entries.map((entry) {
        return LineChartBarData(
          spots: entry.value,
          isCurved: false,
          barWidth: 3,
          color: controller.assignColorForSymptom(entry.key),
          dotData: const FlDotData(show: false),
        );
      }).toList(),
    );
  }
}
