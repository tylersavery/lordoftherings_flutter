import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lordoftherings_flutter/components/quote_card.dart';
import 'package:lordoftherings_flutter/components/stat.dart';
import 'package:lordoftherings_flutter/store/character/character_model.dart';
import 'package:lordoftherings_flutter/store/common/api_repository.dart';
import 'package:lordoftherings_flutter/store/quote/quote_bloc.dart';
import 'package:lordoftherings_flutter/store/quote/quote_model.dart';
import 'package:lordoftherings_flutter/store/quote/quote_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class CharacterDetailScreen extends StatefulWidget {
  final CharacterModel character;

  const CharacterDetailScreen(this.character, {Key? key}) : super(key: key);

  @override
  _CharacterDetailScreenState createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: Text(widget.character.name),
                  forceElevated: innerBoxIsScrolled,
                  pinned: true,
                  actions: [
                    if (widget.character.wikiUrl.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          launch(widget.character.wikiUrl);
                        },
                        icon: Icon(Icons.open_in_new),
                      ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Theme.of(context).primaryColorDark,
                  child: Padding(
                    padding: const EdgeInsets.all(8).copyWith(top: 110),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stat(
                              value: widget.character.race,
                              label: "Race",
                            ),
                            Stat(
                              value: widget.character.gender,
                              label: "Gender",
                              crossAxisAlignment: CrossAxisAlignment.end,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ];
          },
          body: BlocProvider<CharacterQuoteBloc>(
              create: (ctx) => CharacterQuoteBloc(
                  repository: QuoteRepository(Dio()),
                  character: widget.character)
                ..add(CharacterQuoteFetched()),
              child: CharacterQuoteList(widget.character))),
    );
  }
}

class CharacterQuoteList extends StatefulWidget {
  final CharacterModel movie;
  CharacterQuoteList(
    this.movie, {
    Key? key,
  }) : super(key: key);

  @override
  _CharacterQuoteListState createState() => _CharacterQuoteListState();
}

class _CharacterQuoteListState extends State<CharacterQuoteList> {
  final PagingController<int, QuoteModel> _pagingController =
      PagingController(firstPageKey: 1);

  late CharacterQuoteBloc _characterQuoteBloc;

  @override
  void initState() {
    _characterQuoteBloc = context.read<CharacterQuoteBloc>();
    _pagingController.addPageRequestListener((pageKey) {
      _characterQuoteBloc.add(CharacterQuoteFetched());
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CharacterQuoteList oldWidget) {
    _pagingController.refresh();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CharacterQuoteBloc, QuoteState>(
      listener: (context, state) {
        if (state.status == ApiRequestStatus.success) {
          if (state.page == state.pages) {
            _pagingController.appendLastPage(state.appendedQuotes);
          } else {
            _pagingController.appendPage(state.appendedQuotes, state.page + 1);
          }
        }
      },
      child: BlocBuilder<CharacterQuoteBloc, QuoteState>(
        builder: (ctx, state) {
          switch (state.status) {
            case ApiRequestStatus.failure:
              return Center(child: Text("Error"));
            case ApiRequestStatus.success:
              return RefreshIndicator(
                onRefresh: () => Future.sync(
                  () {
                    _pagingController.refresh();
                  },
                ),
                child: PagedListView<int, QuoteModel>(
                  padding: EdgeInsets.zero,
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<QuoteModel>(
                    itemBuilder: (context, quote, index) {
                      return QuoteCard(quote);
                    },
                  ),
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
