import 'package:flutter/material.dart';
import '../controllers/post_controller.dart';
import '../models/post_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PostController controller = PostController();

  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = controller.fetchPosts();
  }

  void addPost() async {
    bool success = await controller.createPost("عنوان جديد", "هذا بوست تجريبي");

    if (success) {
      setState(() {
        futurePosts = controller.fetchPosts();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("تمت الإضافة بنجاح")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MVC API Example')),

      floatingActionButton: FloatingActionButton(
        onPressed: addPost,
        child: Icon(Icons.add),
      ),

      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ"));
          }

          var posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(posts[index].title),
                  subtitle: Text(posts[index].body),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
