import 'package:flutter/material.dart';
import 'story_item.dart';

class StoriesList extends StatelessWidget {
  const StoriesList({super.key});

  // diverse set of avatar images so stories look different
  static const _avatars = [
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=150',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150',
  ];

  static const _usernames = [
    'neelam._aditya',
    'Anil_Augustian',
    'Gopi_chand',
    'travel.pics',
    'foodie_hub',
    'nature_snap',
    'daily.life',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // matches Instagram stories tray height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        // +1 for "Your story" at index 0
        itemCount: _usernames.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // "Your story" is always the first item with a "+" badge
            return StoryItem(
              imageUrl: _avatars[0],
              username: 'Your story',
              isYourStory: true, // special flag to show "+" badge
            );
          }
          // all other stories use the list offset by 1
          return StoryItem(
            imageUrl: _avatars[(index - 1) % _avatars.length],
            username: _usernames[index - 1],
            isYourStory: false,
          );
        },
      ),
    );
  }
}
