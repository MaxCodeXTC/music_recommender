import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
        centerTitle: true,
      ),
      body: Center(child: Text('Search Screen')),
    );
  }
}