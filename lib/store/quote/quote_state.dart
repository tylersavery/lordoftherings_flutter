part of 'quote_bloc.dart';

class QuoteState extends Equatable {
  final List<QuoteModel> quotes;
  final List<QuoteModel> appendedQuotes;
  final ApiRequestStatus status;
  final int page;
  final int pages;

  const QuoteState({
    this.quotes = const <QuoteModel>[],
    this.appendedQuotes = const <QuoteModel>[],
    this.status = ApiRequestStatus.initial,
    this.page = 0,
    this.pages = 0,
  });

  QuoteState copyWith({
    ApiRequestStatus? status,
    List<QuoteModel>? quotes,
    List<QuoteModel>? appendedQuotes,
    int? page,
    int? pages,
  }) {
    return QuoteState(
      status: status ?? this.status,
      quotes: quotes ?? this.quotes,
      appendedQuotes: appendedQuotes ?? [],
      pages: pages ?? this.pages,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [status, quotes, appendedQuotes, page, pages];
}
