import 'dart:async';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/alert.dart';
import '../models/system_status.dart';
import '../services/firebase_api_service.dart';
import '../services/notification_service.dart';

enum ThemeSettings { system, light, dark }

class AppState extends ChangeNotifier {
  final FirebaseApiService _apiService = FirebaseApiService();
  final NotificationService _notificationService = NotificationService();

  List<Alert> _alerts = [];
  SystemStatus? _status;
  ThemeSettings _themeSetting = ThemeSettings.system;
  bool _isVigilanceMode = false;
  bool _isNotificationEnabled = true;
  String _historyFilter = 'All';
  String _searchQuery = '';
  Alert? _currentBannerAlert;
  StreamSubscription<List<Alert>>? _alertsSubscription;

  AppState() {
    _init();
  }

  Future<void> _init() async {
    await _notificationService.init();
    _status = await _apiService.getSystemStatus();
    
    // Initial fetch for history
    _alerts = await _apiService.getAlertHistory();
    notifyListeners();

    // Start real-time listener
    _alertsSubscription = _apiService.alertsStream.listen((newAlerts) {
      if (!_isNotificationEnabled) {
        _alerts = newAlerts;
        notifyListeners();
        return;
      }

      // Check for new alerts to trigger notifications and banner
      for (final alert in newAlerts) {
        if (!_alerts.any((a) => a.id == alert.id)) {
          _triggerAlertNotification(alert);
          _showBanner(alert);
        }
      }

      _alerts = newAlerts;
      notifyListeners();
    });
  }

  void _triggerAlertNotification(Alert alert) {
    _notificationService.showNotification(
      id: alert.id.hashCode,
      title: alert.threatLevel == ThreatLevel.high ? '⚠ HIGH ALERT' : '⚠ Wildlife Alert',
      body: '${alert.species} detected near ${alert.location}',
      threatLevel: alert.threatLevel,
    );
  }

  void _showBanner(Alert alert) {
    _currentBannerAlert = alert;
    notifyListeners();
    // Auto-hide banner after 5 seconds
    Timer(const Duration(seconds: 5), () {
      _currentBannerAlert = null;
      notifyListeners();
    });
  }

  Alert? get currentBannerAlert => _currentBannerAlert;
  Alert? get latestAlert => _alerts.isNotEmpty ? _alerts.first : null;

  List<Alert> get alerts => _alerts;
  List<Alert> get filteredAlerts {
    var list = _alerts.where((a) {
      if (_searchQuery.isNotEmpty &&
          !a.species.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !a.location.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_historyFilter == 'All') return true;
      
      // Handle Threat Level Filtering
      if (_historyFilter == 'High' && a.threatLevel != ThreatLevel.high) return false;
      if (_historyFilter == 'Medium' && a.threatLevel != ThreatLevel.medium) return false;
      if (_historyFilter == 'Low' && a.threatLevel != ThreatLevel.low) return false;

      // Handle Time Filtering (Optional fallback)
      final now = DateTime.now();
      if (_historyFilter == 'Today') {
        return a.timestamp.year == now.year &&
            a.timestamp.month == now.month &&
            a.timestamp.day == now.day;
      }
      
      return true;
    }).toList();
    return list;
  }

  SystemStatus? get status => _status;
  ThemeSettings get themeSetting => _themeSetting;
  bool get isVigilanceMode => _isVigilanceMode;
  bool get isNotificationEnabled => _isNotificationEnabled;
  String get historyFilter => _historyFilter;

  Future<void> refreshAlerts() async {
    // With Firestore snapshots, manual refresh is rarely needed, 
    // but we can re-fetch to ensure sync.
    _alerts = await _apiService.getAlertHistory();
    _status = await _apiService.getSystemStatus();
    notifyListeners();
  }

  void takeAction(Alert alert) {
    debugPrint('Action initiated for alert: ${alert.id}');
    // Logic for taking action would go here
  }

  Future<void> shareAlert(Alert alert) async {
    final text = '⚠ Wildlife Alert!\n${alert.species} detected near ${alert.location} at ${_formatTime(alert.timestamp)}';
    // SharePlus is the static entry point in the latest share_plus
    await Share.share(text);
  }

  String _formatTime(DateTime dt) {
    final hr = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final min = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hr:$min $ampm';
  }

  void setTheme(ThemeSettings setting) {
    _themeSetting = setting;
    notifyListeners();
  }

  void toggleVigilanceMode() {
    _isVigilanceMode = !_isVigilanceMode;
    notifyListeners();
  }

  void toggleNotifications() {
    _isNotificationEnabled = !_isNotificationEnabled;
    notifyListeners();
  }

  void setFilter(String? filter) {
    _historyFilter = filter ?? 'All';
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  @override
  void dispose() {
    _alertsSubscription?.cancel();
    super.dispose();
  }
}
