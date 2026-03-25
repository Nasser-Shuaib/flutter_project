import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class PostController {
  final String baseUrl = "https://fakestoreapi.com";

  // 🔹 جلب البيانات
  Future<List<Post>> fetchPosts() async {
    var response = await http.get(Uri.parse("$baseUrl/products"));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception("فشل في جلب البيانات");
    }
  }

  // 🔹 إضافة بيانات
  Future<bool> createPost(String title, String body) async {
    var response = await http.post(
      Uri.parse("$baseUrl/posts"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title, "body": body, "userId": 1}),
    );

    return response.statusCode == 201;
  }
}
