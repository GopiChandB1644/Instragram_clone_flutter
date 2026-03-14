import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/pinch_zoom_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselImages extends StatefulWidget {
  final List<String> images;

  const CarouselImages({super.key, required this.images});

  @override
  State<CarouselImages> createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  final PageController _pageController = PageController();
  bool _isZooming = false;
  int _currentPage = 0; // tracks which image is currently visible

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSingleImage = widget.images.length == 1;

    return AspectRatio(
      aspectRatio: 1, // square crop like Instagram
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // ── PAGE VIEW ───────────────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            // lock horizontal swipe while user is pinch-zooming
            physics: _isZooming
                ? const NeverScrollableScrollPhysics()
                : const PageScrollPhysics(),
            itemCount: widget.images.length,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) {
              return PinchZoomImage(
                imageUrl: widget.images[index],
                onZoomStart: () => setState(() => _isZooming = true),
                onZoomEnd: () => setState(() => _isZooming = false),
              );
            },
          ),

          // ── DOT INDICATOR ───────────────────────────────────────────────
          // only show dots for multi-image posts
          if (!isSingleImage)
            Positioned(
              bottom: 10,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: widget.images.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 6, // smaller than before (was 8)
                  dotWidth: 6,
                  expansionFactor: 2, // active dot expands to 12px wide
                  spacing: 4,
                  activeDotColor: Color(0xFF0095F6), // Instagram blue
                  dotColor: Colors.white54, // inactive dots semi-transparent
                ),
              ),
            ),

          // ── IMAGE COUNTER ────────────────────────────────────────────────
          // "1 / 3" badge in top-right — only for multi-image posts
          if (!isSingleImage)
            Positioned(
              top: 10,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  // semi-transparent dark pill background
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentPage + 1} / ${widget.images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
