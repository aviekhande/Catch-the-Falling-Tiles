import 'package:equatable/equatable.dart';

class HighScoreModel extends Equatable {
  const HighScoreModel({
    required this.score,
    required this.recordedAt,
  });

  factory HighScoreModel.fromJson(Map<String, dynamic> json) {
    return HighScoreModel(
      score: json['score'] as int? ?? 0,
      recordedAt: DateTime.tryParse(json['recordedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  final int score;
  final DateTime recordedAt;

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [score, recordedAt];
}
