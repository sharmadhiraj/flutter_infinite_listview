import 'package:flutter/material.dart';
import 'package:flutter_infinite_listview/models/post.dart';
import 'package:flutter_infinite_listview/models/post_page.dart';
import 'package:flutter_infinite_listview/services/post_service.dart';
import 'package:flutter_infinite_listview/widgets/post_card.dart';
import 'package:flutter_infinite_listview/widgets/retry_button.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  static const double _loadMoreDistance = 400;
  static const double _maxContentWidth = 640;

  final _postService = PostService();
  final _scrollController = ScrollController();
  final List<Post> _posts = [];
  bool _isLoading = false;
  bool _hasError = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreWhenNearEnd);
    _loadNextPage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Posts")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_posts.isEmpty) {
      if (_hasError) {
        return RetryButton(
          message: "Could not load posts",
          onRetry: _loadNextPage,
        );
      }
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(onRefresh: _refresh, child: _buildList());
  }

  Widget _buildList() {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8 + MediaQuery.paddingOf(context).bottom,
      ),
      itemCount: _posts.length + 1,
      itemBuilder: (context, index) {
        if (index < _posts.length) return PostCard(post: _posts[index]);
        return _buildFooter();
      },
    );
  }

  Widget _buildFooter() {
    if (_hasError) return _buildRetryFooter();
    if (!_hasMore) return _buildEndFooter();
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildRetryFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Semantics(
          label: "Retry loading more posts",
          button: true,
          child: TextButton.icon(
            onPressed: _loadNextPage,
            icon: const Icon(Icons.refresh),
            label: const Text("Could not load more posts. Tap to retry"),
          ),
        ),
      ),
    );
  }

  Widget _buildEndFooter() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          "That's all, you have loaded everything",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  void _loadMoreWhenNearEnd() {
    if (_hasError) return;
    final ScrollPosition position = _scrollController.position;
    if (position.extentAfter < _loadMoreDistance) _loadNextPage();
  }

  Future<void> _refresh() async {
    _posts.clear();
    _hasMore = true;
    _hasError = false;
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final PostPage page = await _postService.fetchPage(skip: _posts.length);
      if (!mounted) return;
      setState(() {
        _posts.addAll(page.posts);
        _hasMore = _posts.length < page.total;
      });
    } catch (error) {
      debugPrint("Failed to load posts: $error");
      if (mounted) setState(() => _hasError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
