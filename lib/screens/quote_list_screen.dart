import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lordoftherings_flutter/store/common/api_repository.dart';
import 'package:lordoftherings_flutter/store/quote/quote_bloc.dart';
import 'package:lordoftherings_flutter/store/quote/quote_model.dart';
import 'package:lordoftherings_flutter/store/quote/quote_repository.dart';

class QuoteListScreen extends StatelessWidget {
  const QuoteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuoteBloc>(
      create: (ctx) => QuoteBloc(
        repository: QuoteRepository(
          Dio(),
        ),
      )..add(QuoteFetched()),
      child: QuoteList(),
    );
  }
}

class QuoteList extends StatefulWidget {
  const QuoteList({Key? key}) : super(key: key);

  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  late QuoteBloc _quoteBloc;

  final PagingController<int, QuoteModel> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _quoteBloc = context.read<QuoteBloc>();
    _pagingController.addPageRequestListener((pageKey) {
      _quoteBloc.add(QuoteFetched());
    });
  }

  @override
  void didUpdateWidget(covariant QuoteList oldWidget) {
    _pagingController.refresh();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuoteBloc, QuoteState>(
      listener: (ctx, state) {
        if (state.status == ApiRequestStatus.success) {
          if (state.page == state.pages) {
            _pagingController.appendLastPage(state.appendedQuotes);
          } else {
            _pagingController.appendPage(state.appendedQuotes, state.page + 1);
          }
        }
      },
      child: BlocBuilder<QuoteBloc, QuoteState>(
        builder: (ctx, state) {
          switch (state.status) {
            case ApiRequestStatus.failure:
              return Center(
                child: Text("Error!"),
              );
            case ApiRequestStatus.success:
              return RefreshIndicator(
                onRefresh: () => Future.sync(() {
                  _pagingController.refresh();
                  _quoteBloc.add(QuoteResetFetched());
                }),
                child: PagedListView<int, QuoteModel>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<QuoteModel>(
                    itemBuilder: (context, quote, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(quote.dialog),
                      );
                    },
                  ),
                ),
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
