import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flappy_dash/player/base_platform.dart';
import 'package:flappy_dash/player/dash.dart';
import 'package:flappy_dash/player/obstacle_generator.dart';
import 'package:flappy_dash/utils/ads_manager.dart';
import 'package:flappy_dash/utils/audio_controller.dart';
import 'package:flappy_dash/utils/user_prefereces.dart';
import 'package:flappy_dash/world/parallex_background.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'dash_game_controller.dart';

enum GameState { GAME_STARTED, GAME_OVER, GAME_LAUNCH, GAME_PAUSE }

class FlappyDash extends FlameGame
    with TapDetector, KeyboardEvents, HasCollisionDetection {
  @override
  bool get debugMode => false;

  final DashGameController dashGameController = Get.put(DashGameController());
  late Dash player;
  Timer obstacleGeneratorTimer = Timer(2, repeat: true);

  final UserPreferences userPreferences = UserPreferences();
  late AudioController audioController;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    audioController =
        AudioController(isAudioEnabled: userPreferences.prefGetAudioEnabled());

    player = Dash();

    add(ParallaxBackground());
    add(ObstacleGenerator());
    add(player);

    add(BasePlatform(platformPosition: Vector2(0, size.y)));
    add(BasePlatform(platformPosition: Vector2(0, -20)));

    obstacleGeneratorTimer.onTick = () {
      if (dashGameController.gameState == GameState.GAME_STARTED) {
        add(ObstacleGenerator());
      }
    };

    return super.onLoad();
  }

  @override
  void onDispose() {
    AdsManager.disposeAds();
    super.onDispose();
  }

  @override
  void update(double dt) {
    if (dashGameController.gameState == GameState.GAME_STARTED) {
      obstacleGeneratorTimer.update(dt);
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (dashGameController.gameState == GameState.GAME_STARTED) {
      player.jump();
    }
    super.onTap();
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      if (dashGameController.gameState == GameState.GAME_STARTED) {
        player.jump();
      } else if (dashGameController.gameState == GameState.GAME_OVER) {
        player.retryGame();
      } else {
        player.startGame();
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
