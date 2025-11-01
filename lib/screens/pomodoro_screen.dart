import 'package:flutter/material.dart';
import 'dart:async';
import '../service/database_helper.dart';
import '../models/session.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool _isRunning = false;
  bool _isWorkSession = true;
  int _remainingSeconds = 10; // reduced from 25*60 to 10 seconds for testing
  Timer? _timer;

  final int _workDuration = 10; // reduced from 25*60 to 10 seconds
  final int _shortBreakDuration = 5; // reduced from 5*60 to 5 seconds
  final int _longBreakDuration = 10; // reduced from 15*60 to 10 seconds

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });

    if (_isRunning) {
      final startDuration = _remainingSeconds;

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _timer?.cancel();
            _isRunning = false;
            _saveSession(startDuration);
            _showCompletionDialog();
          }
        });
      });
    } else {
      _timer?.cancel();
    }
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _isRunning = false;
      _remainingSeconds = _isWorkSession ? _workDuration : _shortBreakDuration;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isWorkSession ? 'Session terminée !' : 'Pause terminée !'),
        content: Text(
          _isWorkSession
              ? 'Bravo ! Prenez une pause bien méritée.'
              : 'C\'est reparti pour une nouvelle session !',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isWorkSession = !_isWorkSession;
                _remainingSeconds =
                _isWorkSession ? _workDuration : _shortBreakDuration;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _saveSession(int duration) async {
    if (_isWorkSession) {
      final session = Session(
        type: 'pomodoro',
        duration: duration,
        completedAt: DateTime.now(),
      );
      await DatabaseHelper.instance.insertSession(session);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _isWorkSession
        ? 1 - (_remainingSeconds / _workDuration)
        : 1 - (_remainingSeconds / _shortBreakDuration);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minuteur Pomodoro'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: _isWorkSession
                      ? const Color(0xFF8B5CF6).withOpacity(0.1)
                      : const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  _isWorkSession ? 'Session de travail' : 'Pause',
                  style: TextStyle(
                    color: _isWorkSession
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFF10B981),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 280,
                      height: 280,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _isWorkSession
                              ? const Color(0xFF8B5CF6)
                              : const Color(0xFF10B981),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatTime(_remainingSeconds),
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(_remainingSeconds / 60).ceil()} minutes restantes',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.large(
                    onPressed: _toggleTimer,
                    backgroundColor: _isWorkSession
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFF10B981),
                    child: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 24),
                  FloatingActionButton(
                    onPressed: _resetTimer,
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey[800],
                    child: const Icon(Icons.refresh),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _buildDurationButton(
                      context,
                      '10 sec', // updated label
                      'Travail',
                      _workDuration,
                      true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDurationButton(
                      context,
                      '5 sec', // updated label
                      'Pause courte',
                      _shortBreakDuration,
                      false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDurationButton(
                      context,
                      '10 sec', // updated label
                      'Pause longue',
                      _longBreakDuration,
                      false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationButton(
      BuildContext context,
      String duration,
      String label,
      int seconds,
      bool isWork,
      ) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _timer?.cancel();
          _isRunning = false;
          _isWorkSession = isWork;
          _remainingSeconds = seconds;
        });
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Text(
            duration,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
