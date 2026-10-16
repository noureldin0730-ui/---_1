import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/mosque_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const NourMosqueApp());
}

class NourMosqueApp extends StatelessWidget {
  const NourMosqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "جامع النور",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1410),
        body: GameWidget(game: MosqueGame()),
      ),
    );
  }
}