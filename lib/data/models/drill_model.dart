class DrillModel {
  final int id;
  final String title;
  final String img;
  final String description;
  final String position;
  final String level;
  final int order;
  final bool isCompleted;
  final bool isApproved;
  final bool isRejected;
  final String? submissionLink;
  final String? submittedAt;
  final bool canAttempt;
  final String status;

  DrillModel({
    required this.id,
    required this.title,
    required this.img,
    required this.description,
    required this.position,
    required this.level,
    required this.order,
    required this.isCompleted,
    required this.isApproved,
    required this.isRejected,
    this.submissionLink,
    this.submittedAt,
    required this.canAttempt,
    required this.status,
  });

  /// ✅ Safe JSON parsing
  factory DrillModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      if (value is int) return value == 1;
      return false;
    }

    return DrillModel(
      id: parseInt(json['id']),
      title: json['title'] ?? '',
      img: json['img'] ?? '',
      description: json['description'] ?? '',
      position: json['position'] ?? '',
      level: json['level'] ?? '',
      order: parseInt(json['order']),
      isCompleted: parseBool(json['is_completed']),
      isApproved: parseBool(json['is_approved']),
      isRejected: parseBool(json['is_rejected']),
      submissionLink: json['submission_link'],
      submittedAt: json['submitted_at'],
      canAttempt: parseBool(json['can_attempt']),
      status: json['status'] ?? '',
    );
  }

  /// ✅ Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'img': img,
      'description': description,
      'position': position,
      'level': level,
      'order': order,
      'is_completed': isCompleted,
      'is_approved': isApproved,
      'is_rejected': isRejected,
      'submission_link': submissionLink,
      'submitted_at': submittedAt,
      'can_attempt': canAttempt,
      'status': status,
    };
  }

  /// ✅ CopyWith method
  DrillModel copyWith({
    int? id,
    String? title,
    String? img,
    String? description,
    String? position,
    String? level,
    int? order,
    bool? isCompleted,
    bool? isApproved,
    bool? isRejected,
    String? submissionLink,
    String? submittedAt,
    bool? canAttempt,
    String? status,
  }) {
    return DrillModel(
      id: id ?? this.id,
      title: title ?? this.title,
      img: img ?? this.img,
      description: description ?? this.description,
      position: position ?? this.position,
      level: level ?? this.level,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      isApproved: isApproved ?? this.isApproved,
      isRejected: isRejected ?? this.isRejected,
      submissionLink: submissionLink ?? this.submissionLink,
      submittedAt: submittedAt ?? this.submittedAt,
      canAttempt: canAttempt ?? this.canAttempt,
      status: status ?? this.status,
    );
  }
}
