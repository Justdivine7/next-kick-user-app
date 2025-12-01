import 'package:equatable/equatable.dart';

class FixtureModel extends Equatable {
  final String id;
  final String teamOneName;
  final String teamTwoName;
  final String teamOneId;
  final String teamTwoId;
  final String matchDate;
  final String matchTime;
  final String venue;
  final String status;
  final int teamOneScore;
  final int teamTwoScore;

  const FixtureModel({
    required this.id,
    required this.teamOneName,
    required this.teamTwoName,
    required this.teamOneId,
    required this.teamTwoId,
    required this.matchDate,
    required this.matchTime,
    required this.venue,
    required this.status,
    required this.teamOneScore,
    required this.teamTwoScore,
  });

  /// Create a copy with new values while preserving others
  FixtureModel copyWith({
    String? id,
    String? teamOneName,
    String? teamTwoName,
    String? teamOneId,
    String? teamTwoId,
    String? matchDate,
    String? matchTime,
    String? venue,
    String? status,
    int? teamOneScore,
    int? teamTwoScore,
  }) {
    return FixtureModel(
      id: id ?? this.id,
      teamOneName: teamOneName ?? this.teamOneName,
      teamTwoName: teamTwoName ?? this.teamTwoName,
      teamOneId: teamOneId ?? this.teamOneId,
      teamTwoId: teamTwoId ?? this.teamTwoId,
      matchDate: matchDate ?? this.matchDate,
      matchTime: matchTime ?? this.matchTime,
      venue: venue ?? this.venue,
      status: status ?? this.status,
      teamOneScore: teamOneScore ?? this.teamOneScore,
      teamTwoScore: teamTwoScore ?? this.teamTwoScore,
    );
  }

  /// Convert JSON to Dart model
  factory FixtureModel.fromJson(Map<String, dynamic> json) {
    return FixtureModel(
      id: json['id'] ?? '',
      teamOneName: json['team_one_name'] ?? '',
      teamTwoName: json['team_two_name'] ?? '',
      teamOneId: json['team_one_id'] ?? '',
      teamTwoId: json['team_two_id'] ?? '',
      matchDate: json['match_date'] ?? '',
      matchTime: json['match_time'] ?? '',
      venue: json['venue'] ?? '',
      status: json['status'] ?? '',
      teamOneScore: json['team_one_score'] ?? 0,
      teamTwoScore: json['team_two_score'] ?? 0,
    );
  }

  /// Convert Dart model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team_one_name': teamOneName,
      'team_two_name': teamTwoName,
      'team_one_id': teamOneId,
      'team_two_id': teamTwoId,
      'match_date': matchDate,
      'match_time': matchTime,
      'venue': venue,
      'status': status,
      'team_one_score': teamOneScore,
      'team_two_score': teamTwoScore,
    };
  }

  @override
  List<Object?> get props => [
    id,
    teamOneName,
    teamTwoName,
    teamOneId,
    teamTwoId,
    matchDate,
    matchTime,
    venue,
    status,
    teamOneScore,
    teamTwoScore,
  ];
}
