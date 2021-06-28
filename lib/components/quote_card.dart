import 'package:flutter/material.dart';
import 'package:lordoftherings_flutter/store/quote/quote_model.dart';

class QuoteCard extends StatelessWidget {
  final QuoteModel quote;
  const QuoteCard(this.quote, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(quote.dialogNormalized),
      ),
    );
  }
}
