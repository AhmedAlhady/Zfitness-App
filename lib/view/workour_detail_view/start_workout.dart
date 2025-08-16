import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application_1/view/finish_workout/finish_workout_screen.dart';

class WorkoutTimerScreen extends StatefulWidget {
  // Accept the flattened list of individual exercises
  final List<Map> workoutExercises; // Expecting a list of exercise maps
  const WorkoutTimerScreen({Key? key, required this.workoutExercises}) : super(key: key);

  @override
  State<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen>
    with SingleTickerProviderStateMixin {
  // --- Configuration ---
  // Use the passed workout exercises
  late List<Map> _workouts;
  static const int _prepSeconds = 5;
  static const int _workoutSeconds = 45; // You might want to make this dynamic based on exercise data

  // --- State ---
  late AudioPlayer _audioPlayer;
  Timer? _timer;
  int _remaining = _prepSeconds;
  bool _isPrep = true;
  bool _isPaused = false;
  int _index = 0; // Current exercise index
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize _workouts with the flattened list of exercises
    _workouts = widget.workoutExercises;

    _audioPlayer = AudioPlayer();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _isPrep ? _prepSeconds : _workoutSeconds),
    );
    _animation = Tween(begin: 1.0, end: 0.0).animate(_animationController);

    // Start the first phase (preparation) if there are exercises
    if (_workouts.isNotEmpty) {
      _startPhase();
    }
  }

  void _startPhase() {
    _timer?.cancel();
    _animationController.reset();
    setState(() {
      _isPaused = false;
      _remaining = _isPrep ? _prepSeconds : _workoutSeconds;
    });
    _animationController.duration = Duration(seconds: _remaining);
    _animation = Tween(begin: 1.0, end: 0.0).animate(_animationController);
    _animationController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!_isPaused) {
        setState(() {
          _remaining--;
          if (_remaining <= 0) {
            t.cancel();
            _playBeep();
            if (_isPrep) {
              // switch to workout
              _isPrep = false;
              _startPhase();
            } else {
              // Workout phase is done, move to next exercise or finish
              _isPrep = true; // Switch back to prep for the next exercise
              _index++; // Move to the next exercise
              if (_index < _workouts.length) {
                 _startPhase(); // Start prep for the next workout
              } else {
                // All workouts are done, navigate to finish screen
                 Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FinishWorkoutScreen(),
                    ),
                  );
              }
            }
          }
        });
      }
    });
  }

  void _playBeep() async {
    // Consider adding different sounds for prep end and workout end
    await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _animationController.stop();
      } else {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if _workouts is initialized and not empty before accessing elements
    final bool workoutsAvailable = _workouts.isNotEmpty;
    final bool phaseDone = !_isPrep && _remaining <= 0;
    // Check if it's the last exercise
    final bool lastWorkout = workoutsAvailable ? _index == _workouts.length - 1 : true;

    // Calculate progress value based on the current phase
    double currentPhaseProgress = _remaining / (_isPrep ? _prepSeconds : _workoutSeconds);
    // Calculate overall progress across all exercises
    double overallProgress = workoutsAvailable ? (_index + (1.0 - currentPhaseProgress)) / _workouts.length : 0.0;


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                // Display current exercise number out of total exercises
                workoutsAvailable ? '${_index + 1}/${_workouts.length}' : '0/0',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
      body: workoutsAvailable ? Padding( // Only show body content if workouts are available
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: overallProgress, // Use overall progress
              backgroundColor: Colors.grey[200],
              color: Colors.blueAccent,
              minHeight: 6,
            ),
            const SizedBox(height: 30),

            // Workout phase indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    _isPrep
                        ? Colors.grey[200]
                        : Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _isPrep ? 'PREPARATION' : 'WORK IT!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _isPrep ? Colors.grey : Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Workout name
            Text(
              _workouts[_index]["title"].toString(), // Access the exercise title from the map
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Circular timer with animation
            SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[100],
                    ),
                  ),

                  // Progress circle
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return SizedBox(
                        width: 250,
                        height: 250,
                        child: CircularProgressIndicator(
                          value: _animation.value,
                          strokeWidth: 10,
                          backgroundColor: Colors.transparent,
                          color: _isPrep ? Colors.grey : Colors.blueAccent,
                        ),
                      );
                    },
                  ),

                  // Timer text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_remaining',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: _isPrep ? Colors.grey : Colors.blueAccent,
                        ),
                      ),
                      Text(
                        'seconds',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pause/Resume button
                ElevatedButton(
                  onPressed: phaseDone ? null : _togglePause,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isPaused ? Icons.play_arrow : Icons.pause,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isPaused ? 'Resume' : 'Pause',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                // Next/Finish button (only visible when phase is done)
                if (phaseDone)
                  ElevatedButton(
                    onPressed: () {
                      if (lastWorkout) {
                        // Navigate to finish screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FinishWorkoutScreen(),
                          ),
                        );
                      } else {
                        // Move to the next workout
                        _isPrep = true; // Start prep for the next exercise
                        _index++; // Increment index
                        _startPhase(); // Start the next phase
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          lastWorkout ? Colors.green : Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          lastWorkout ? Icons.done_all : Icons.skip_next,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          lastWorkout ? 'Finish' : 'Next',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ) : const Center( // Show a message if no workouts are available
        child: Text(
          "No exercises found for this workout.",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }
}
