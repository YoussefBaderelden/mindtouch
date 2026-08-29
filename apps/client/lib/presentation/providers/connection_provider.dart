import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/connection_status.dart';
import '../../domain/models/direction.dart';

final connectionProvider =
    NotifierProvider<ConnectionNotifier, ConnectionStatus>(
  ConnectionNotifier.new,
);

class ConnectionNotifier extends Notifier<ConnectionStatus> {
  Timer? _simulationTimer;
  Timer? _pulseTimer;

  @override
  ConnectionStatus build() {
    ref.onDispose(() {
      _simulationTimer?.cancel();
      _pulseTimer?.cancel();
    });
    _startSimulation();
    return const ConnectionStatus(
      phase: ConnectionPhase.connecting,
      deviceName: 'MindTouch Cap',
    );
  }

  void _startSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer(const Duration(seconds: 2), () {
      state = state.copyWith(
        phase: ConnectionPhase.listening,
        signalQuality: 0.87,
        latencyMs: 420,
        message: 'Neural link stable',
      );
    });

    _pulseTimer?.cancel();
    _pulseTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (state.isLive) {
        final random = Random();
        state = state.copyWith(
          signalQuality: (0.75 + random.nextDouble() * 0.24).clamp(0.0, 1.0),
          latencyMs: 380 + random.nextInt(80),
        );
      }
    });
  }
}

final lastDirectionProvider = StateProvider<Direction?>((ref) => null);

final inferenceConfidenceProvider = StateProvider<double>((ref) => 0.0);
