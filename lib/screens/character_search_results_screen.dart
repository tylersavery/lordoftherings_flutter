import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lordoftherings_flutter/components/character_card.dart';
import 'package:lordoftherings_flutter/store/character/character_bloc.dart';
import 'package:lordoftherings_flutter/store/character/character_model.dart';
import 'package:lordoftherings_flutter/store/character/character_repository.dart';
import 'package:lordoftherings_flutter/store/common/api_repository.dart';

class CharacterSearchResultsScreen extends StatelessWidget {
  final String query;
  const CharacterSearchResultsScreen(this.query, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.query),
      ),
      body: BlocProvider<CharacterSearchBloc>(
        create: (ctx) => CharacterSearchBloc(
          query: this.query,
          repository: CharacterRepository(
            Dio(),
          ),
        )..add(
            CharacterSearchFetched(),
          ),
        child: CharacterSearchList(),
      ),
    );
  }
}

class CharacterSearchList extends StatefulWidget {
  const CharacterSearchList({Key? key}) : super(key: key);

  @override
  _CharacterSearchListState createState() => _CharacterSearchListState();
}

class _CharacterSearchListState extends State<CharacterSearchList> {
  late CharacterSearchBloc _characterBloc;

  final PagingController<int, CharacterModel> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _characterBloc = context.read<CharacterSearchBloc>();
    _pagingController.addPageRequestListener((pageKey) {
      _characterBloc.add(CharacterSearchFetched());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CharacterSearchBloc, CharacterState>(
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
      child: BlocBuilder<CharacterSearchBloc, CharacterState>(
        builder: (context, state) {
          switch (state.status) {
            case ApiRequestStatus.failure:
              return Center(child: Text("Error"));
            case ApiRequestStatus.success:
              return PagedListView<int, CharacterModel>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<CharacterModel>(
                  itemBuilder: (context, character, index) {
                    return CharacterCard(character);
                  },
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
