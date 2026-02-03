import 'dart:convert';

class DayPlan {
  final String id;
  final String destination;
  final String duration;
  final String budget;
  final String season;
  final String fullPlanText;
  final DateTime createdAt;

  DayPlan({
    required this.id,
    required this.destination,
    required this.duration,
    required this.budget,
    required this.season,
    required this.fullPlanText,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'destination': destination,
      'duration': duration,
      'budget': budget,
      'season': season,
      'fullPlanText': fullPlanText,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DayPlan.fromMap(Map<String, dynamic> map) {
    return DayPlan(
      id: map['id'],
      destination: map['destination'],
      duration: map['duration'],
      budget: map['budget'],
      season: map['season'],
      fullPlanText: map['fullPlanText'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());
  factory DayPlan.fromJson(String source) => DayPlan.fromMap(json.decode(source));
}