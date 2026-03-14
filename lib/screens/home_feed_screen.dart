import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/widgets/post_card.dart';
import 'package:instagram_clone/widgets/post_shimmer.dart';
import 'package:instagram_clone/widgets/stories_list.dart';
import 'package:provider/provider.dart';
import '../providers/feed_provider.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
      Provider.of<FeedProvider>(context, listen: false).loadPosts();
    });

    _scrollController.addListener(() {
      final provider = Provider.of<FeedProvider>(context, listen: false);
      // trigger load when 300px from bottom (approx 2 posts away)
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 300) {
        provider.loadPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = context.watch<FeedProvider>();

    return Scaffold(
      backgroundColor: Colors.white,

      // ── APP BAR ──────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // reliable 0.5px bottom border line — same grey Instagram uses
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(color: const Color(0xFFDBDBDB), height: 0.5),
        ),
        // "+" create icon on the left
        leading: IconButton(
          icon: const Icon(Icons.add_box_outlined, color: Colors.black, size: 28),
          onPressed: () {},
        ),
        // Pacifico is the closest Google Font to Instagram's Billabong script
        title: Text(
          'Instagram',
          style: GoogleFonts.pacifico(
            fontSize: 28,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        actions: [
          // notifications heart
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black, size: 26),
            onPressed: () {},
          ),
        ],
      ),

      // ── BODY ─────────────────────────────────────────────────────────────
      body: feedProvider.isLoading && feedProvider.posts.isEmpty
          // show shimmer skeletons while first page loads
          ? ListView.builder(
              itemCount: 5,
              itemBuilder: (_, __) => const PostShimmer(),
            )
          : ListView(
              controller: _scrollController,
              children: [
                const StoriesList(),
                const Divider(height: 1, thickness: 0.5, color: Color(0xFFDBDBDB)),
                ListView.builder(
                  shrinkWrap: true,
                  // outer ListView handles all scrolling
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: feedProvider.posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index < feedProvider.posts.length) {
                      return PostCard(post: feedProvider.posts[index]);
                    }
                    // bottom loader while next page fetches
                    if (feedProvider.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),

      // ── BOTTOM NAVIGATION BAR ────────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 1,
        items: [
          // home: filled when active
          BottomNavigationBarItem(
            icon: Icon(_currentNavIndex == 0 ? Icons.home : Icons.home_outlined),
            label: '',
          ),
          // reels (was index 3, now index 1)
          BottomNavigationBarItem(
            icon: Icon(_currentNavIndex == 1 ? Icons.movie : Icons.movie_outlined),
            label: '',
          ),
          // send/share in the middle (replaced add_box)
          const BottomNavigationBarItem(
            icon: Icon(Icons.send_outlined),
            label: '',
          ),
          // search (was index 1, now index 3)
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          // profile: filled when active
          BottomNavigationBarItem(
            icon: Icon(_currentNavIndex == 4 ? Icons.person : Icons.person_outline),
            label: '',
          ),
        ],
      ),
    );
  }
}
