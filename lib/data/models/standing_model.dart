import 'package:equatable/equatable.dart';

class StandingModel extends Equatable {
  final String id;
  final String teamName;
  final int points;

  const StandingModel({
    required this.id,
    required this.teamName,
    required this.points,
  });

  factory StandingModel.fromJson(Map<String, dynamic> json) {
    return StandingModel(
      id: json['id'] as String,
      teamName: json['team_name'] as String,
      points: json['points'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team_name': teamName,
      'points': points,
    };
  }

  StandingModel copyWith({
    String? id,
    String? teamName,
    int? points,
  }) {
    return StandingModel(
      id: id ?? this.id,
      teamName: teamName ?? this.teamName,
      points: points ?? this.points,
    );
  }

  @override
  List<Object?> get props => [id, teamName, points];
}
