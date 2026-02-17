import 'package:flutter/material.dart';
import '../config/app_config.dart';

class BarChartWidget extends StatelessWidget {
  final Map<String, double> data;
  final Color color;
  final double? maxHeight;

  const BarChartWidget({
    Key? key,
    required this.data,
    required this.color,
    this.maxHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxHeight ?? (data.values.reduce((a, b) => a > b ? a : b) * 1.2),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String month = data.keys.elementAt(group.x.toInt());
              double value = data.values.elementAt(group.x.toInt());
              return BarTooltipItem(
                '$month\nRp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final style = TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                );
                String text = '';
                if (value.toInt() < data.keys.length) {
                  text = data.keys.elementAt(value.toInt());
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(text, style: style),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                final style = TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                );
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '${(value / 1000000).toStringAsFixed(0)}M',
                    style: style,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: data.entries.map((entry) {
          int index = data.keys.toList().indexOf(entry.key);
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: entry.value,
                color: color,
                width: 20,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final Map<String, int> data;
  final List<Color>? colors;

  PieChartWidget({
    Key? key,
    required this.data,
    this.colors,
  }) : super(key: key);

  final List<Color> defaultColors = [
    AppConfig.primaryColor,
    AppConfig.secondaryColor,
    AppConfig.warningColor,
    AppConfig.infoColor,
    AppConfig.successColor,
    AppConfig.accentColor,
  ];

  @override
  Widget build(BuildContext context) {
    final chartColors = colors ?? defaultColors;
    int total = data.values.reduce((a, b) => a + b);

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            // Handle touch events if needed
          },
        ),
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        sections: data.entries.map((entry) {
          int index = data.keys.toList().indexOf(entry.key);
          double percentage = (entry.value / total) * 100;
          Color color = chartColors[index % chartColors.length];

          return PieChartSectionData(
            color: color,
            value: entry.value.toDouble(),
            title: '${percentage.toStringAsFixed(1)}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            badgeWidget: _Badge(
              entry.key,
              size: 40,
              borderColor: color,
            ),
            badgePositionPercentageOffset: .98,
          );
        }).toList(),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final double size;
  final Color borderColor;

  const _Badge(
    this.text, {
    required this.size,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            blurRadius: 3,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
              color: borderColor,
              fontWeight: FontWeight.bold,
              fontSize: 8,
            ),
          ),
        ),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final Map<String, double> data;
  final Color color;
  final bool showDots;

  const LineChartWidget({
    Key? key,
    required this.data,
    required this.color,
    this.showDots = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final style = TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                );
                String text = '';
                if (value.toInt() < data.keys.length) {
                  text = data.keys.elementAt(value.toInt());
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(text, style: style),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final style = TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                );
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toInt().toString(),
                    style: style,
                  ),
                );
              },
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: data.values.reduce((a, b) => a > b ? a : b) * 1.2,
        lineBarsData: [
          LineChartBarData(
            spots: data.entries.map((entry) {
              int index = data.keys.toList().indexOf(entry.key);
              return FlSpot(index.toDouble(), entry.value);
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.8),
                color,
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: showDots,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: color,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.3),
                  color.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}