import 'package:flutter/material.dart';

class FriendPostPage extends StatelessWidget {
  final List<String> friendPosts;

  FriendPostPage({required this.friendPosts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 게시물'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: friendPosts.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(friendPosts[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

