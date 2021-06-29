part of 'quote_bloc.dart';

abstract class QuoteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class QuoteFetched extends QuoteEvent {}

class QuoteResetFetched extends QuoteEvent {}

abstract class MovieQuoteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieQuoteFetched extends MovieQuoteEvent {}

class MovieQuoteResetFetched extends MovieQuoteEvent {}

abstract class CharacterQuoteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CharacterQuoteFetched extends CharacterQuoteEvent {}

class CharacterQuoteResetFetched extends CharacterQuoteEvent {}
