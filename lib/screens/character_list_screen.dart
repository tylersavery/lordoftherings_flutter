import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lordoftherings_flutter/components/character_card.dart';
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

class SearchInput extends StatefulWidget {
  final Function onSubmit;
  const SearchInput({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final _controller = TextEditingController();

  void _handleSubmit() {
    widget.onSubmit(_controller.value.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListTile(
          title: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Search...",
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: (_) {
              setState(() {});
            },
            onSaved: (val) {
              print(val);
            },
            onEditingComplete: _handleSubmit,
          ),
          trailing: IconButton(
            icon: Icon(Icons.search),
            onPressed: _controller.value.text.isEmpty ? null : _handleSubmit,
          )),
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
                child: PagedListView<int, CharacterModel>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<CharacterModel>(
                    itemBuilder: (context, character, index) {
                      return CharacterCard(character);
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
