import 'dart:developer';
import 'dart:math' as math;

import 'package:flappy_dash/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:get/get.dart';

import '../dash_game_controller.dart';
import '../flappy_dash_game.dart';
import '../utils/ads_manager.dart';
import '../widget/rounded_button.dart';

class GameIntro extends StatefulWidget {
  final FlappyDash game;

  const GameIntro({super.key, required this.game});

  @override
  State<GameIntro> createState() => _GameIntroState();
}

class _GameIntroState extends State<GameIntro> {
  final DashGameController gameController = Get.find();
  bool isAudioEnable = true;

  @override
  void initState() {
    isAudioEnable = widget.game.userPreferences.prefGetAudioEnabled();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          height: double.infinity,
          width: kIsWeb ? context.width / 2 : double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Flappy Dash",
                style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 30,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
              const SizedBox(
                height: 22,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  widget.game.player.startGame();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white12,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/tap_to_jump.png',
                        width: 45,
                        height: 45,
                      ),
                      const Text(
                        "Click/press Space to play",
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
              const SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Fly the dash as far as you can without hitting a pipe.",
                  style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
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
                    iconData: Icons.leaderboard_rounded,
                    onTap: () async {
                      try{
                        // TODO : update leaderboard id here
                        await GamesServices.showLeaderboards(
                          iOSLeaderboardID: '',
                          androidLeaderboardID: '',
                        );
                      }catch(e){
                        log(e.toString());
                      }
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
      ),
    );
  }
}
