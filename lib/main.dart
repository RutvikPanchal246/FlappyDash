import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flappy_dash/utils/ads_manager.dart';
import 'package:flappy_dash/utils/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:games_services/games_services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'firebase_options.dart';
import 'flappy_dash_game.dart';
import 'menus/game_intro.dart';
import 'menus/game_over.dart';
import 'menus/game_score.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MobileAds.instance.initialize();
  AdsManager.initializeBannerAds();
  AdsManager.initializeRewardedAds();

  // Sign-in to game services for leaderboard
  try {
    await GamesServices.signIn();
  } on PlatformException catch (e) {
    log(e.toString());
  }
  await Flame.device.setOrientation(DeviceOrientation.portraitUp);

  runApp(
    GetMaterialApp(
      theme: ThemeData(fontFamily: 'Comfortaa'),
      home: Column(
        children: [
          Expanded(
            child: GameWidget.controlled(
              gameFactory: FlappyDash.new,
              overlayBuilderMap: {
                keyGameStarted: (context, FlappyDash game) => GameScore(
                      game: game,
                    ),
                keyGameIntro: (context, FlappyDash game) => GameIntro(
                      game: game,
                    ),
                keyGameOver: (context, FlappyDash game) => GameOver(
                      game: game,
                    ),
              },
              initialActiveOverlays: const [keyGameIntro],
            ),
          ),
          if (AdsManager.bannerAd != null)
            Align(
              alignment: Alignment.center,
              child: SafeArea(
                child: SizedBox(
                    height: AdsManager.bannerAd!.size.height.toDouble(),
                    width: AdsManager.bannerAd!.size.width.toDouble(),
                    child: AdWidget(ad: AdsManager.bannerAd!)),
              ),
            )
        ],
      ),
    ),
  );
}
