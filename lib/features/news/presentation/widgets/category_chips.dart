import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yb_news/core/config/theme.dart';
import 'package:yb_news/core/constants/api_constants.dart';

class CategoryChips extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ApiConstants.displayCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = ApiConstants.displayCategories[index];
          final isSelected = category == selectedCategory;

          return FilterChip(
            label: Text(ApiConstants.categoryLabels[category] ?? category),
            selected: isSelected,
            onSelected: (_) => onCategorySelected(category),
            backgroundColor: AppTheme.secondaryButtonBg, // Figma: #EEF1F4
            selectedColor: AppTheme.primaryColor.withAlpha(51),
            checkmarkColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6), // Figma: 6px
              side: BorderSide(
                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
              ),
            ),
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          );
        },
      ),
    );
  }
}
