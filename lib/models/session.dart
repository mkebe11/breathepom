class Session {
  final int? id;
  final String type; // 'pomodoro' ou 'breathing'
  final int duration; // en secondes
  final String? breathingProtocol; // '4-4-4-4', '4-7-8', etc.
  final DateTime completedAt;

  Session({
    this.id,
    required this.type,
    required this.duration,
    this.breathingProtocol,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'duration': duration,
      'breathingProtocol': breathingProtocol,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'] as int?,
      type: map['type'] as String,
      duration: map['duration'] as int,
      breathingProtocol: map['breathingProtocol'] as String?,
      completedAt: DateTime.parse(map['completedAt'] as String),
    );
  }

  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (minutes > 0) {
      return '$minutes min ${seconds > 0 ? "$seconds s" : ""}';
    }
    return '$seconds s';
  }
}
