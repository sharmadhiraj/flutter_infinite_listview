import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_infinite_listview/models/post.dart';
import 'package:http/http.dart' as http;

class PhotosListScreen extends StatefulWidget {
  const PhotosListScreen({super.key});

  @override
  State<PhotosListScreen> createState() => _PhotosListScreenState();
}

class _PhotosListScreenState extends State<PhotosListScreen> {
  bool _hasMore = false;
  int _pageNumber = 1;
  bool _error = false;
  bool _loading = false;
  List<Post> _photos = [];
  final int _nextPageThreshold = 5;
  final int _defaultPostsPerPageCount = 30;

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    _photos = [];
    _fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(title: Text("Photos App"));
  }

  Widget _buildBody() {
    if (_photos.isEmpty) {
      if (_loading) {
        return _buildProgressIndicator();
      } else if (_error) {
        return _buildError();
      }
    } else {
      return _buildListView();
    }
    return Container();
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: InkWell(
        onTap: () => setState(
          () {
            _loading = true;
            _error = false;
            _fetchPhotos();
          },
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text("Error while loading photos, tap to try again"),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _photos.length + 1,
      itemBuilder: (context, index) {
        if (index == _photos.length - _nextPageThreshold) {
          _fetchPhotos();
        }
        if (index == _photos.length) {
          if (!_hasMore) {
            return SizedBox.shrink();
          } else if (_error) {
            return _buildError();
          } else {
            return _buildProgressIndicator();
          }
        }
        return _buildListItem(_photos[index]);
      },
    );
  }

  Widget _buildListItem(Post photo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              photo.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(photo.body),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchPhotos() async {
    try {
      final response = await http.get(Uri.parse(
          "https://dummyjson.com/posts?skip=${(_pageNumber - 1) * _defaultPostsPerPageCount}"));
      final List<Post> fetchedPhotos =
          Post.parseList(json.decode(response.body)["posts"]);
      setState(
        () {
          _hasMore = fetchedPhotos.length == _defaultPostsPerPageCount;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          _photos.addAll(fetchedPhotos);
        },
      );
    } catch (e) {
      debugPrint("Error fetching photos: $e");
      setState(
        () {
          _loading = false;
          _error = true;
        },
      );
    }
  }
}
