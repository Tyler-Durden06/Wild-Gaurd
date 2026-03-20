import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_state.dart';
import '../widgets/alert_card.dart';
import '../widgets/animations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: GradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildHeader(isDark),
            ),
            const SizedBox(height: 24),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F2133) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF22C55E).withValues(alpha: isDark ? 0.1 : 0.05),
                  ),
                  boxShadow: isDark ? null : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => appState.setSearchQuery(value),
                  style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    hintText: 'Search animals or locations...',
                    hintStyle: TextStyle(color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B)),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF22C55E)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Filter Tabs
            _buildFilterTabs(appState),
            
            const SizedBox(height: 12),
            
            // Main Content
            Expanded(
              child: appState.filteredAlerts.isEmpty
                  ? _buildEmptyState(isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      itemCount: appState.filteredAlerts.length,
                      itemBuilder: (context, index) {
                        final alert = appState.filteredAlerts[index];
                        return AlertCard(
                          alert: alert,
                          onViewDetails: () {
                            context.push('/alert-detail', extra: alert);
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 100), // Space for nav
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HISTORY',
          style: TextStyle(
            color: Color(0xFF22C55E),
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Review past intrusion events',
          style: TextStyle(
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs(AppState appState) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildFilterChip('All', 'All', appState),
          const SizedBox(width: 8),
          _buildFilterChip('High Threat', 'High', appState),
          const SizedBox(width: 8),
          _buildFilterChip('Medium Threat', 'Medium', appState),
          const SizedBox(width: 8),
          _buildFilterChip('Low Threat', 'Low', appState),
          const SizedBox(width: 8),
          _buildFilterChip('Today', 'Today', appState),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value, AppState appState) {
    final isSelected = appState.historyFilter == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => appState.setFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
            ? const Color(0xFF22C55E) 
            : (isDark ? const Color(0xFF0F2133) : Colors.white),
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                    blurRadius: 10,
                  )
                ]
              : (isDark ? null : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF22C55E)
                : (isDark ? const Color(0xFF22C55E).withValues(alpha: 0.1) : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
              ? Colors.white 
              : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B)),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history_toggle_off, 
            size: 64, 
            color: isDark ? const Color(0xFF1E293B) : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No history matches this filter',
            style: TextStyle(
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B), 
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
