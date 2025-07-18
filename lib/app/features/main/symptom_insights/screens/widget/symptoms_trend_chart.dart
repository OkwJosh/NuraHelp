import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../utilities/constants/colors.dart';

class SymptomTrendChart extends StatefulWidget {
  const SymptomTrendChart({super.key});

  @override
  State<SymptomTrendChart> createState() => _SymptomTrendChartState();
}

class _SymptomTrendChartState extends State<SymptomTrendChart> {
  List<Color> gradientColors = [AppColors.secondaryColor, Colors.white];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.2,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(showAvg ? avgData() : mainData()),
          ),
        ),
        SizedBox(height: 10),
        // SizedBox(
        //   width: 60,
        //   height: 34,
        //   child: TextButton(
        //     onPressed: () {
        //       setState(() {
        //         showAvg = !showAvg;
        //       });
        //     },
        //     child: Text(
        //       'avg',
        //       style: TextStyle(
        //         fontSize: 12,
        //         color: showAvg
        //             ? Colors.white.withValues(alpha: 0.5)
        //             : Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontFamily: "Poppins-ExtraLight", fontSize: 12);
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('Mon', style: style);
        break;
      case 3:
        text = const Text('Tue', style: style);
        break;
      case 5:
        text = const Text('Wed', style: style);
        break;
      case 7:
        text = const Text('Thu', style: style);
        break;
      case 9:
        text = const Text('Fri', style: style);
        break;
      case 11:
        text = const Text('Sat', style: style);
        break;
      case 13:
        text = const Text('Sun', style: style);
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
    const style = TextStyle(fontFamily: "Poppins-ExtraLight", fontSize: 12);
    String text;
    switch (value.toInt()) {
      case 1:
        text = '0';
        break;
      case 4:
        text = '50';
        break;
      case 7:
        text = '100';
        break;
      case 10:
        text = '200';
        break;
      case 13:
        text = '400';
        break;
      default:
        return Container();
    }

    return Transform.translate(
      offset: Offset(0, 10),
      child: Text(text, style: style, textAlign: TextAlign.left),
    );
  }

  LineChartData mainData() {
    return LineChartData(
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
      maxY: 13,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 0),
            FlSpot(10.5, 4),
            FlSpot(13, 13),
          ],
          isCurved: false,
          // gradient: LinearGradient(colors: gradientColors),
          barWidth: 2,
          color: AppColors.deepSecondaryColor,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: false,
            // gradient: LinearGradient(
            //   colors: gradientColors
            //       .map((color) => color.withValues(alpha: 0.15))
            //       .toList(),
            // ),
          ),
        ),
        LineChartBarData(
          spots: const [
            FlSpot(0.5, 0),
            FlSpot(3, 2),
            FlSpot(4, 6),
            FlSpot(6.6, 9),
            FlSpot(7, 4),
            FlSpot(8, 3),
            FlSpot(10, 9),
            FlSpot(13, 4),
          ],
          isCurved: false,
          // gradient: LinearGradient(colors: gradientColors),
          barWidth: 2,
          color: Colors.purpleAccent,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: false,
            // gradient: LinearGradient(
            //   colors: gradientColors
            //       .map((color) => color.withValues(alpha: 0.15))
            //       .toList(),
            // ),
          ),
        ),
        LineChartBarData(
          spots: const [
            FlSpot(0, 6),
            FlSpot(3, 6),
            FlSpot(4.5, 8),
            FlSpot(6.0, 3),
            FlSpot(8, 0),
            FlSpot(8, 0),
            FlSpot(10.5, 0),
            FlSpot(13, 2.5),
          ],
          isCurved: false,
          // gradient: LinearGradient(colors: gradientColors),
          barWidth: 2,
          color: Colors.orange,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: false,
            // gradient: LinearGradient(
            //   colors: gradientColors
            //       .map((color) => color.withValues(alpha: 0.15))
            //       .toList(),
            // ),
          ),
        ),
        LineChartBarData(
          spots: const [
            FlSpot(0, 8),
            FlSpot(2, 8),
            FlSpot(4, 8),
            FlSpot(7.5, 5),
            FlSpot(9.5, 10),
            FlSpot(10, 9),
            FlSpot(11.5, 4),
            FlSpot(13, 0),
          ],
          isCurved: false,
          // gradient: LinearGradient(colors: gradientColors),
          barWidth: 2,
          color: Colors.greenAccent,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: false,
            // gradient: LinearGradient(
            //   colors: gradientColors
            //       .map((color) => color.withValues(alpha: 0.15))
            //       .toList(),
            // ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      backgroundColor: Colors.white,
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 3);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(
                begin: gradientColors[0],
                end: gradientColors[1],
              ).lerp(0.2)!,
              ColorTween(
                begin: gradientColors[0],
                end: gradientColors[1],
              ).lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(
                  begin: gradientColors[0],
                  end: gradientColors[1],
                ).lerp(0.2)!.withValues(alpha: 0.1),
                ColorTween(
                  begin: gradientColors[0],
                  end: gradientColors[1],
                ).lerp(0.2)!.withValues(alpha: 0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
