import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lordoftherings_flutter/screens/root_screen.dart';
import 'package:lordoftherings_flutter/store/common/observer.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tmpDir = await getTemporaryDirectory();
  Hive.init(tmpDir.toString());

  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: tmpDir);

  Bloc.observer = SimpleBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOTR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: RootScreen(),
    );
  }
}
