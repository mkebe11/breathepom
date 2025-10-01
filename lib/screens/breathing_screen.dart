import 'package:flutter/material.dart';
import 'dart:async';

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
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _isBreathing = true;
      _cycleCount = 0;
    });

    _runBreathingCycle();
  }

  void _stopBreathing() {
    setState(() {
      _isBreathing = false;
      _currentPhase = 'Inspirez';
      _cycleCount = 0;
    });
    _breathingTimer?.cancel();
    _animationController.reset();
  }

  void _runBreathingCycle() {
    // Inspirez (4 secondes)
    setState(() => _currentPhase = 'Inspirez');
    _animationController.forward(from: 0);

    _breathingTimer = Timer(const Duration(seconds: 4), () {
      if (!_isBreathing) return;

      // Retenez (4 secondes)
      setState(() => _currentPhase = 'Retenez');
      _breathingTimer = Timer(const Duration(seconds: 4), () {
        if (!_isBreathing) return;

        // Expirez (4 secondes)
        setState(() => _currentPhase = 'Expirez');
        _animationController.reverse();

        _breathingTimer = Timer(const Duration(seconds: 4), () {
          if (!_isBreathing) return;

          // Retenez (4 secondes)
          setState(() => _currentPhase = 'Retenez');
          _breathingTimer = Timer(const Duration(seconds: 4), () {
            if (!_isBreathing) return;

            setState(() => _cycleCount++);
            _runBreathingCycle();
          });
        });
      });
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
            duration: '5 min',
            color: const Color(0xFF06B6D4),
            icon: Icons.square,
            onTap: _startBreathing,
          ),
          const SizedBox(height: 16),
          _buildExerciseCard(
            context,
            title: 'Respiration 4-7-8',
            description: 'Idéal pour réduire le stress et l\'anxiété',
            duration: '3 min',
            color: const Color(0xFF8B5CF6),
            icon: Icons.air,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildExerciseCard(
            context,
            title: 'Cohérence cardiaque',
            description: 'Respiration 5-5 pour équilibrer le système nerveux',
            duration: '5 min',
            color: const Color(0xFF10B981),
            icon: Icons.favorite,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildExerciseCard(
            context,
            title: 'Respiration énergisante',
            description: 'Technique rapide pour booster votre énergie',
            duration: '2 min',
            color: const Color(0xFFF59E0B),
            icon: Icons.bolt,
            onTap: () {},
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
