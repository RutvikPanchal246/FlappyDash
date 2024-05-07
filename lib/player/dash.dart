import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_dash/utils/ads_manager.dart';
import 'package:games_services/games_services.dart';
import 'package:get/get.dart';

import '../dash_game_controller.dart';
import '../flappy_dash_game.dart';
import '../utils/consts.dart';

class Dash extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<FlappyDash> {
  final DashGameController gameController = Get.find();

  late Vector2 velocity;
  final double gravity = 980;
  double jumpSpeed = 400;

  @override
  FutureOr<void> onLoad() async {
    velocity = Vector2(game.size.x / 4, game.size.y / 2);
    position = velocity;
    _loadFlapAnimation();

    // Add circular hitbox to detect collision
    add(CircleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (gameController.gameState != GameState.GAME_LAUNCH &&
        gameController.gameState != GameState.GAME_PAUSE) {
      position.y += velocity.y * dt;
      velocity.y += gravity * dt;
    }
    super.update(dt);
  }

  void _loadFlapAnimation() async {
    final spriteSize = Vector2.all(64.0);
    final data = SpriteAnimationData.sequenced(
        amount: 12, stepTime: 0.1, textureSize: spriteSize, amountPerRow: 6);
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache("spritesheet_dash_flap.png"), data);
  }

  void jump() {
    game.audioController.playJumpMusic();
    velocity.y = -jumpSpeed;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (gameController.gameState != GameState.GAME_OVER) {
      gameOver();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void startGame() {
    jump();

    gameController.userScore.value = 0;
    game.overlays.remove(keyGameIntro);
    game.overlays.add(keyGameStarted);
    gameController.gameState = GameState.GAME_STARTED;
  }

  void resetGame() {
    velocity = Vector2(game.size.x / 4, game.size.y / 2);
    position = velocity;
    gameController.gameState = GameState.GAME_PAUSE;
  }

  void retryGame() {
    resetGame();
    jump();

    gameController.userScore.value = 0;
    game.overlays.remove(keyGameOver);
    game.overlays.add(keyGameStarted);
    gameController.gameState = GameState.GAME_STARTED;
  }

  void gameOver() async{
    try{
      AdsManager.showRewardedAd(math.Random().nextDouble());

      // Submit score to game services for leaderboard
      // TODO : update leader board id here
      await GamesServices.submitScore(
        score: Score(
          iOSLeaderboardID: '',
          androidLeaderboardID: '',
          value: gameController.userScore.value,
        ),
      );
    }catch(e){
      log(e.toString());
    }

    game.audioController.playCollisionMusic();

    game.overlays.remove(keyGameStarted);
    game.overlays.add(keyGameOver);
    gameController.gameState = GameState.GAME_OVER;
  }
}
