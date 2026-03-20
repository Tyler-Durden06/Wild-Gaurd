import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/alert.dart';
import '../models/system_status.dart';

class FirebaseApiService {
  // Only access Firestore if not on web or if we have a way to handle the crash
  // Only access Firestore if not on web and if Firebase is initialized
  FirebaseFirestore? get _firestore {
    if (kIsWeb) return null;
    try {
      if (Firebase.apps.isEmpty) return null;
      return FirebaseFirestore.instance;
    } catch (e) {
      debugPrint("Could not access Firestore: $e");
      return null;
    }
  }

  FirebaseApiService() {
    final firestore = _firestore;
    if (!kIsWeb && firestore != null) {
      firestore.settings = const Settings(persistenceEnabled: true);
    }
  }

  Stream<List<Alert>> get alertsStream {
    final firestore = _firestore;
    if (kIsWeb || firestore == null) {
      // Mock stream for web/local development
      return Stream.value([
        Alert(
          id: 'mock1',
          species: 'Elephant',
          threatLevel: ThreatLevel.high,
          location: 'Thadagam Road, Coimbatore',
          timestamp: DateTime.now(),
          imageUrl: 'https://images.unsplash.com/photo-1557050543-4d5f4e07ef46',
          description: 'Large tusker approaching agricultural fence.',
          message: 'High Priority Alert: Elephant detected near perimeter.',
        ),
        Alert(
          id: 'mock2',
          species: 'Wild Boar',
          threatLevel: ThreatLevel.medium,
          location: 'Boundary Fence, Sector 4',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          imageUrl: 'https://images.unsplash.com/photo-1517849845537-4d257902454a',
          description: 'Group of 5 boars detected rooting near the gate.',
          message: 'Medium Priority: Wild boar activity detected.',
        ),
      ]);
    }

    return firestore
        .collection('alerts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Alert(
          id: doc.id,
          species: data['animal'] ?? 'Unknown',
          threatLevel: _parseThreatLevel(data['threatLevel']),
          location: data['location'] ?? 'Unknown Location',
          timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          imageUrl: data['imageUrl'] ?? '',
          description: data['message'] ?? 'No description provided.',
          message: data['message'] ?? 'Wildlife detected!',
        );
      }).toList();
    });
  }

  Future<List<Alert>> getAlertHistory() async {
    final firestore = _firestore;
    if (kIsWeb || firestore == null) {
      return [
        Alert(
          id: 'hist1',
          species: 'Leopard',
          threatLevel: ThreatLevel.high,
          location: 'Northern Corridor',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          imageUrl: '',
          description: 'Solo adult leopard crossing tracking zone.',
          message: 'High Alert: Leopard sighting confirmed.',
        ),
      ];
    }

    final snapshot = await firestore
        .collection('alerts')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Alert(
        id: doc.id,
        species: data['animal'] ?? 'Unknown',
        threatLevel: _parseThreatLevel(data['threatLevel']),
        location: data['location'] ?? 'Unknown Location',
        timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        imageUrl: data['imageUrl'] ?? '',
        description: data['message'] ?? 'No description provided.',
        message: data['message'] ?? 'Wildlife detected!',
      );
    }).toList();
  }

  Future<SystemStatus> getSystemStatus() async {
    return SystemStatus(
      batteryLevel: 92,
      networkStrength: 4,
      aiEngineActive: true,
    );
  }

  ThreatLevel _parseThreatLevel(String? level) {
    switch (level?.toUpperCase()) {
      case 'HIGH':
        return ThreatLevel.high;
      case 'MEDIUM':
        return ThreatLevel.medium;
      case 'LOW':
      default:
        return ThreatLevel.low;
    }
  }
}
