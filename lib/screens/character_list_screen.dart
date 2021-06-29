import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lordoftherings_flutter/components/character_card.dart';
import 'package:lordoftherings_flutter/screens/character_search_results_screen.dart';
import 'package:lordoftherings_flutter/store/character/character_bloc.dart';
import 'package:lordoftherings_flutter/store/character/character_model.dart';
import 'package:lordoftherings_flutter/store/character/character_repository.dart';
import 'package:lordoftherings_flutter/store/common/api_repository.dart';

class CharacterListScreen extends StatefulWidget {
  CharacterListScreen({Key? key}) : super(key: key);

  @override
  _CharacterListScreenState createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CharacterBloc>(
      create: (ctx) => CharacterBloc(repository: CharacterRepository(Dio()))
        ..add(
          CharacterFetched(),
        ),
      child: CharacterList(),
    );
  }
}

class CharacterList extends StatefulWidget {
  const CharacterList({Key? key}) : super(key: key);

  @override
  _CharacterListState createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  late CharacterBloc _characterBloc;

  final PagingController<int, CharacterModel> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _characterBloc = context.read<CharacterBloc>();
    _pagingController.addPageRequestListener((pageKey) {
      _characterBloc.add(CharacterFetched());
    });
  }

  @override
  void didUpdateWidget(covariant CharacterList oldWidget) {
    _pagingController.refresh();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CharacterBloc, CharacterState>(
      listener: (context, state) {
        if (state.status == ApiRequestStatus.success) {
          if (state.page == state.pages) {
            _pagingController.appendLastPage(state.appendedCharacters);
          } else {
            _pagingController.appendPage(
                state.appendedCharacters, state.page + 1);
          }
        }
      },
      child: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          switch (state.status) {
            case ApiRequestStatus.failure:
              return Center(child: Text("Error"));
            case ApiRequestStatus.success:
              return RefreshIndicator(
                onRefresh: () => Future.sync(
                  () {
                    _pagingController.refresh();
                    _characterBloc.add(CharacterResetFetched());
                  },
                ),
                child: Column(
                  children: [
                    SearchInput(
                      onSubmit: (value) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) =>
                                CharacterSearchResultsScreen(value),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: PagedListView<int, CharacterModel>(
                        pagingController: _pagingController,
                        builderDelegate:
                            PagedChildBuilderDelegate<CharacterModel>(
                          itemBuilder: (context, character, index) {
                            return CharacterCard(character);
                          },
                        ),
                      ),
                    ),
                  ],
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

class SearchInput extends StatelessWidget {
  final Function onSubmit;
  final _controller = TextEditingController();

  SearchInput({Key? key, required this.onSubmit}) : super(key: key);

  void _handleSubmit() {
    this.onSubmit(_controller.value.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: "Search...",
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onEditingComplete: _handleSubmit,
      ),
      trailing: IconButton(
        onPressed: _handleSubmit,
        icon: Icon(Icons.search),
      ),
    );
  }
}
