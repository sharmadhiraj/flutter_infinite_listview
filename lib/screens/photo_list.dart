import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_infinite_listview/models/photo.dart';
import 'package:http/http.dart' as http;

class PhotosListScreen extends StatefulWidget {
  PhotosListScreen({super.key});

  @override
  _PhotosListScreenState createState() => _PhotosListScreenState();
}

class _PhotosListScreenState extends State<PhotosListScreen> {
  bool _hasMore = false;
  int _pageNumber = 1;
  bool _error = false;
  bool _loading = false;
  List<Photo> _photos = [];
  final int _nextPageThreshold = 5;
  final int _defaultPhotosPerPageCount = 10;

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
          child: Text("Error while loading photos, tap to try agin"),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _photos.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _photos.length - _nextPageThreshold) {
          _fetchPhotos();
        }
        if (index == _photos.length) {
          if (_error) {
            return _buildError();
          } else {
            return _buildProgressIndicator();
          }
        }
        return _buildListItem(_photos[index]);
      },
    );
  }

  Widget _buildListItem(Photo photo) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.network(
            photo.thumbnailUrl,
            fit: BoxFit.fitWidth,
            width: double.infinity,
            height: 160,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              photo.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchPhotos() async {
    try {
      final response = await http.get(Uri.parse(
          "https://jsonplaceholder.typicode.com/photos?_page=$_pageNumber"));
      List<Photo> fetchedPhotos = Photo.parseList(json.decode(response.body));
      setState(
        () {
          _hasMore = fetchedPhotos.length == _defaultPhotosPerPageCount;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          _photos.addAll(fetchedPhotos);
        },
      );
    } catch (e) {
      setState(
        () {
          _loading = false;
          _error = true;
        },
      );
    }
  }
}
