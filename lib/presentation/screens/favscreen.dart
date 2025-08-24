import 'package:flutter/material.dart';

class Favscreen extends StatefulWidget {
  const Favscreen({super.key});

  @override
  State<Favscreen> createState() => _FavscreenState();
}

class _FavscreenState extends State<Favscreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("fav screen"),
      ) 
    );
  }
}