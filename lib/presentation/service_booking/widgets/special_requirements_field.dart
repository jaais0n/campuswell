import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SpecialRequirementsField extends StatefulWidget {
  final String requirements;
  final Function(String) onRequirementsChanged;

  const SpecialRequirementsField({
    super.key,
    required this.requirements,
    required this.onRequirementsChanged,
  });

  @override
  State<SpecialRequirementsField> createState() =>
      _SpecialRequirementsFieldState();
}

class _SpecialRequirementsFieldState extends State<SpecialRequirementsField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.requirements);
    _controller.addListener(() {
      widget.onRequirementsChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Special Requirements',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Please describe any accessibility needs or specific requests',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                width: _focusNode.hasFocus ? 2 : 1,
              ),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText:
                    'e.g., Wheelchair accessible entrance, Sign language interpreter, Large print materials...',
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(4.w),
                counterStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          SizedBox(height: 2.h),
          _buildQuickOptions(),
        ],
      ),
    );
  }

  Widget _buildQuickOptions() {
    final quickOptions = [
      'Wheelchair accessible',
      'Sign language interpreter',
      'Large print materials',
      'Audio assistance',
      'Extended time needed',
      'Companion required',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Options',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: quickOptions
              .map((option) => _buildQuickOptionChip(option))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildQuickOptionChip(String option) {
    final isSelected = _controller.text.contains(option);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            // Remove the option
            String newText = _controller.text.replaceAll(option, '').trim();
            newText = newText.replaceAll(
                RegExp(r',\s*,'), ','); // Clean up double commas
            newText = newText.replaceAll(
                RegExp(r'^,\s*'), ''); // Clean up leading comma
            newText = newText.replaceAll(
                RegExp(r',\s*$'), ''); // Clean up trailing comma
            _controller.text = newText;
          } else {
            // Add the option
            String currentText = _controller.text.trim();
            if (currentText.isEmpty) {
              _controller.text = option;
            } else {
              _controller.text = '$currentText, $option';
            }
          }
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(right: 1.w),
                child: CustomIconWidget(
                  iconName: 'check',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
              ),
            Text(
              option,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
