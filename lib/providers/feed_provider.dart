import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/services/post_repository.dart';

class FeedProvider extends ChangeNotifier {
  final PostRepository _repository = PostRepository();

  final List<Post> _posts = [];
  List<Post> get posts => _posts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _page = 0;
  bool _hasMore = true;

  Future<void> loadPosts() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    final newPosts = await _repository.fetchPosts(_page);

    if (newPosts.isEmpty) {
      _hasMore = false;
    } else {
      _posts.addAll(newPosts);
      _page++;
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleLike(Post post) {
    post.isLiked = !post.isLiked;

    if (post.isLiked) {
      post.likeCount++;
    } else {
      post.likeCount--;
    }

    notifyListeners();
  }

  void toggleSave(Post post) {
    post.isSaved = !post.isSaved;

    notifyListeners();
  }
}
