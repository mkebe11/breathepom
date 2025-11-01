import 'package:flutter/material.dart';
import 'dart:async';
import '../service/database_helper.dart';
import '../models/session.dart';

class BreathingPattern {
  final String name;
  final List<BreathingPhase> phases;
  final int animationDuration;
  final int maxDurationMinutes;

  BreathingPattern({
    required this.name,
    required this.phases,
    required this.animationDuration,
    required this.maxDurationMinutes,
  });
}

class BreathingPhase {
  final String label;
  final int duration;
  final bool isInhale;

  BreathingPhase({
    required this.label,
    required this.duration,
    required this.isInhale,
  });
}

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  bool _isBreathing = false;
  String _currentPhase = 'Inspirez';
  late AnimationController _animationController;
  Timer? _breathingTimer;
  int _cycleCount = 0;
  BreathingPattern? _currentPattern;
  int _currentPhaseIndex = 0;
  DateTime? _sessionStartTime;
  Timer? _durationCheckTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _breathingTimer?.cancel();
    _durationCheckTimer?.cancel();
    super.dispose();
  }

  void _startBreathing(BreathingPattern pattern) {
    setState(() {
      _isBreathing = true;
      _cycleCount = 0;
      _currentPattern = pattern;
      _currentPhaseIndex = 0;
      _sessionStartTime = DateTime.now();
    });

    _animationController.duration = Duration(seconds: pattern.animationDuration);
    _durationCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sessionStartTime != null && _currentPattern != null) {
        final elapsed = DateTime.now().difference(_sessionStartTime!);
        final maxDuration = Duration(minutes: _currentPattern!.maxDurationMinutes);

        if (elapsed >= maxDuration) {
          _stopBreathing();
        }
      }
    });
    _runBreathingCycle();
  }

  Future<void> _saveSession() async {
    if (_sessionStartTime != null && _currentPattern != null) {
      final duration = DateTime.now().difference(_sessionStartTime!).inSeconds;

      if (duration >= 30) {
        final session = Session(
          type: 'breathing',
          duration: duration,
          breathingProtocol: _currentPattern!.name,
          completedAt: DateTime.now(),
        );
        await DatabaseHelper.instance.insertSession(session);
        print('[v0] Session saved: ${session.breathingProtocol}, duration: $duration seconds');
      }
    }
  }

  void _stopBreathing() {
    _saveSession();

    setState(() {
      _isBreathing = false;
      _currentPhase = 'Inspirez';
      _cycleCount = 0;
      _currentPattern = null;
      _currentPhaseIndex = 0;
      _sessionStartTime = null;
    });
    _breathingTimer?.cancel();
    _durationCheckTimer?.cancel();
    _animationController.reset();
  }

  void _runBreathingCycle() {
    if (_currentPattern == null || !_isBreathing) return;

    final phase = _currentPattern!.phases[_currentPhaseIndex];

    setState(() => _currentPhase = phase.label);

    if (phase.isInhale) {
      _animationController.forward(from: 0);
    } else if (phase.label.contains('Expirez')) {
      _animationController.reverse();
    }

    _breathingTimer = Timer(Duration(seconds: phase.duration), () {
      if (!_isBreathing) return;

      _currentPhaseIndex++;

      if (_currentPhaseIndex >= _currentPattern!.phases.length) {
        _currentPhaseIndex = 0;
        setState(() => _cycleCount++);
      }

      _runBreathingCycle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Respiration guidée'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isBreathing ? _buildBreathingView() : _buildExerciseList(),
      ),
    );
  }

  Widget _buildBreathingView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Spacer(),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                width: 200 + (_animationController.value * 80),
                height: 200 + (_animationController.value * 80),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF06B6D4).withOpacity(0.6),
                      const Color(0xFF8B5CF6).withOpacity(0.3),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),
          Text(
            _currentPhase,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Cycle $_cycleCount',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _stopBreathing,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Arrêter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildExerciseList() {
    final boxBreathing = BreathingPattern(
      name: '4-4-4-4',
      animationDuration: 4,
      maxDurationMinutes: 0, // reduced from 5 to 0 minutes
      phases: [
        BreathingPhase(label: 'Inspirez', duration: 2, isInhale: true), // reduced from 4 to 2 seconds
        BreathingPhase(label: 'Retenez', duration: 2, isInhale: false), // reduced from 4 to 2 seconds
        BreathingPhase(label: 'Expirez', duration: 2, isInhale: false), // reduced from 4 to 2 seconds
        BreathingPhase(label: 'Retenez', duration: 2, isInhale: false), // reduced from 4 to 2 seconds
      ],
    );

    final breathing478 = BreathingPattern(
      name: '4-7-8',
      animationDuration: 2,
      maxDurationMinutes: 0, // reduced from 3 to 0 minutes
      phases: [
        BreathingPhase(label: 'Inspirez', duration: 2, isInhale: true), // reduced from 4 to 2 seconds
        BreathingPhase(label: 'Retenez', duration: 3, isInhale: false), // reduced from 7 to 3 seconds
        BreathingPhase(label: 'Expirez', duration: 3, isInhale: false), // reduced from 8 to 3 seconds
      ],
    );

    final coherenceCardiaque = BreathingPattern(
      name: 'Cohérence cardiaque',
      animationDuration: 2,
      maxDurationMinutes: 0, // reduced from 5 to 0 minutes
      phases: [
        BreathingPhase(label: 'Inspirez', duration: 2, isInhale: true), // reduced from 5 to 2 seconds
        BreathingPhase(label: 'Expirez', duration: 2, isInhale: false), // reduced from 5 to 2 seconds
      ],
    );

    final energizing = BreathingPattern(
      name: 'Énergisante',
      animationDuration: 1,
      maxDurationMinutes: 0, // reduced from 2 to 0 minutes
      phases: [
        BreathingPhase(label: 'Inspirez', duration: 1, isInhale: true), // reduced from 2 to 1 second
        BreathingPhase(label: 'Expirez', duration: 1, isInhale: false), // reduced from 2 to 1 second
      ],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choisissez un exercice',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildExerciseCard(
            context,
            title: 'Respiration 4-4-4-4',
            description: 'Technique de respiration carrée pour la relaxation',
            duration: '10 sec', // updated label from 5 min
            color: const Color(0xFF06B6D4),
            icon: Icons.square,
            onTap: () => _startBreathing(boxBreathing),
          ),
          const SizedBox(height: 16),
          _buildExerciseCard(
            context,
            title: 'Respiration 4-7-8',
            description: 'Idéal pour réduire le stress et l\'anxiété',
            duration: '10 sec', // updated label from 3 min
            color: const Color(0xFF8B5CF6),
            icon: Icons.air,
            onTap: () => _startBreathing(breathing478),
          ),
          const SizedBox(height: 16),
          _buildExerciseCard(
            context,
            title: 'Cohérence cardiaque',
            description: 'Respiration 5-5 pour équilibrer le système nerveux',
            duration: '10 sec', // updated label from 5 min
            color: const Color(0xFF10B981),
            icon: Icons.favorite,
            onTap: () => _startBreathing(coherenceCardiaque),
          ),
          const SizedBox(height: 16),
          _buildExerciseCard(
            context,
            title: 'Respiration énergisante',
            description: 'Technique rapide pour booster votre énergie',
            duration: '10 sec', // updated label from 2 min
            color: const Color(0xFFFEB0B0),
            icon: Icons.bolt,
            onTap: () => _startBreathing(energizing),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
      BuildContext context, {
        required String title,
        required String description,
        required String duration,
        required Color color,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(Icons.access_time, color: Colors.grey[400], size: 20),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
