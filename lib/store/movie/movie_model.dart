import 'package:equatable/equatable.dart';

class MovieModel extends Equatable {
  final String id;
  final String name;
  final int runtimeInMinutes;
  final double budgetInMillions;
  final double boxOfficeRevenueInMillions;
  final int academyAwardNominations;
  final int academyAwardWins;
  final double rottenTomatoesScore;

  MovieModel({
    required this.id,
    required this.name,
    required this.runtimeInMinutes,
    required this.budgetInMillions,
    required this.boxOfficeRevenueInMillions,
    required this.academyAwardNominations,
    required this.academyAwardWins,
    required this.rottenTomatoesScore,
  });

  get boxOfficeRevenue {
    return this.boxOfficeRevenueInMillions * 1000000;
  }

  get budget {
    return this.budgetInMillions * 1000000;
  }

  factory MovieModel.fromJson(json) {
    return MovieModel(
      id: json['_id'],
      name: json['name'],
      runtimeInMinutes: json['runtimeInMinutes'],
      budgetInMillions: json['budgetInMillions'].toDouble(),
      boxOfficeRevenueInMillions: json['boxOfficeRevenueInMillions'].toDouble(),
      academyAwardNominations: json['academyAwardNominations'],
      academyAwardWins: json['academyAwardWins'],
      rottenTomatoesScore: json['rottenTomatoesScore'].toDouble(),
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        runtimeInMinutes,
        budgetInMillions,
        boxOfficeRevenueInMillions,
        academyAwardNominations,
        academyAwardWins,
        budget,
        boxOfficeRevenue
      ];
}
