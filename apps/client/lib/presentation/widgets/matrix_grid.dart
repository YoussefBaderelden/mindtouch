import 'package:flutter/material.dart';

import '../../domain/models/matrix_cell.dart';
import 'matrix_cell_widget.dart';

class MatrixGrid extends StatelessWidget {
  const MatrixGrid({
    super.key,
    required this.cells,
    required this.selectedIndex,
    required this.onCellTap,
    this.crossAxisCount = 2,
  });

  final List<MatrixCell> cells;
  final int selectedIndex;
  final ValueChanged<int> onCellTap;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 14.0;
        final rows = (cells.length / crossAxisCount).ceil();
        final cellHeight =
            (constraints.maxHeight - spacing * (rows - 1)) / rows;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: cellHeight.clamp(120, 220),
          ),
          itemCount: cells.length,
          itemBuilder: (context, index) {
            return MatrixCellWidget(
              cell: cells[index],
              selected: index == selectedIndex,
              onTap: () => onCellTap(index),
            );
          },
        );
      },
    );
  }
}
