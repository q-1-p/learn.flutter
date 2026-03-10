import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // httpという変数を通して、httpパッケージにアクセス
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:learn_flutter/models/article.dart';
import 'package:learn_flutter/models/user.dart';
import 'package:learn_flutter/widgets/article_container.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Article> articles = []; // 検索結果を格納する変数

  Future<List<Article>> searchQiita(String keyword) async {
    // 1. http通信に必要なデータを準備をする
    final url = Uri.https('qiita.com', '/api/v2/items', {
      'query': 'title:$keyword',
      'per_page': '10',
    });
    final token = dotenv.env['QIITA_ACCESS_TOKEN'] ?? '';

    // 2. Qiita APIにリクエストを送る
    final res = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    // 3. 戻り値をArticleクラスの配列に変換
    // 4. 変換したArticleクラスの配列を返す(returnする)
    if (res.statusCode == 200) {
      // レスポンスをモデルクラスへ変換
      final List<dynamic> body = jsonDecode(res.body);
      return body.map((dynamic json) => Article.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qiita Search')),
      body: Column(
        children: [
          // 検索ボックス
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
            child: TextField(
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: '検索キーワードを入力してください',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (String value) async {
                final results = await searchQiita(value);
                setState(() => articles = results);
              },
            ),
          ),
          // 検索結果一覧
          ArticleContainer(
            article: Article(
              title: 'テスト',
              user: User(
                id: 'qii-taro',
                profileImageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/gs-expansion-test.appspot.com/o/unknown_person.png?alt=media',
              ),
              createdAt: DateTime.now(),
              tags: ['Flutter', 'dart'],
              url: 'https://example.com',
            ),
          ),
        ],
      ),
    );
  }
}
