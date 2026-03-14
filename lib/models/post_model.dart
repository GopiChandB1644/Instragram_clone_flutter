class Post {
  final String id;
  final String username;
  final String userAvatar;
  final List<String> images;
  final String caption;
  final String? location; // optional — not every post has a location
  final int commentCount; // shown as "View all X comments"
  final String timeAgo; // e.g. "2 HOURS AGO"
  int likeCount;
  bool isLiked;
  bool isSaved;

  Post({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.images,
    required this.caption,
    this.location,
    this.commentCount = 0,
    this.timeAgo = '',
    required this.likeCount,
    this.isLiked = false,
    this.isSaved = false,
  });
}
