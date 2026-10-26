import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Grey rounded search box with a clear button and a filter button.
/// It only reports text changes; the cubit decides what to do with them.
class SearchField extends StatefulWidget {
  final String hint;

  /// Current query from the state. The box follows it when it changes
  /// from outside (e.g. "Clear filters").
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;

  /// Shows a dot on the filter icon when filters are applied.
  final bool filtersActive;

  const SearchField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.value = '',
    this.onFilterTap,
    this.filtersActive = false,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) _controller.text = widget.value;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onChanged: (value) {
        setState(() {}); // show / hide the clear button
        widget.onChanged(value);
      },
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
        prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_controller.text.isNotEmpty)
              IconButton(
                tooltip: 'Clear search',
                icon: const Icon(Icons.close, size: 20),
                color: AppColors.textGrey,
                onPressed: () {
                  _controller.clear();
                  setState(() {});
                  widget.onChanged('');
                },
              ),
            IconButton(
              tooltip: 'Sort and filter',
              onPressed: widget.onFilterTap,
              icon: Badge(
                isLabelVisible: widget.filtersActive,
                smallSize: 8,
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.tune, color: AppColors.textGrey),
              ),
            ),
          ],
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
