
import 'package:get/get.dart';

import 'flappy_dash_game.dart';

class DashGameController extends GetxController {
  GameState gameState = GameState.GAME_LAUNCH;
  RxInt userScore = RxInt(0);
}
