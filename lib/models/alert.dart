enum ThreatLevel { low, medium, high }

class Alert {
  final String id;
  final String species;
  final ThreatLevel threatLevel;
  final String location;
  final DateTime timestamp;
  final String imageUrl;
  final String description;
  final String message;

  Alert({
    required this.id,
    required this.species,
    required this.threatLevel,
    required this.location,
    required this.timestamp,
    required this.imageUrl,
    required this.description,
    required this.message,
  });

  String get threatLevelLabel {
    switch (threatLevel) {
      case ThreatLevel.low:
        return 'Low';
      case ThreatLevel.medium:
        return 'Medium';
      case ThreatLevel.high:
        return 'High';
    }
  }
}
