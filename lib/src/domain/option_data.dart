// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';

enum OptionType { callShort, callLong, putShort, putLong }

class OptionData extends Equatable {
  final double strikePrice;
  final OptionType type;
  final double bid;
  final double ask;
  final DateTime expirationDate;

  const OptionData({
    required this.strikePrice,
    required this.type,
    required this.bid,
    required this.ask,
    required this.expirationDate,
  });

  @override
  List<Object?> get props => [
        strikePrice,
        type,
        bid,
        ask,
        expirationDate,
      ];
}
