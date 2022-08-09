import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/post_api_services.dart';

class SinglePostScreen extends StatelessWidget {
  const SinglePostScreen({Key? key, required this.postId}) : super(key: key);
  final int postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chopper Blog"),
        ),
        body: FutureBuilder<Response>(
          future: Provider.of<PostApiService>(context).getPost(postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final Map post = json.decode(snapshot.data!.bodyString);
              return _buildPost(post);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Padding _buildPost(Map post) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Text(
            post['title'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(post['body'])
        ]));
  }
}
