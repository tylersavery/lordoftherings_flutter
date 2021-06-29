import 'package:equatable/equatable.dart';

class CharacterModel extends Equatable {
  final String id;
  final String name;
  final String race;
  final String gender;
  final String wikiUrl;

  CharacterModel({
    required this.id,
    required this.name,
    required this.race,
    required this.gender,
    required this.wikiUrl,
  });

  factory CharacterModel.fromJson(json) {
    return CharacterModel(
      id: json['_id'],
      name: json['name'] != null ? json['name'] : '',
      race: json['race'] != null ? json['race'] : '',
      gender: json['gender'] != null ? json['gender'] : '',
      wikiUrl: json['wikiUrl'] != null ? json['wikiUrl'] : '',
    );
  }

  @override
  List<Object> get props => [id, name, race, gender, wikiUrl];
}
