import 'package:next_kick/data/models/player_model.dart';

class UploadPictureArgs {
  final PlayerModel player;
  final String password;
  final String confirmPassword;

  UploadPictureArgs({
    required this.player,
    required this.password,
    required this.confirmPassword,
  });
}
