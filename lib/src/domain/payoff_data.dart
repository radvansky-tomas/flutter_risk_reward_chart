import 'package:equatable/equatable.dart';

class PayoffData extends Equatable {
  final double underlyingPrice;
  final double payoff;

  const PayoffData(this.underlyingPrice, this.payoff);

  @override
  List<Object?> get props => [underlyingPrice, payoff];
}
