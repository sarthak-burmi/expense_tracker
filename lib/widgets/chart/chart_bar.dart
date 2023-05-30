import 'dart:math';
import 'package:flutter/material.dart';

import '../../model/expense.dart';

class PieChartPainter extends CustomPainter {
  final List<ExpenseBucket> buckets;
  final double totalExpense;
  final bool isDarkMode;

  PieChartPainter({
    required this.buckets,
    required this.totalExpense,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -pi / 2; // Starting angle at the top (-90 degrees)

    for (final bucket in buckets) {
      final sweepAngle = (bucket.totalExpenses / totalExpense) * 2 * pi;

      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = getCategoryColor(bucket.category);

      canvas.drawArc(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: size.width / 2,
        ),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    _drawLegend(canvas, size);
  }

  Color getCategoryColor(Category category) {
    Map<Category, Color> categoryColors = {
      Category.food: Colors.red,
      Category.leisure: Colors.green,
      Category.travel: Colors.blue,
      Category.work: Colors.orange,
    };

    return categoryColors[category] ?? Colors.grey;
  }

  String getCategoryLabel(Category category) {
    Map<Category, String> categoryLabels = {
      Category.food: 'Food',
      Category.leisure: 'Leisure',
      Category.travel: 'Travel',
      Category.work: 'Work',
    };

    return categoryLabels[category] ?? 'Unknown';
  }

  void _drawLegend(Canvas canvas, Size size) {
    final double legendIconSize = 16.0;
    final double legendSpacing = 3.0;
    final double legendMargin = 50.0;
    final double legendTextSize = 12.0;
    final double legendOffsetY = size.height + legendMargin;

    double totalWidth = 0.0;

    for (final bucket in buckets) {
      final text = getCategoryLabel(bucket.category);

      final textStyle = TextStyle(
        fontSize: legendTextSize,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      );

      final textSpan = TextSpan(
        text: text,
        style: textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      totalWidth +=
          legendIconSize + legendSpacing + textPainter.width + legendSpacing;
    }

    double currentOffsetX =
        (size.width - totalWidth) / 2; // Calculate center offset

    for (final bucket in buckets) {
      final icon = categoryIcons[bucket.category];
      final color = getCategoryColor(bucket.category);
      final text = getCategoryLabel(bucket.category);

      final textStyle = TextStyle(
        fontSize: legendTextSize,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      );

      final textSpan = TextSpan(
        text: text,
        style: textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final iconOffset = Offset(
        currentOffsetX + legendIconSize / 0.6,
        legendOffsetY - legendIconSize / 2 - textPainter.height - legendSpacing,
      );

      final textOffset = Offset(
        currentOffsetX + legendIconSize / 0.6 - textPainter.width / 2,
        legendOffsetY - textPainter.height,
      );

      final iconRect = Rect.fromCenter(
        center: iconOffset,
        width: legendIconSize,
        height: legendIconSize,
      );

      final iconPaint = Paint()..color = color;
      canvas.drawOval(iconRect, iconPaint);

      textPainter.paint(canvas, textOffset);

      currentOffsetX +=
          legendIconSize + legendSpacing + textPainter.width + legendSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
