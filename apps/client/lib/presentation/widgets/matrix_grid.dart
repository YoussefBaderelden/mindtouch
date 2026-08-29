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

  static const _spacing = 12.0;
  static const _minCellHeight = 72.0;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: _spacing,
        mainAxisSpacing: _spacing,
        mainAxisExtent: _minCellHeight,
      ),
      itemCount: cells.length,
      itemBuilder: (context, index) {
        return MatrixCellWidget(
          cell: cells[index],
          selected: index == selectedIndex,
          compact: true,
          onTap: () => onCellTap(index),
        );
      },
    );
  }
}
