import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../../model/expense.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({Key? key, required this.expenses}) : super(key: key);

  final List<Expense> expenses;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.food),
      ExpenseBucket.forCategory(expenses, Category.leisure),
      ExpenseBucket.forCategory(expenses, Category.travel),
      ExpenseBucket.forCategory(expenses, Category.work),
    ];
  }

  double get totalExpense {
    double sum = 0;

    for (final bucket in buckets) {
      sum += bucket.totalExpenses;
    }

    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 60),
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDarkMode
              ? kDarkColorScheme.secondaryContainer
              : kColorScheme.secondaryContainer
          //color: kColorScheme.secondaryContainer,
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total Expense',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: isDarkMode
                    ? kDarkColorScheme.onSecondaryContainer
                    : kColorScheme.onSecondaryContainer),
          ),
          const SizedBox(height: 5),
          Text(
            '₹${totalExpense.toStringAsFixed(2)}',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: isDarkMode
                    ? kDarkColorScheme.onSecondaryContainer
                    : kColorScheme.onSecondaryContainer),
            // style: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   fontSize: 20,
            //   color: isDarkMode ? Colors.white : Colors.black,
            // ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: PieChartPainter(
                  buckets: buckets,
                  totalExpense: totalExpense,
                  isDarkMode: isDarkMode,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
