import 'package:instagram_clone/models/post_model.dart';

class PostRepository {
  static const _images = [
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=600',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=600',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=600',
    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=600',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=600',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=600',
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=600',
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

  static const _captions = [
    'Beautiful day out 🌸 #nature #vibes',
    'Golden hour hits different ✨ #photography',
    'Weekend mood 🎉 #fun #friends',
    'Exploring new places 🗺️ #travel #adventure',
    'Good food, good life 🍜 #foodie',
    'Chasing sunsets 🌅 #sunset #sky',
    'City lights never get old 🌃 #urban',
  ];

  static const _locations = [
    'Hyderabad, India',
    'Mumbai, India',
    null,
    'Bangalore, India',
    null,
    'Goa, India',
    'Delhi, India',
  ];

  static const _times = [
    '2 HOURS AGO',
    '5 HOURS AGO',
    '1 DAY AGO',
    '3 HOURS AGO',
    '6 HOURS AGO',
    '12 HOURS AGO',
    '2 DAYS AGO',
  ];

  Future<List<Post>> fetchPosts(int page) async {
    // simulate network latency — shows shimmer during this delay
    await Future.delayed(const Duration(milliseconds: 1500));

    return List.generate(10, (index) {
      final i = (page * 10 + index) % _usernames.length;
      final postNumber = page * 10 + index;

      return Post(
        id: 'post_$postNumber',
        username: _usernames[i],
        userAvatar: _images[i],
        // every 3rd post is a carousel (2 images), rest are single image
        images: postNumber % 3 == 0
            ? [_images[i], _images[(i + 1) % _images.length]]
            : [_images[i]],
        caption: _captions[i],
        location: _locations[i],
        commentCount: 10 + postNumber,
        timeAgo: _times[i],
        likeCount: 100 + postNumber * 7,
      );
    });
  }
}
