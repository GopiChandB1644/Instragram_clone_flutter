import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostShimmer extends StatelessWidget {
  const PostShimmer({super.key});

  // a plain grey box — used as placeholder for any text line
  static Widget _box({double height = 12, double? width}) => Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // screen width used to make image placeholder square (AspectRatio 1:1)
    final screenWidth = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER: avatar + username + location ─────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // circular avatar placeholder
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(width: 120), // username line
                    const SizedBox(height: 5),
                    _box(width: 80), // location line
                  ],
                ),
              ],
            ),
          ),

          // ── IMAGE: exact square matching AspectRatio(1) ──────────────────
          Container(
            width: screenWidth,
            height: screenWidth, // square = same as AspectRatio(1)
            color: Colors.white,
          ),

          // ── ACTION BUTTONS: three boxes side by side ─────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                _box(width: 26, height: 26), // like icon placeholder
                const SizedBox(width: 16),
                _box(width: 26, height: 26), // comment icon placeholder
                const SizedBox(width: 16),
                _box(width: 26, height: 26), // share icon placeholder
              ],
            ),
          ),

          // ── LIKE COUNT ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _box(width: 80),
          ),

          const SizedBox(height: 6),

          // ── CAPTION: two lines ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _box(width: screenWidth * 0.85), // full-width line
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _box(width: screenWidth * 0.55), // shorter second line
          ),

          const SizedBox(height: 6),

          // ── TIMESTAMP ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _box(width: 60, height: 10),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
