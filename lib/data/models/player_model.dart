// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PlayerModel extends Equatable {
  final String playerId;
  final String email;
  final String userType;
  final bool isActive;
  final String firstName;
  final String lastName;
  final int age;
  final String playerPosition;
  final String profilePicture;
  final String country;
  final String activeBundle;
  final String height;
  final String performanceVideoLink;
  final int progress;

  const PlayerModel({
    required this.playerId,
    required this.email,
    required this.userType,
    required this.activeBundle,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.playerPosition,
    required this.profilePicture,
    required this.country,
    required this.isActive,
    required this.height,
    required this.performanceVideoLink,
    required this.progress,
  });

  @override
  List<Object> get props {
    return [
      playerId,
      email,
      userType,
      isActive,
      firstName,
      lastName,
      age,
      playerPosition,
      profilePicture,
      country,
      activeBundle,
      height,
      performanceVideoLink,
      progress,
    ];
  }

  PlayerModel copyWith({
    String? playerId,
    String? email,
    String? userType,
    bool? isActive,
    String? firstName,
    String? lastName,
    int? age,
    String? playerPosition,
    String? profilePicture,
    String? country,
    String? activeBundle,
    String? performanceVideoLink,
    int? progress,
    String? height,
  }) {
    return PlayerModel(
      playerId: playerId ?? this.playerId,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      isActive: isActive ?? this.isActive,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      playerPosition: playerPosition ?? this.playerPosition,
      profilePicture: profilePicture ?? this.profilePicture,
      country: country ?? this.country,
      activeBundle: activeBundle ?? this.activeBundle,
      height: height ?? this.height,
      performanceVideoLink: performanceVideoLink ?? this.performanceVideoLink,
      progress: progress ?? this.progress,
    );
  }

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      playerId: json['id'] ?? '',
      email: json['email'] ?? '',
      userType: json['user_type'] ?? '',
      isActive: json['is_active'] ?? false,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
       age: (json['age'] is int)
      ? json['age'] as int
      : (json['age'] is double)
          ? (json['age'] as double).toInt()
          : 0,
      playerPosition: json['player_position'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      country: json['country'] ?? '',
      activeBundle: json['active_bundle'] ?? '',
      height: json['height'] ?? '',
      performanceVideoLink: json['performance_video_link'] ?? '',
      progress:
          (json['progress'] is int)
              ? json['progress'] as int
              : (json['progress'] is double)
              ? (json['progress'] as double).toInt()
              : 0,
    );
  }

  factory PlayerModel.fromMinimalDetails({
    required String email,
    required String userType,
    required String firstName,
    required String lastName,
    required int age,
    required String height,
  }) {
    return PlayerModel(
      playerId: '',
      email: email,
      userType: userType,
      isActive: false,
      firstName: firstName,
      lastName: lastName,
      age: age,
      playerPosition: '',
      profilePicture: '',
      country: '',
      activeBundle: '',
      height: height,
      performanceVideoLink: '',
      progress: 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': playerId,
      'email': email,
      'user_type': userType,
      'is_active': isActive,
      'first_name': firstName,
      'last_name': lastName,
      'age': age,
      'player_position': playerPosition,
      'profile_picture': profilePicture,
      'country': country,
      'active_bundle': activeBundle,
      'height': height,
      'performance_video_link': performanceVideoLink,
      'progress': progress,
    };
  }
}
