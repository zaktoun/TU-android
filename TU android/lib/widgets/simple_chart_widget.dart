import 'package:flutter/material.dart';
import '../config/app_config.dart';

class SimpleBarChart extends StatelessWidget {
  final Map<String, double> data;
  final Color color;

  const SimpleBarChart({
    Key? key,
    required this.data,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('Tidak ada data'),
      );
    }

    double maxValue = data.values.reduce((a, b) => a > b ? a : b);
    
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.entries.map((entry) {
              double height = (entry.value / maxValue) * 200;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: height,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Rp${(entry.value / 1000000).toStringAsFixed(1)}M',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class SimplePieChart extends StatelessWidget {
  final Map<String, int> data;
  final List<Color>? colors;

  SimplePieChart({
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
    if (data.isEmpty) {
      return const Center(
        child: Text('Tidak ada data'),
      );
    }

    final chartColors = colors ?? defaultColors;
    int total = data.values.reduce((a, b) => a + b);

    return Column(
      children: [
        // Simple pie chart representation
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(75),
          ),
          child: Center(
            child: Text(
              total.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: data.entries.map((entry) {
            int index = data.keys.toList().indexOf(entry.key);
            Color color = chartColors[index % chartColors.length];
            double percentage = (entry.value / total) * 100;
            
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${entry.key} (${percentage.toStringAsFixed(1)}%)',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SimpleLineChart extends StatelessWidget {
  final Map<String, double> data;
  final Color color;

  const SimpleLineChart({
    Key? key,
    required this.data,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('Tidak ada data'),
      );
    }

    return Container(
      height: 200,
      child: CustomPaint(
        painter: LineChartPainter(data, color),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final Map<String, double> data;
  final Color color;

  LineChartPainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    List<Offset> points = [];
    double maxValue = data.values.reduce((a, b) => a > b ? a : b);
    double xStep = size.width / (data.length - 1);

    int index = 0;
    for (var entry in data.entries) {
      double x = index * xStep;
      double y = size.height - (entry.value / maxValue) * size.height * 0.8;
      points.add(Offset(x, y));
      index++;
    }

    // Draw fill area
    Path fillPath = Path()..moveTo(points.first.dx, size.height);
    fillPath.addPolygon(points, false);
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    Path path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var point in points) {
      canvas.drawCircle(point, 4, pointPaint);
      canvas.drawCircle(point, 4, Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill);
      canvas.drawCircle(point, 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}