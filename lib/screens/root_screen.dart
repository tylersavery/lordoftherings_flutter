import 'package:flutter/material.dart';
import 'package:lordoftherings_flutter/screens/quote_list_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 2;

  final List<Widget> _children = [
    Text("TODO: Create Movie List Screen"),
    Text("TODO: Create Quote List Screen"),
    QuoteListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lord of the Rings"),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: "Movies",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Characters",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: "Quotes",
          ),
        ],
      ),
    );
  }
}
