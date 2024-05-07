import '../dash_game_controller.dart';
import '../flappy_dash_game.dart';
import '../widget/rounded_button.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../flappy_dash_game.dart';

class GameScore extends StatefulWidget {
  final FlappyDash game;

  const GameScore({super.key, required this.game});

  @override
  State<GameScore> createState() => _GameScoreState();
}

class _GameScoreState extends State<GameScore> {
  final DashGameController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  kIsWeb ? "images/trophy.png" : "assets/images/trophy.png",
                  width: 35,
                  height: 35,
                ),
                const SizedBox(
                  width: 8,
                ),
                Obx(
                  () => Text(
                    "${_controller.userScore.value}",
                    style: const TextStyle(
                      fontFamily: 'Comfortaa',
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w100,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
