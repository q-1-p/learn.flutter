import 'package:flutter/material.dart';
import 'package:learn_flutter/models/article.dart';

class ArticleContainer extends StatelessWidget {
  const ArticleContainer({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Color(0xFF55C500),
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
      ),
    );
  }
}
