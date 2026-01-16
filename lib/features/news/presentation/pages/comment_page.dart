import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yb_news/core/config/theme.dart';

class CommentPage extends StatefulWidget {
  final String articleTitle;

  const CommentPage({super.key, required this.articleTitle});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _commentController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isInputActive = false;

  final List<_Comment> _comments = [
    _Comment(
      name: 'Wilson Franci',
      avatar: 'WF',
      time: '6h ago',
      content:
          'Amet minim mollit non deserunt satisfies sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Lorem ipsum',
      isOnline: true,
    ),
    _Comment(
      name: 'Wilson Franci',
      avatar: 'WF',
      time: '6h ago',
      content:
          'Amet minim mollit non deserunt satisfies sit aliqua dolor do amet sint.',
      isOnline: false,
    ),
    _Comment(
      name: 'Wilson Franci',
      avatar: 'WF',
      time: '6h ago',
      content:
          'Amet minim mollit non deserunt satisfies sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Lorem ipsum',
      isOnline: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isInputActive = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.insert(
        0,
        _Comment(
          name: 'You',
          avatar: 'Y',
          time: 'Just now',
          content: _commentController.text.trim(),
          isOnline: true,
        ),
      );
      _commentController.clear();
      _focusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
            color: AppTheme.textSecondary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Comments',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.titleActive,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _comments.isEmpty
                ? Center(
                    child: Text(
                      'No comments yet.\nBe the first to comment!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    itemCount: _comments.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return _CommentItem(comment: comment);
                    },
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withAlpha(13),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isInputActive
                            ? AppTheme.primaryColor
                            : AppTheme.inputBorder,
                        width: _isInputActive ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextField(
                      controller: _commentController,
                      focusNode: _focusNode,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppTheme.titleActive,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your comment...',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _submitComment(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submitComment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Icon(
                      Icons.send,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Comment {
  final String name;
  final String avatar;
  final String time;
  final String content;
  final bool isOnline;

  _Comment({
    required this.name,
    required this.avatar,
    required this.time,
    required this.content,
    required this.isOnline,
  });
}

class _CommentItem extends StatelessWidget {
  final _Comment comment;

  const _CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.secondaryButtonBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  comment.avatar,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
            if (comment.isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppTheme.onlineGreen,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    comment.name,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.titleActive,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    comment.time,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                comment.content,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
