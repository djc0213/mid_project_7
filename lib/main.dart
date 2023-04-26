import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

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
  const FeedPage({super.key});

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

  const FriendPost({super.key, required this.friendNumber, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
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
  const FriendListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friend List')),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
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

  const MyFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Files'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
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
            child: Image.network('https://picsum.photos/200/200?random=${index + 10}'),
          );
        },
      ),
    );
  }
}