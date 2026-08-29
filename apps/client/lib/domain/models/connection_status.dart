enum ConnectionPhase {
  disconnected,
  scanning,
  connecting,
  connected,
  calibrating,
  listening,
  error,
}

class ConnectionStatus {
  const ConnectionStatus({
    required this.phase,
    this.deviceName,
    this.signalQuality = 0,
    this.latencyMs,
    this.message,
  });

  final ConnectionPhase phase;
  final String? deviceName;
  final double signalQuality;
  final int? latencyMs;
  final String? message;

  bool get isLive =>
      phase == ConnectionPhase.connected ||
      phase == ConnectionPhase.listening ||
      phase == ConnectionPhase.calibrating;

  String get phaseLabel => switch (phase) {
        ConnectionPhase.disconnected => 'Offline',
        ConnectionPhase.scanning => 'Scanning',
        ConnectionPhase.connecting => 'Connecting',
        ConnectionPhase.connected => 'Connected',
        ConnectionPhase.calibrating => 'Calibrating',
        ConnectionPhase.listening => 'Listening',
        ConnectionPhase.error => 'Error',
      };

  ConnectionStatus copyWith({
    ConnectionPhase? phase,
    String? deviceName,
    double? signalQuality,
    int? latencyMs,
    String? message,
  }) {
    return ConnectionStatus(
      phase: phase ?? this.phase,
      deviceName: deviceName ?? this.deviceName,
      signalQuality: signalQuality ?? this.signalQuality,
      latencyMs: latencyMs ?? this.latencyMs,
      message: message ?? this.message,
    );
  }
}
