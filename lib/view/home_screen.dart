import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chopper/data/post_api_services.dart';
import 'package:provider/provider.dart';

import 'single_post_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chopper Home"),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final response = await Provider.of<PostApiService>(context)
                .postPost({'key': 'value'});

            print(response.body);
          }),
    );
  }
}

FutureBuilder<Response> _buildBody(BuildContext context) {
  return FutureBuilder<Response>(
    future: Provider.of<PostApiService>(context).getPosts(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        final List posts = json.decode(snapshot.data!.bodyString);
        return _buildPosts(context, posts);
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}

ListView _buildPosts(BuildContext context, List posts) {
  return ListView.builder(
      itemCount: posts.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          child: ListTile(
            title: Text(
              posts[index]['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(posts[index]['body']),
            onTap: () => _navigateToPost(context, posts[index]['id']),
          ),
        );
      });
}

void _navigateToPost(BuildContext context, int id) {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SinglePostScreen(postId: id)));
}
