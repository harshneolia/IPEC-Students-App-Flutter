import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repo/session.dart';
import '../../../theme/colors.dart';

class AttendanceGraph extends StatefulWidget {
  @override
  _AttendanceGraphState createState() => _AttendanceGraphState();
}

class _AttendanceGraphState extends State<AttendanceGraph> {
  List<Color> gradientColors = [
    Color(0xff23b6e6),
    Color(0xff02d39a),
    Color(0xffFFFFFF),
  ];

  List<Color> gradientColorsLine = [
    Color(0xff23b6e6),
    Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    final graphColor = isDark ? kDarkBg : Color(0xffFFFFFF);
    return Consumer<Session>(
      builder: (context, session, child) {
        if (session.attendance.percent != null) {
          if (session.attendance.percent >= 80) {
            gradientColors = [
              Color(0xff23b6e6),
              Color(0xff02d39a),
              graphColor,
            ];
            gradientColorsLine = [
              Color(0xff23b6e6),
              Color(0xff02d39a),
            ];
          } else if (session.attendance.percent >= 65) {
            gradientColors = [
              Colors.orange,
              Colors.yellow,
              graphColor,
            ];
            gradientColorsLine = [
              Colors.orange,
              Colors.yellow,
            ];
          } else {
            gradientColors = [
              Colors.red,
              Colors.deepOrange,
              graphColor,
            ];
            gradientColorsLine = [
              Colors.red,
              Colors.deepOrange,
            ];
          }
        }
        return Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 2,
              child: session.graph.isEmpty
                  ? Center(
                      child: Text(
                      ':(\nSorry graph is not available at the moment',
                      textAlign: TextAlign.center,
                    ))
                  : LineChart(
                      mainData(session),
                    ),
            ),
          ],
        );
      },
    );
  }

  LineChartData mainData(Session session) {
    return LineChartData(
      lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(tooltipBgColor: kLighterGrey)),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (context, value) =>
              const TextStyle(color: kGrey, fontFamily: 'Averta'),
          getTitles: (value) {
            if (value.toInt() != 0 && value.toInt() != 10)
              return session.graphDays[value.toInt()].split('-')[0] +
                  "\n" +
                  session.graphDays[value.toInt()]
                      .split('(')[1]
                      .toString()
                      .substring(0, 3);
            else
              return '';
          },
          margin: 10,
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, session.graph.elementAt(session.graph.length - 11)),
            FlSpot(1, session.graph.elementAt(session.graph.length - 10)),
            FlSpot(2, session.graph.elementAt(session.graph.length - 9)),
            FlSpot(3, session.graph.elementAt(session.graph.length - 8)),
            FlSpot(4, session.graph.elementAt(session.graph.length - 7)),
            FlSpot(5, session.graph.elementAt(session.graph.length - 6)),
            FlSpot(6, session.graph.elementAt(session.graph.length - 5)),
            FlSpot(7, session.graph.elementAt(session.graph.length - 4)),
            FlSpot(8, session.graph.elementAt(session.graph.length - 3)),
            FlSpot(9, session.graph.elementAt(session.graph.length - 2)),
            FlSpot(10, session.graph.elementAt(session.graph.length - 1))
          ],
          isCurved: true,
          colors: gradientColorsLine,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradientTo: Offset(0, 1),
            gradientColorStops: [0, 0.3, 1],
            colors:
                gradientColors.map((color) => color.withOpacity(0.8)).toList(),
          ),
        ),
      ],
    );
  }
}
