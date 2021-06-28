part of 'quote_bloc.dart';

abstract class QuoteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class QuoteFetched extends QuoteEvent {}

class QuoteResetFetched extends QuoteEvent {}
