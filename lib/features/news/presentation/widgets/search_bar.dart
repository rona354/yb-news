import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yb_news/core/config/theme.dart';

class NewsSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onClear;
  final String? currentQuery;

  const NewsSearchBar({
    super.key,
    required this.onSearch,
    required this.onClear,
    this.currentQuery,
  });

  @override
  State<NewsSearchBar> createState() => _NewsSearchBarState();
}

class _NewsSearchBarState extends State<NewsSearchBar> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentQuery);
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void didUpdateWidget(NewsSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentQuery != oldWidget.currentQuery) {
      _controller.text = widget.currentQuery ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      widget.onSearch(query);
    }
  }

  void _onClear() {
    _controller.clear();
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        style: GoogleFonts.poppins(fontSize: 16, color: AppTheme.titleActive),
        decoration: InputDecoration(
          hintText: 'Search news...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color(0xFFA0A0A0),
          ),
          prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
          suffixIcon: _hasText
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                  onPressed: _onClear,
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6), // Figma: 6px
            borderSide: const BorderSide(color: AppTheme.inputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6), // Figma: 6px
            borderSide: const BorderSide(color: AppTheme.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6), // Figma: 6px
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
              width: 2,
            ),
          ),
        ),
        onSubmitted: (_) => _onSubmit(),
      ),
    );
  }
}
