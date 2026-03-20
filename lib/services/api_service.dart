import 'dart:async';
import 'dart:math';
import '../models/alert.dart';
import '../models/system_status.dart';

class MockApiService {
  final List<Alert> _history = [
    Alert(
      id: '1',
      species: 'Elephant',
      threatLevel: ThreatLevel.high,
      location: 'Sector A - Perimeter 4',
      timestamp: DateTime.now().subtract(const Duration(minutes: 42)),
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCOgLFZ7C0ITKLCmJlCRXomYb1sOE9FFeMAoHdFW6D8oJVl-WlqM8vYwxK25qBe-LbBlA4rpv8pc2J-9qGAOqNAeFBCAg6auXKG8WMFI3qDN0lXjl_f54M0W7wDsCVN5uKxCvct8V1YqKyjTDI2X5Fh7QHw0mUFcq-AgOSgO_WvhMN3L2ic8qdfuDQeB0zHlED8yrk0RZUBo73NyxHZ4ChsiZ0YVmdziLU12myQl_o5ZzmUs-MpfcpP6cNYjJx3jSaiuQcW8Pz8774f',
      description: 'Large mammal spotted moving through the perimeter zone.',
      message: '⚠ HIGH ALERT: Elephant detected near Farm Border South!',
    ),
    Alert(
      id: '1710927600001',
      species: 'Wild Boar',
      threatLevel: ThreatLevel.medium,
      location: 'Sector B - Ridge Trail',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDL__pnSU1lomnMbe5X_6q0AiC5OXmfZSMU4VyF8bdJAltmfZ2ePqzsqdLpAViyqtQu8tCxKzTT44Kk5bij_B6rf-qmw9TLBxJeO60w_U5ip1N9WXgbDiFjNXt7Ugj86KUQhj66bEadlHaQ0iO1I5VLFeEwRk4vUN8fuVboU756tZt7PobEq8cdWCUDJHN7_NZ70cFdx-d4s6Vj-tueB_gNTNaiYhL4I6BHay0gkn-nGzpXIK3YmCJ8pvTwRl12FY1deNCmyuvkDdhY',
      description: 'Group of boars detected near agricultural boundary.',
      message: '⚠ Wildlife Alert: Boars spotted near agricultural plots.',
    ),
    Alert(
      id: '1710927600002',
      species: 'Deer',
      threatLevel: ThreatLevel.low,
      location: 'Sector C - Water Hole',
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuABNDyH8PeWPkFYq7fNomwI80HDORSTbdBfFDc7C449P4Oc7KD9GtLliioDkCAHzbf5xoplnut1aVnJrJlkAc4p2vg2g8kh5wfTHfO_dFvj3L-X0WwRN1ZZpORBiCc4Ej5NpfHf0bUgZQj8MahuEJIrdCsUbFC2bRLtHTjXHMWVDwnMLVFKcbEicdPHTSAFzurZO6_5lJVpT7RhEnkxZXuAIPQmiqUc2nPtxglT5pVbvc8QUI-rqaTfXGRtkFVrHxIT-RpwA7MGkUop',
      description: 'Passive activity observed at the watering station.',
      message: 'Notice: Normal wildlife activity at Sector C.',
    ),
  ];

  final StreamController<Alert> _alertController = StreamController<Alert>.broadcast();

  MockApiService() {
    Timer.periodic(const Duration(seconds: 60), (timer) {
      final newAlert = _generateRandomAlert();
      _history.insert(0, newAlert);
      _alertController.add(newAlert);
    });
  }

  Stream<Alert> get onNewAlert => _alertController.stream;

