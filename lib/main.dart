import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Post {
  final String author;
  final String content;

  Post({required this.author, required this.content});
}

class ImagePost extends Post {
  final String imageUrl;

  ImagePost({required String author, required String content, required this.imageUrl})
      : super(author: author, content: content);

  static ImagePost fromJson(Map<String, dynamic> json) {
    return ImagePost(
      author: json['author'],
      content: json['content'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'content': content,
      'imageUrl': imageUrl,
    };
  }

  static Future<void> saveInstance(ImagePost imagePost) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(imagePost.toJson());
    prefs.setString('imagePost', jsonData);
  }

  static Future<ImagePost?> readInstance() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('imagePost')) {
      final jsonData = prefs.getString('imagePost');
      if (jsonData != null) {
        final json = jsonDecode(jsonData);
        return ImagePost.fromJson(json);
      }
    }
    return null;
  }
}

class VideoPost extends Post {
  final String videoUrl;

  VideoPost({required String author, required String content, required this.videoUrl})
      : super(author: author, content: content);

  static VideoPost fromJson(Map<String, dynamic> json) {
    return VideoPost(
      author: json['author'],
      content: json['content'],
      videoUrl: json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'content': content,
      'videoUrl': videoUrl,
    };
  }

  static Future<void> saveInstance(VideoPost videoPost) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(videoPost.toJson());
    prefs.setString('videoPost', jsonData);
  }

  static Future<VideoPost?> readInstance() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('videoPost')) {
      final jsonData = prefs.getString('videoPost');
      if (jsonData != null) {
        final json = jsonDecode(jsonData);
        return VideoPost.fromJson(json);
      }
    }
    return null;
  }
}

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          titleTextStyle: TextStyle(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pageOptions = [
    const FeedPage(),
    const FriendListPage(),
    const MyFilesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'My Files'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return FriendPost(
            friendNumber: index + 1,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FriendChatPage(friendNumber: index + 1),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FriendPost extends StatelessWidget {
  final int friendNumber;
  final VoidCallback onPressed;

  const FriendPost({Key? key, required this.friendNumber, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: const Icon(Icons.person),
            title: Text('Friend $friendNumber'),
            trailing: IconButton(
              icon: const Icon(Icons.message),
              onPressed: onPressed,
            ),
          ),
          Image.network('https://picsum.photos/200/200?random=$friendNumber'),
        ],
      ),
    );
  }
}

class FriendListPage extends StatelessWidget {
  const FriendListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friend List')),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: const Icon(Icons.person),
            title: Text('Friend ${index + 1}'),
            trailing: IconButton(
              icon: const Icon(Icons.message),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendChatPage(friendNumber: index + 1),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FriendChatPage extends StatefulWidget {
  final int friendNumber;

  const FriendChatPage({Key? key, required this.friendNumber}) : super(key: key);

  @override
  FriendChatPageState createState() => FriendChatPageState();
}

class FriendChatPageState extends State<FriendChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend ${widget.friendNumber}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Add the necessary logic for sending the message
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyFilesPage extends StatelessWidget {
  const MyFilesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Files'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add the necessary logic for adding files
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(4.0),
            child: Image.network('https://picsum.photos/200/200?random=${index + 10}'),
          );
        },
      ),
    );
  }
}