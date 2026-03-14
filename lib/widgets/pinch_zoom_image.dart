import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PinchZoomImage extends StatefulWidget {
  final String imageUrl;
  final VoidCallback onZoomStart;
  final VoidCallback onZoomEnd;

  const PinchZoomImage({
    super.key,
    required this.imageUrl,
    required this.onZoomStart,
    required this.onZoomEnd,
  });

  @override
  State<PinchZoomImage> createState() => _PinchZoomImageState();
}

class _PinchZoomImageState extends State<PinchZoomImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  // tracks current scale and position during the gesture
  double _scale = 1.0;
  Offset _offset = Offset.zero;

  // stores the scale/offset at the moment a new gesture starts
  double _baseScale = 1.0;
  Offset _baseOffset = Offset.zero;

  // the overlay entry that renders the zoomed image above everything
  OverlayEntry? _overlayEntry;

  bool _isZooming = false;

  // builds the full-screen dark overlay with the zoomed image on top
  OverlayEntry _buildOverlay() {
    // capture the position and size of this widget on screen
    final renderBox = context.findRenderObject() as RenderBox;
    final widgetOffset = renderBox.localToGlobal(Offset.zero);
    final widgetSize = renderBox.size;

    return OverlayEntry(
      // StatefulBuilder lets us call setState inside the overlay
      // without needing a separate widget class
      builder: (_) => StatefulBuilder(
        builder: (context, setOverlayState) {
          return Stack(
            children: [
              // semi-transparent black background — darkens as scale increases
              Positioned.fill(
                child: GestureDetector(
                  // absorbs taps so nothing behind the overlay is triggered
                  onTap: () {},
                  child: Container(
                    // opacity goes from 0 (scale=1) to 0.9 (scale=4)
                    color: Colors.black.withOpacity(
                      ((_scale - 1) / 3).clamp(0.0, 0.9),
                    ),
                  ),
                ),
              ),

              // the zoomed image — positioned exactly where the original widget is
              Positioned(
                left: widgetOffset.dx + _offset.dx,
                top: widgetOffset.dy + _offset.dy,
                width: widgetSize.width,
                height: widgetSize.height,
                child: Transform.scale(
                  scale: _scale,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.cover,
                    // no placeholder here — image is already loaded in the list
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    // only trigger zoom overlay when it's actually a pinch (scale != 1)
    // single finger pan should not trigger zoom
    _baseScale = _scale;
    _baseOffset = _offset;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final newScale = (_baseScale * details.scale).clamp(1.0, 4.0);

    // don't show overlay for tiny accidental pinches
    if (newScale <= 1.05 && !_isZooming) return;

    if (!_isZooming) {
      // first time scale crosses threshold — insert overlay
      _isZooming = true;
      widget.onZoomStart();
      _overlayEntry = _buildOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    }

    _scale = newScale;
    // pan offset: how far the user has dragged while zooming
    _offset = _baseOffset + details.focalPointDelta;

    // tell the overlay to rebuild with new scale/offset values
    _overlayEntry?.markNeedsBuild();
  }

  void _onScaleEnd(ScaleEndDetails details) {
    if (!_isZooming) return;

    // animate scale back to 1 and offset back to zero
    final scaleAnimation = Tween<double>(
      begin: _scale,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    final offsetAnimation = Tween<Offset>(
      begin: _offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    // on each animation tick, update scale/offset and rebuild overlay
    void listener() {
      _scale = scaleAnimation.value;
      _offset = offsetAnimation.value;
      _overlayEntry?.markNeedsBuild();
    }

    _animController.addListener(listener);

    _animController.forward(from: 0).then((_) {
      // animation done — remove overlay and reset state
      _animController.removeListener(listener);
      _overlayEntry?.remove();
      _overlayEntry = null;
      _scale = 1.0;
      _offset = Offset.zero;
      _isZooming = false;
      widget.onZoomEnd();
    });
  }

  @override
  void dispose() {
    // safety: remove overlay if widget is disposed mid-zoom
    _overlayEntry?.remove();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        // grey box while image loads
        placeholder: (_, __) => Container(
          color: Colors.grey[300],
          // aspect ratio box so shimmer has correct height
          child: const AspectRatio(aspectRatio: 1),
        ),
        errorWidget: (_, __, ___) => Container(
          color: Colors.grey[300],
          child: const Center(child: Icon(Icons.broken_image, size: 40)),
        ),
      ),
    );
  }
}
