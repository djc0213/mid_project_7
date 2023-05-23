import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Post {
  String author;
  String content;

  Post({required this.author, required this.content});
}

class ImagePost extends Post {
  late String imageUrl; // Updated to non-final

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

  Future<void> saveInstance() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(toJson());
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

  Future<void> editInstance(String author, String content, String imageUrl) async {
    this.author = author;
    this.content = content;
    setImageUrl(imageUrl); // Set the new imageUrl
    await saveInstance();
  }

  void setImageUrl(String url) {
    imageUrl = url;
  }
}

class VideoPost extends Post {
  late String videoUrl; // Updated to non-final

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

  Future<void> saveInstance() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(toJson());
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

  Future<void> editInstance(String author, String content, String videoUrl) async {
    this.author = author;
    this.content = content;
    setVideoUrl(videoUrl); // Set the new videoUrl
    await saveInstance();
  }

  void setVideoUrl(String url) {
    videoUrl = url;
  }
}
class ImagePostEditPage extends StatefulWidget {
  const ImagePostEditPage({Key? key}) : super(key: key);

  @override
  _ImagePostEditPageState createState() => _ImagePostEditPageState();
}

class _ImagePostEditPageState extends State<ImagePostEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _authorController;
  late TextEditingController _contentController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _authorController = TextEditingController();
    _contentController = TextEditingController();
    _imageUrlController = TextEditingController();
    _loadImagePost();
  }

  Future<void> _loadImagePost() async {
    ImagePost? imagePost = await ImagePost.readInstance();
    if (imagePost != null) {
      setState(() {
        _authorController.text = imagePost.author;
        _contentController.text = imagePost.content;
        _imageUrlController.text = imagePost.imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Image Post')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the content';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the image URL';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ImagePost imagePost = ImagePost(
                      author: _authorController.text,
                      content: _contentController.text,
                      imageUrl: _imageUrlController.text,
                    );
                    imagePost.editInstance(
                      _authorController.text,
                      _contentController.text,
                      _imageUrlController.text,
                    ).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Successfully saved!')),
                      );
                    });
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPostEditPage extends StatefulWidget {
  const VideoPostEditPage({Key? key}) : super(key: key);

  @override
  _VideoPostEditPageState createState() => _VideoPostEditPageState();
}

class _VideoPostEditPageState extends State<VideoPostEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _authorController;
  late TextEditingController _contentController;
  late TextEditingController _videoUrlController;

  @override
  void initState() {
    super.initState();
    _authorController = TextEditingController();
    _contentController = TextEditingController();
    _videoUrlController = TextEditingController();
    _loadVideoPost();
  }

  Future<void> _loadVideoPost() async {
    VideoPost? videoPost = await VideoPost.readInstance();
    if (videoPost != null) {
      setState(() {
        _authorController.text = videoPost.author;
        _contentController.text = videoPost.content;
        _videoUrlController.text = videoPost.videoUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Video Post')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the content';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _videoUrlController,
                decoration: const InputDecoration(labelText: 'Video URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the video URL';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    VideoPost videoPost = VideoPost(
                      author: _authorController.text,
                      content: _contentController.text,
                      videoUrl: _videoUrlController.text,
                    );
                    videoPost.editInstance(
                      _authorController.text,
                      _contentController.text,
                      _videoUrlController.text,
                    ).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Successfully saved!')),
                      );
                    });
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
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
                builder:(context) => FriendChatPage(friendNumber: index + 1),
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