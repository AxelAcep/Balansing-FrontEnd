import 'package:flutter/material.dart';

class BookmarkHomeScreen extends StatefulWidget {
  const BookmarkHomeScreen({super.key});

  @override
  State<BookmarkHomeScreen> createState() => _BookmarkHomeScreen();
}

class _BookmarkHomeScreen extends State<BookmarkHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark'),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
      body: Center(
        child: Text("Ini Bookmark"),
      ),
    );
  }
}
