import 'package:equatable/equatable.dart';

class QuoteModel extends Equatable {
  final String id;
  final String dialog;

  QuoteModel({
    required this.id,
    required this.dialog,
  });

  get dialogNormalized {
    return this.dialog.replaceAll("    ", "");
  }

  factory QuoteModel.fromJson(json) {
    return QuoteModel(
      id: json['_id'],
      dialog: json['dialog'],
    );
  }

  @override
  List<Object?> get props => [id, dialog];
}
