import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoryItem extends StatelessWidget {
  final String imageUrl;
  final String username;
  final bool isYourStory; // true only for the first "Your story" item

  const StoryItem({
    super.key,
    required this.imageUrl,
    required this.username,
    this.isYourStory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              // gradient ring — only shown for other users' stories, not "Your story"
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Instagram's signature story gradient: yellow → pink → purple
                  gradient: isYourStory
                      ? null // no gradient ring for "Your story"
                      : const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xFFFCAF45), // yellow
                            Color(0xFFFC5245), // red-orange
                            Color(0xFFE1306C), // pink
                            Color(0xFF833AB4), // purple
                          ],
                        ),
                  // grey border for "Your story" (no gradient)
                  border: isYourStory
                      ? Border.all(color: Colors.grey.shade300, width: 1)
                      : null,
                ),
                // 3px white gap between gradient ring and avatar image
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: CachedNetworkImageProvider(imageUrl),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),

              // "+" badge — only shown on "Your story"
              if (isYourStory)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0095F6), // Instagram blue
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 14),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 4),

          // username label — truncated if too long
          SizedBox(
            width: 68,
            child: Text(
              username,
              style: const TextStyle(fontSize: 11, color: Colors.black),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // "neelam._adi..." if too long
            ),
          ),
        ],
      ),
    );
  }
}
