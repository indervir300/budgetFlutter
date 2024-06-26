import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final List<IncomeExpenseData> data;
  final bool animate;

  const Chart(this.data, {Key? key, this.animate = true}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {

  @override
  Widget build(BuildContext context) {
    final seriesList = [
      charts.Series<IncomeExpenseData, String>(
        id: 'Income',
        domainFn: (IncomeExpenseData income, _) => income.category ?? '',
        measureFn: (IncomeExpenseData income, _) => income.income!,
        data: widget.data,
        colorFn: (IncomeExpenseData income, _) {
          return income.income! < 0
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.green.shadeDefault;
        },
      )
    ];

    final barCount = widget.data.length;
    final chartWidthPercentage = barCount < 9 ? 0.8 : 1.3;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * chartWidthPercentage,
        height: MediaQuery.of(context).size.height * 0.4,
        child: charts.BarChart(
          seriesList,
          animate: widget.animate,
          barGroupingType: charts.BarGroupingType.grouped,
          domainAxis: const charts.OrdinalAxisSpec(
            renderSpec: charts.SmallTickRendererSpec(
              labelStyle: charts.TextStyleSpec(
                color: charts.MaterialPalette.black,
              ),
            ),
          ),
          behaviors: [
            charts.LinePointHighlighter(
              showHorizontalFollowLine:
                  charts.LinePointHighlighterFollowLineType.none,
              showVerticalFollowLine:
                  charts.LinePointHighlighterFollowLineType.nearest,
            ),
          ],
        ),
      ),
    );
  }
}

class IncomeExpenseData {
  final double? income;
  final String? category;

  IncomeExpenseData(this.category, this.income);
}

List<IncomeExpenseData> prepareIncomeData(
    List<IncomeExpenseData> incomeExpenseData) {
  return incomeExpenseData;
}
