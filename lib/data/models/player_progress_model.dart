import 'package:equatable/equatable.dart';

class PlayerProgressModel extends Equatable {
  final int approved;
  final int total;
  final int percent;

  const PlayerProgressModel({
    required this.approved,
    required this.total,
    required this.percent,
  });

  @override
  List<Object> get props => [approved, total, percent];

  factory PlayerProgressModel.fromJson(Map<String, dynamic> json) {
    return PlayerProgressModel(
      approved: json['approved'] ?? 0,
      total: json['total'] ?? 0,
      percent: json['percent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'approved': approved, 'total': total, 'percent': percent};
  }

  factory PlayerProgressModel.empty() {
    return const PlayerProgressModel(approved: 0, total: 0, percent: 0);
  }
}
