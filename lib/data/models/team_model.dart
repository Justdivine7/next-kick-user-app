import 'package:equatable/equatable.dart';

class TeamModel extends Equatable {
  final String id;
  final String email;
  final String teamName;
  final String userType;
  final String ageGroup;
  final String location;
  final String teamLogo;

  const TeamModel({
    required this.id,
    required this.email,
    required this.teamName,
    required this.userType,
    required this.ageGroup,
    required this.location,
    required this.teamLogo,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    teamName,
    userType,
    ageGroup,
    location,
    teamLogo,
  ];

  TeamModel copyWith({
    String? id,
    String? email,
    String? teamName,
    String? userType,
    String? ageGroup,
    String? location,
    String? teamLogo,
  }) {
    return TeamModel(
      id: id ?? this.id,
      email: email ?? this.email,
      teamName: teamName ?? this.teamName,
      userType: userType ?? this.userType,
      ageGroup: ageGroup ?? this.ageGroup,
      location: location ?? this.location,
      teamLogo: teamLogo ?? this.teamLogo,
    );
  }

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'],
      email: json['email'] ?? '',
      teamName: json['team_name'] ?? '',
      userType: json['user_type'] ?? '',
      ageGroup: json['age_group'] ?? '',
      location: json['location'] ?? '',
      teamLogo: json['team_logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'team_name': teamName,
      'user_type': userType,
      'age_group': ageGroup,
      'location': location,
      'team_logo': teamLogo,
    };
  }

  factory TeamModel.fromMinimalDetails({
    required String id,
    required String email,
    required String teamName,
    required String userType,
    required String ageGroup,
    required String location,
  }) {
    return TeamModel(
      id: id,
      email: email,
      teamName: teamName,
      userType: userType,
      ageGroup: ageGroup,
      location: location,
      teamLogo: '',
    );
  }
}
