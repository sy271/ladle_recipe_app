import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/ladle_colors.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<LadleColors>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? colors.chipActive : colors.chipBg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? colors.chipActive : colors.chipBorder,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? colors.chipActiveFg : colors.chipFg,
          ),
        ),
      ),
    );
  }
}
