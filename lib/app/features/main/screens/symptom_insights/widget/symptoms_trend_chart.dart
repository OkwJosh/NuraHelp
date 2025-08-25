import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nurahelp/app/features/main/controllers/symptom_insight_controller/symptom_insight_controller.dart';
import '../../../../../utilities/constants/colors.dart';

class SymptomTrendChart extends StatelessWidget {
  SymptomTrendChart({super.key, required this.controller});

  final SymptomInsightController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        controller.chartTrigger.value;
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
                  child: LineChart(mainData()),
                ),
              ),
              SizedBox(height: 10),
            ],
          );
        }
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontFamily: 'Poppins-Medium', fontSize: 10);
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('MON', style: style);
        break;
      case 3:
        text = const Text('TUE', style: style);
        break;
      case 5:
        text = const Text('WED', style: style);
        break;
      case 7:
        text = const Text('THU', style: style);
        break;
      case 9:
        text = const Text('FRI', style: style);
        break;
      case 11:
        text = const Text('SAT', style: style);
        break;
      case 13:
        text = const Text('SUN', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
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

  LineChartData mainData() {
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
      lineBarsData: controller.symptomSpots.entries.map((entry) {
        return LineChartBarData(
          spots: entry.value,
          isCurved: true,
          barWidth: 3,
          color: controller.assignColorForSymptom(entry.key),
          dotData: const FlDotData(show: true),
        );
      }).toList(),
    );
  }
}
