import 'package:flutter_risk_reward_chart/flutter_risk_reward_chart.dart';
import 'package:flutter_risk_reward_chart/src/application/risk_reward_service.dart';
import 'package:flutter_risk_reward_chart/src/domain/payoff_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ignore: non_constant_identifier_names
  final riskRewardService = RiskRewardService();

  bool almostEqual(double a, double b, {double epsilon = 1e-2}) {
    return (a - b).abs() < epsilon;
  }

  void expectPayoffData(List<PayoffData> result, List<PayoffData> expected) {
    for (int i = 0; i < result.length; i++) {
      expect(result[i].underlyingPrice, expected[i].underlyingPrice);
      expect(almostEqual(result[i].payoff, expected[i].payoff), true,
          reason:
              'Expected: ${expected[i].payoff}, Actual: ${result[i].payoff}');
    }
  }

  test('Calculate Payoff for Long Call', () {
    var option = OptionData(
      type: OptionType.callLong,
      strikePrice: 100,
      bid: 10.05,
      ask: 12.04,
      expirationDate: DateTime.parse('2025-12-17'),
    );
    var underlyingPrices = [90.0, 100.0, 110.0, 120.0];

    var result = riskRewardService.calculatePayoff(option, underlyingPrices);

    var expected = [
      PayoffData(90, -12.04),
      PayoffData(100, -12.04),
      PayoffData(110, -2.04),
      PayoffData(120, 7.96),
    ];

    expectPayoffData(result, expected);
  });

  test('Calculate Payoff for Short Call', () {
    var option = OptionData(
      type: OptionType.callShort,
      strikePrice: 100,
      bid: 10.05,
      ask: 12.04,
      expirationDate: DateTime.parse('2025-12-17'),
    );
    var underlyingPrices = [90.0, 100.0, 110.0, 120.0];

    var result = riskRewardService.calculatePayoff(option, underlyingPrices);

    var expected = [
      PayoffData(90, 10.05),
      PayoffData(100, 10.05),
      PayoffData(110, 0.05),
      PayoffData(120, -9.95),
    ];

    expectPayoffData(result, expected);
  });

  test('Calculate Payoff for Long Put', () {
    var option = OptionData(
      type: OptionType.putLong,
      strikePrice: 100,
      bid: 14,
      ask: 15.50,
      expirationDate: DateTime.parse('2025-12-17'),
    );
    var underlyingPrices = [90.0, 100.0, 110.0, 120.0];

    var result = riskRewardService.calculatePayoff(option, underlyingPrices);

    var expected = [
      PayoffData(90, -5.50),
      PayoffData(100, -15.50),
      PayoffData(110, -15.50),
      PayoffData(120, -15.50),
    ];

    expectPayoffData(result, expected);
  });

  test('Calculate Payoff for Short Put', () {
    var option = OptionData(
      type: OptionType.putShort,
      strikePrice: 100,
      bid: 14,
      ask: 15.50,
      expirationDate: DateTime.parse('2025-12-17'),
    );
    var underlyingPrices = [90.0, 100.0, 110.0, 120.0];

    var result = riskRewardService.calculatePayoff(option, underlyingPrices);

    var expected = [
      PayoffData(90, 4.0),
      PayoffData(100, 14.0),
      PayoffData(110, 14.0),
      PayoffData(120, 14.0),
    ];

    expectPayoffData(result, expected);
  });

  group('calculateCombinedPayoffs', () {
    test('returns correct combined payoffs for a list of options', () {
      final options = [
        OptionData(
          type: OptionType.callLong,
          strikePrice: 100.0,
          bid: 10.05,
          ask: 12.04,
          expirationDate: DateTime.parse('2025-12-17'),
        ),
        OptionData(
          type: OptionType.putLong,
          strikePrice: 105.0,
          bid: 16.0,
          ask: 18.0,
          expirationDate: DateTime.parse('2025-12-17'),
        ),
      ];
      final minUnderlyingPrice = 80.0; // Extended range
      final maxUnderlyingPrice = 120.0; // Extended range

      final result = riskRewardService.calculateCombinedPayoffs(
          options, minUnderlyingPrice, maxUnderlyingPrice);

      expect(result.length, 500);
      expect(result.first.underlyingPrice, minUnderlyingPrice);
      expect(result.last.underlyingPrice, maxUnderlyingPrice);

      // Calculate the expected combined payoffs manually for a few points
      expect(result.first.payoff, -20.04); // at underlyingPrice = 80.0
      expect(result[250].payoff, -25.04); // at underlyingPrice = 100.0
      expect(result.last.payoff, -7.04); // at underlyingPrice = 120.0
    });

    test('returns correct combined payoffs for an empty list of options', () {
      List<OptionData> options = <OptionData>[];
      final minUnderlyingPrice = 95.0;
      final maxUnderlyingPrice = 110.0;

      final result = riskRewardService.calculateCombinedPayoffs(
          options, minUnderlyingPrice, maxUnderlyingPrice);

      expect(result.length, 500);
      expect(result.first.underlyingPrice, minUnderlyingPrice);
      expect(result.last.underlyingPrice, maxUnderlyingPrice);
      expect(result.every((payoffData) => payoffData.payoff == 0.0), isTrue);
    });

    // Add more tests for different scenarios
  });
}
