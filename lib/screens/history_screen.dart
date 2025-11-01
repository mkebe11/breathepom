import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/session.dart';
import '../service/database_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Session> _sessions = [];
  bool _isLoading = true;
  String _filterType = 'all'; // 'all', 'pomodoro', 'breathing'

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    print('[v0] Loading sessions with filter: $_filterType');
    setState(() => _isLoading = true);

    try {
      final sessions = _filterType == 'all'
          ? await DatabaseHelper.instance.getAllSessions()
          : await DatabaseHelper.instance.getSessionsByType(_filterType);

      print('[v0] Loaded ${sessions.length} sessions');

      setState(() {
        _sessions = sessions;
        _isLoading = false;
      });
    } catch (e) {
      print('[v0] Error loading sessions: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteSession(int id) async {
    await DatabaseHelper.instance.deleteSession(id);
    _loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _sessions.isEmpty
                ? _buildEmptyState()
                : _buildSessionsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildFilterChip('Tout', 'all'),
          const SizedBox(width: 8),
          _buildFilterChip('Pomodoro', 'pomodoro'),
          const SizedBox(width: 8),
          _buildFilterChip('Respiration', 'breathing'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterType == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filterType = value);
        _loadSessions();
      },
      selectedColor: const Color(0xFF8B5CF6).withOpacity(0.2),
      checkmarkColor: const Color(0xFF8B5CF6),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune session enregistrée',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complétez une session pour la voir ici',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList() {
    // Group sessions by date
    final groupedSessions = <String, List<Session>>{};
    for (final session in _sessions) {
      final dateKey = DateFormat('yyyy-MM-dd').format(session.completedAt);
      groupedSessions.putIfAbsent(dateKey, () => []).add(session);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedSessions.length,
      itemBuilder: (context, index) {
        final dateKey = groupedSessions.keys.elementAt(index);
        final sessions = groupedSessions[dateKey]!;
        final date = DateTime.parse(dateKey);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _formatDate(date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5CF6),
                ),
              ),
            ),
            ...sessions.map((session) => _buildSessionCard(session)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildSessionCard(Session session) {
    final isPomodoro = session.type == 'pomodoro';
    final color = isPomodoro ? const Color(0xFF8B5CF6) : const Color(0xFF14B8A6);
    final icon = isPomodoro ? Icons.timer : Icons.air;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          isPomodoro ? 'Session Pomodoro' : 'Exercice de respiration',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.formattedDuration),
            if (session.breathingProtocol != null)
              Text(
                'Protocole: ${session.breathingProtocol}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        trailing: Text(
          DateFormat('HH:mm').format(session.completedAt),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Supprimer la session'),
              content: const Text('Voulez-vous supprimer cette session ?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteSession(session.id!);
                  },
                  child: const Text(
                    'Supprimer',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sessionDate = DateTime(date.year, date.month, date.day);

    if (sessionDate == today) {
      return 'Aujourd\'hui';
    } else if (sessionDate == yesterday) {
      return 'Hier';
    } else {
      return DateFormat('EEEE d MMMM').format(date);
    }
  }
}
