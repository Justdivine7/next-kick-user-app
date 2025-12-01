// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TournamentModel extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final String? location;

  const TournamentModel({this.id, this.title, this.description, this.location});

  @override
  List<Object?> get props => [id, title, description, location];

  TournamentModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
  }) {
    return TournamentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
    );
  }

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    return TournamentModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
    };
  }
}
