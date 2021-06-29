import 'package:flutter/material.dart';
import 'package:lordoftherings_flutter/screens/character_detail_screen.dart';
import 'package:lordoftherings_flutter/store/character/character_model.dart';

class CharacterCard extends StatelessWidget {
  final CharacterModel character;
  const CharacterCard(this.character, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(character.name),
      leading: Icon(Icons.person),
      trailing: Icon(Icons.chevron_right),
      subtitle: Text(character.race),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => CharacterDetailScreen(character),
          ),
        );
      },
    );
  }
}
