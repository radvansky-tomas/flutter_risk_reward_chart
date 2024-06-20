import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

import '../../flutter_risk_reward_chart.dart';
import '../application/risk_reward_service.dart';

class RiskRewardChart extends StatelessWidget {
  final List<OptionData> optionsData;
  final RiskRewardService riskRewardService;

  RiskRewardChart({
    super.key,
    this.optionsData = const [],
    RiskRewardService? riskRewardServiceInstance,
  }) : riskRewardService = riskRewardServiceInstance ?? RiskRewardService();

  @override
  Widget build(BuildContext context) {
    if (optionsData.isEmpty) {
      return const Center(
        child: Text('No options data'),
      );
    }

    final minUnderlyingPrice =
        riskRewardService.minUnderlyingPrice(optionsData);
    final maxUnderlyingPrice =
        riskRewardService.maxUnderlyingPrice(optionsData);

    final payoffs = riskRewardService.calculateCombinedPayoffs(
      optionsData,
      minUnderlyingPrice,
      maxUnderlyingPrice,
    );

    final breakEvenPoints = riskRewardService.calculateBreakEvenPoints(payoffs);

    final maxProfit = riskRewardService.maxProfit(payoffs);
    final maxLoss = riskRewardService.maxLoss(payoffs);

    return charts.LineChart(
      riskRewardService.mapOptionData(optionsData, payoffs),
      behaviors: [
        charts.SeriesLegend(
          position: charts.BehaviorPosition.bottom,
          outsideJustification: charts.OutsideJustification.middleDrawArea,
          horizontalFirst: false,
          desiredMaxRows: 2,
          cellPadding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
          entryTextStyle: const charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontFamily: 'Georgia',
            fontSize: 11,
          ),
        ),
        charts.ChartTitle('Underlying Asset Price',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        charts.ChartTitle('Profit / Loss',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        charts.RangeAnnotation([
          // Add horizontal lines for max profit and max loss
          charts.LineAnnotationSegment(
            maxProfit,
            charts.RangeAnnotationAxisType.measure,
            startLabel: 'Max Profit',
            color: charts.MaterialPalette.green.shadeDefault,
            dashPattern: [4, 4],
          ),
          charts.LineAnnotationSegment(
            maxLoss,
            charts.RangeAnnotationAxisType.measure,
            startLabel: 'Max Loss',
            color: charts.MaterialPalette.red.shadeDefault,
            dashPattern: [4, 4],
          ),

          // Add vertical lines for break-even points
          for (var breakEven in breakEvenPoints)
            charts.LineAnnotationSegment(
              breakEven,
              charts.RangeAnnotationAxisType.domain,
              startLabel: 'Break-even',
              color: charts.MaterialPalette.yellow.shadeDefault,
              dashPattern: [4, 4],
            ),

          // Add vertical lines for strike prices
          for (var option in optionsData)
            charts.LineAnnotationSegment(
              option.strikePrice,
              charts.RangeAnnotationAxisType.domain,
              startLabel: '${option.strikePrice}',
              color: riskRewardService.getColorBasedOnTypeAndPosition(option),
              dashPattern: [4, 4],
            ),
        ]),
      ],
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
      domainAxis: charts.NumericAxisSpec(
        viewport: breakEvenPoints.length > 1
            ? charts.NumericExtents(
                breakEvenPoints.first - 5, breakEvenPoints.last + 5)
            : charts.NumericExtents(
                riskRewardService.minUnderlyingPrice(optionsData) - 5,
                riskRewardService.maxUnderlyingPrice(optionsData) + 5,
              ),
        tickProviderSpec:
            const charts.BasicNumericTickProviderSpec(zeroBound: false),
      ),
      animate: true,
    );
  }
}
