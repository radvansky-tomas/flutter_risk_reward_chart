# flutter_risk_reward_chart

A Flutter package for visualizing risk and reward charts for different options trading strategies. This package provides an easy-to-use widget to display payoff diagrams for various option types.

## Features

- Display risk/reward charts for call and put options, both long and short.
- Easily configurable with a list of options data.
- Calculate payoffs for multiple underlying prices.

## Screenshot

![Risk Reward Chart](/screenshots/ios_screenshot.png?raw=true "Risk Reward Chart")

## Installation

Add `flutter_risk_reward_chart` to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_risk_reward_chart: ^0.0.1
```

## Usage

Import the package in your Dart file:

```dart
Copy code
import 'package:flutter_risk_reward_chart/flutter_risk_reward_chart.dart';
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_risk_reward_chart/flutter_risk_reward_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Risk Reward Chart'),
        ),
        body: RiskRewardChart(
          optionsData: [
            OptionData(
              strikePrice: 100,
              type: OptionType.callLong,
              bid: 10.05,
              ask: 12.04,
              expirationDate: DateTime.parse('2025-12-17T00:00:00Z'),
            ),
            OptionData(
              strikePrice: 102.50,
              type: OptionType.callLong,
              bid: 12.10,
              ask: 14,
              expirationDate: DateTime.parse('2025-12-17T00:00:00Z'),
            ),
            OptionData(
              strikePrice: 103,
              type: OptionType.putShort,
              bid: 14,
              ask: 15.50,
              expirationDate: DateTime.parse('2025-12-17T00:00:00Z'),
            ),
            OptionData(
              strikePrice: 105,
              type: OptionType.putLong,
              bid: 16,
              ask: 18,
              expirationDate: DateTime.parse('2025-12-17T00:00:00Z'),
            ),
          ],
        ),
      ),
    );
  }
}
```
