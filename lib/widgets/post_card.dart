import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/carousel_images.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../providers/feed_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── POST HEADER ────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // avatar with thin grey border
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 0.5),
                ),
                child: CircleAvatar(
                  radius: 17,
                  backgroundImage: CachedNetworkImageProvider(post.userAvatar),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
              const SizedBox(width: 10),
              // username + location stacked vertically
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                    // location line — only show if post has a location
                    if (post.location != null)
                      Text(
                        post.location!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black87,
                        ),
                      ),
                  ],
                ),
              ),
              // three-dot menu
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () =>
                    _showSnackbar(context, 'Options not implemented'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),

        // ── POST IMAGE (carousel + double-tap like) ────────────────────────
        _DoubleTapLikeWrapper(
          onDoubleTap: () => provider.toggleLike(post),
          child: CarouselImages(images: post.images),
        ),

        // ── ACTION BUTTONS ─────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
          child: Row(
            children: [
              // like button — red when liked
              IconButton(
                icon: Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: post.isLiked ? Colors.red : Colors.black,
                  size: 26,
                ),
                onPressed: () => provider.toggleLike(post),
              ),
              // comment button
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline, size: 24),
                onPressed: () =>
                    _showSnackbar(context, 'Comments not implemented'),
              ),
              // share/send button
              IconButton(
                icon: const Icon(Icons.send_outlined, size: 24),
                onPressed: () =>
                    _showSnackbar(context, 'Share not implemented'),
              ),
              const Spacer(),
              // save/bookmark button — filled when saved
              IconButton(
                icon: Icon(
                  post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  size: 26,
                ),
                onPressed: () => provider.toggleSave(post),
              ),
            ],
          ),
        ),

        // ── LIKE COUNT ─────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            '${post.likeCount} likes',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
          ),
        ),

        const SizedBox(height: 4),

        // ── CAPTION ────────────────────────────────────────────────────────
        _ExpandableCaption(username: post.username, caption: post.caption),

        const SizedBox(height: 4),

        // ── VIEW COMMENTS ──────────────────────────────────────────────────
        // only show if there are comments to view
        if (post.commentCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: GestureDetector(
              onTap: () => _showSnackbar(context, 'Comments not implemented'),
              child: Text(
                'View all ${post.commentCount} comments',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),

        const SizedBox(height: 4),

        // ── TIMESTAMP ──────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            post.timeAgo,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}

// ── DOUBLE-TAP LIKE ANIMATION WIDGET ────────────────────────────────────────
// Separate widget so it manages its own animation state cleanly
class _DoubleTapLikeWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onDoubleTap;

  const _DoubleTapLikeWrapper({required this.child, required this.onDoubleTap});

  @override
  State<_DoubleTapLikeWrapper> createState() => _DoubleTapLikeWrapperState();
}

class _DoubleTapLikeWrapperState extends State<_DoubleTapLikeWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  // scale: 0 → 1.3 → 1.0 (pop then settle)
  late final Animation<double> _scale = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 40),
    TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 20),
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 40),
  ]).animate(_controller);

  bool _showHeart = false;

  void _handleDoubleTap() {
    widget.onDoubleTap(); // toggle like in provider
    setState(() => _showHeart = true);
    _controller.forward(from: 0).then((_) {
      if (mounted) setState(() => _showHeart = false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.child, // the carousel image
          // animated heart — only visible during animation
          if (_showHeart)
            ScaleTransition(
              scale: _scale,
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 90, // large heart like Instagram
              ),
            ),
        ],
      ),
    );
  }
}

// ── EXPANDABLE CAPTION WITH HASHTAG COLORING ────────────────────────────────
class _ExpandableCaption extends StatefulWidget {
  final String username;
  final String caption;

  const _ExpandableCaption({required this.username, required this.caption});

  @override
  State<_ExpandableCaption> createState() => _ExpandableCaptionState();
}

class _ExpandableCaptionState extends State<_ExpandableCaption> {
  bool _expanded = false;

  // splits caption into words and colors hashtags/mentions Instagram blue
  List<TextSpan> _buildCaptionSpans(String caption) {
    final words = caption.split(' ');
    return words.map((word) {
      // hashtags (#) and mentions (@) get Instagram blue color
      final isTagged = word.startsWith('#') || word.startsWith('@');
      return TextSpan(
        text: '$word ',
        style: TextStyle(
          color: isTagged ? const Color(0xFF0095F6) : Colors.black,
          fontSize: 13.5,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // if caption is short (under 80 chars), never show "more" button
    final isLong = widget.caption.length > 80;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: RichText(
        // when collapsed: show 2 lines max; when expanded: show all
        maxLines: _expanded ? null : 2,
        overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 13.5),
          children: [
            // bold username at the start
            TextSpan(
              text: '${widget.username}  ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            // caption words with hashtag coloring
            ..._buildCaptionSpans(widget.caption),
            // "more" link — only shown when caption is long AND collapsed
            if (isLong && !_expanded)
              WidgetSpan(
                child: GestureDetector(
                  onTap: () => setState(() => _expanded = true),
                  child: const Text(
                    'more',
                    style: TextStyle(color: Colors.grey, fontSize: 13.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