  Future<List<Alert>> getAlertHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_history);
  }

  Future<SystemStatus> getSystemStatus() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SystemStatus(
      batteryLevel: 85,
      networkStrength: 4,
      aiEngineActive: true,
    );
  }

  Future<Alert> fetchLatestAlert() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _history.first;
  }

  Future<Alert?> checkForNewAlerts(String lastAlertId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_history.isNotEmpty && _history.first.id != lastAlertId) {
      return _history.first;
    }
    return null;
  }

  Alert _generateRandomAlert() {
    final speciesList = ['Elephant', 'Wild Boar', 'Deer', 'Tiger'];
    final locations = ['Sector A - Perimeter 4', 'Sector B - Ridge Trail', 'Sector C - Water Hole', 'Northern Fence'];
    final descriptions = [
      'Indicated movement near primary boundary.',
      'Group detected moving through dense vegetation.',
      'Grazing activity observed in secondary zone.',
      'Lone individual spotted crossing south trail.'
    ];
    final messages = [
      '⚠ HIGH ALERT: Large animal approaching residential zone!',
      '⚠ Wildlife Alert: Unusual activity detected in Sector B.',
      'Notice: Animal activity within normal parameters.',
      '⚠ WARNING: Potential predator spotted near trail.'
    ];
    final images = [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCOgLFZ7C0ITKLCmJlCRXomYb1sOE9FFeMAoHdFW6D8oJVl-WlqM8vYwxK25qBe-LbBlA4rpv8pc2J-9qGAOqNAeFBCAg6auXKG8WMFI3qDN0lXjl_f54M0W7wDsCVN5uKxCvct8V1YqKyjTDI2X5Fh7QHw0mUFcq-AgOSgO_WvhMN3L2ic8qdfuDQeB0zHlED8yrk0RZUBo73NyxHZ4ChsiZ0YVmdziLU12myQl_o5ZzmUs-MpfcpP6cNYjJx3jSaiuQcW8Pz8774f',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDL__pnSU1lomnMbe5X_6q0AiC5OXmfZSMU4VyF8bdJAltmfZ2ePqzsqdLpAViyqtQu8tCxKzTT44Kk5bij_B6rf-qmw9TLBxJeO60w_U5ip1N9WXgbDiFjNXt7Ugj86KUQhj66bEadlHaQ0iO1I5VLFeEwRk4vUN8fuVboU756tZt7PobEq8cdWCUDJHN7_NZ70cFdx-d4s6Vj-tueB_gNTNaiYhL4I6BHay0gkn-nGzpXIK3YmCJ8pvTwRl12FY1deNCmyuvkDdhY',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuABNDyH8PeWPkFYq7fNomwI80HDORSTbdBfFDc7C449P4Oc7KD9GtLliioDkCAHzbf5xoplnut1aVnJrJlkAc4p2vg2g8kh5wfTHfO_dFvj3L-X0WwRN1ZZpORBiCc4Ej5NpfHf0bUgZQj8MahuEJIrdCsUbFC2bRLtHTjXHMWVDwnMLVFKcbEicdPHTSAFzurZO6_5lJVpT7RhEnkxZXuAIPQmiqUc2nPtxglT5pVbvc8QUI-rqaTfXGRtkFVrHxIT-RpwA7MGkUop',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAreVXYZPGE1RogdBsSWU2WLpcl4jQxaNnWpj0eKC1H5EWA_M2ziF7KBRXUcELl5qijdljU_3sNxlUk6lG4XkLmEJty156xwb02hUVS2c-X_zG8fmedByW1qMmHz1WyKZYrf1fwvr25T7NocTgKavsOeGs7-vHX52InkSbFloPat26WnH2lSIW781AatMKV0Gtb25wUsJfG1KPv2gIwCYSNF9o-9EO9fpoYc74vMcFIGxhHgOhOxeBDb__9lIMfSNAWapmv0DP8JpWV'
    ];
    final random = Random();
    final idx = random.nextInt(speciesList.length);

    return Alert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      species: speciesList[idx],
      threatLevel: idx == 3 ? ThreatLevel.high : (idx == 1 ? ThreatLevel.medium : ThreatLevel.low),
      location: locations[random.nextInt(locations.length)],
      timestamp: DateTime.now(),
      imageUrl: images[idx],
      description: descriptions[random.nextInt(descriptions.length)],
      message: messages[random.nextInt(messages.length)],
    );
  }
}
