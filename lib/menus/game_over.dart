import 'dart:math' as math;

import 'package:flappy_dash/utils/utils.dart';

import '../dash_game_controller.dart';
import '../flappy_dash_game.dart';
import '../utils/ads_manager.dart';
import '../widget/rounded_button.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/consts.dart';
import '../widget/rounded_button.dart';

class GameOver extends StatefulWidget {
  final FlappyDash game;

  const GameOver({super.key, required this.game});

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  final DashGameController _controller = Get.find();
  bool isAudioEnable = true;

  @override
  void initState() {
    isAudioEnable = widget.game.userPreferences.prefGetAudioEnabled();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: kIsWeb ? context.width / 2 : double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: context.height * 0.1,
            ),
            const Text(
              "Game over!",
              style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 34,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Better luck next time.",
              style: TextStyle(
                  fontFamily: 'Comfortaa',
                  fontSize: 16,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            ),
            const SizedBox(
              height: 34,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    kIsWeb ? "images/trophy.png" : "assets/images/trophy.png",
                    width: 85,
                    height: 85,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Total :",
                            style: TextStyle(
                                fontFamily: 'Comfortaa',
                                fontSize: 24,
                                color: Colors.white,
                                decoration: TextDecoration.none),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Obx(
                            () => Text(
                              _controller.userScore.value.toString(),
                              style: const TextStyle(
                                fontFamily: 'Comfortaa',
                                fontSize: 24,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Best :",
                            style: TextStyle(
                                fontFamily: 'Comfortaa',
                                fontSize: 24,
                                color: Colors.white,
                                decoration: TextDecoration.none),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "${widget.game.userPreferences.prefGetBestScore()}",
                            style: const TextStyle(
                                fontFamily: 'Comfortaa',
                                fontSize: 24,
                                color: Colors.white,
                                decoration: TextDecoration.none),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                widget.game.player.retryGame();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: const Icon(
                        Icons.replay_outlined,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "Play again",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Comfortaa',
                          fontSize: 14,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: context.height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                RoundedButton(
                  iconData: Icons.home_rounded,
                  onTap: () {
                    widget.game.overlays.remove(keyGameOver);
                    widget.game.overlays.add(keyGameIntro);
                    widget.game.player.resetGame();

                    AdsManager.showRewardedAd(math.Random().nextDouble());
                  },
                ),
                RoundedButton(
                  iconData: isAudioEnable
                      ? Icons.volume_up_rounded
                      : Icons.volume_off_rounded,
                  onTap: () {
                    setState(() {
                      isAudioEnable = !isAudioEnable;
                      if (isAudioEnable) {
                        widget.game.audioController
                            .startBackGroundMusic(isAudioEnable);
                      } else {
                        widget.game.audioController
                            .stopBackgroundMusic(isAudioEnable);
                      }
                      widget.game.userPreferences
                          .prefSetAudioEnabled(isAudioEnable);
                    });
                  },
                ),
                RoundedButton(
                  iconData: Icons.info_outline,
                  onTap: () {
                    AdsManager.showRewardedAd(math.Random().nextDouble());
                    showInfoDialogue(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
