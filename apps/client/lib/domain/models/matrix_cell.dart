import 'package:flutter/material.dart';

enum MatrixCellKind { action, navigation, confirm, cancel, sos }

class MatrixCell {
  const MatrixCell({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.icon,
    this.kind = MatrixCellKind.action,
    this.accentColor,
    this.directionHint,
  });

  final String id;
  final String label;
  final String subtitle;
  final IconData icon;
  final MatrixCellKind kind;
  final Color? accentColor;
  final String? directionHint;

  bool get isCancel => kind == MatrixCellKind.cancel;
  bool get isConfirm => kind == MatrixCellKind.confirm;
  bool get isSos => kind == MatrixCellKind.sos;
}
