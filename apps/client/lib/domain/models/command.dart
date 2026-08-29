import 'direction.dart';
import 'surface.dart';

class Command {
  const Command({
    required this.direction,
    required this.surface,
    required this.timestamp,
    required this.sessionId,
    this.confidence = 1.0,
    this.cellId,
  });

  final Direction direction;
  final ControlSurface surface;
  final DateTime timestamp;
  final String sessionId;
  final double confidence;
  final String? cellId;
}
