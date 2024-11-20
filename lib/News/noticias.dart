import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

// Fetch news data
Future<List<News>> fetchNews() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/everything?q=medicina&language=pt&sortBy=popularity&apiKey=${dotenv.env['NEWS_KEY']}'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final List<dynamic> articles = jsonResponse['articles'];
    return articles.map((article) => News.fromJson(article)).toList();
  } else {
    throw Exception('Erro ao carregar notícias');
  }
}

// News model
class News {
  final String title;
  final String description;
  final String image;

  News({required this.title, required this.description, required this.image});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      image: json['urlToImage'] ?? '',
    );
  }
}

// News card widget
Widget newsCard(News news, Size size) {
  return Card(
    margin: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        news.image.isNotEmpty
            ? Image.network(
          news.image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: size.height / 4,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image, size: 80),
        )
            : const Icon(Icons.image_not_supported, size: 80),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            news.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            news.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

// Main widget
class Noticias extends StatelessWidget {
  const Noticias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Notícias')),
      body: FutureBuilder<List<News>>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Sem notícias.'));
          }

          final List<News> newsList = snapshot.data!;
          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              return newsCard(newsList[index], size);
            },
          );
        },
      ),
    );
  }
}

// class Noticias extends StatelessWidget {
//   const Noticias({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],  // Altere a cor de fundo para gray[100]
//       body: Center(
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: 400),
//           child: ListView.builder(
//             itemCount: _articles.length,
//             itemBuilder: (BuildContext context, int index) {
//               final item = _articles[index];
//               return Container(
//                 height: 136,
//                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
//                 decoration: BoxDecoration(
//                     border: Border.all(color: const Color(0xFFE0E0E0)),
//                     borderRadius: BorderRadius.circular(8.0)),
//                 padding: const EdgeInsets.all(8),
//                 child: Row(
//                   children: [
//                     Expanded(
//                         child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item.title,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 8),
//                         Text("${item.author} · ${item.postedOn}",
//                             style: Theme.of(context).textTheme.bodySmall),
//                         const SizedBox(height: 8),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(Icons.bookmark_border_rounded, size: 16),
//                             const SizedBox(width: 8),
//                             const Icon(Icons.share, size: 16),
//                             const SizedBox(width: 8),
//                             const Icon(Icons.more_vert, size: 16)
//                           ].map((e) {
//                             return InkWell(
//                               onTap: () {},
//                               child: Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: e,
//                               ),
//                             );
//                           }).toList(),
//                         )
//                       ],
//                     )),
//                     Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                             color: Colors.grey,
//                             borderRadius: BorderRadius.circular(8.0),
//                             image: DecorationImage(
//                               fit: BoxFit.cover,
//                               image: NetworkImage(item.imageUrl),
//                             ))),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Article {
//   final String title;
//   final String imageUrl;
//   final String author;
//   final String postedOn;
//
//   Article(
//       {required this.title,
//       required this.imageUrl,
//       required this.author,
//       required this.postedOn});
// }
//
// final List<Article> _articles = [
//   Article(
//     title: "Instagram quietly limits ‘daily time limit’ option",
//     author: "MacRumors",
//     imageUrl: "https://picsum.photos/id/1000/960/540",
//     postedOn: "Yesterday",
//   ),
//   Article(
//       title: "Google Search dark theme goes fully black for some on the web",
//       imageUrl: "https://picsum.photos/id/1010/960/540",
//       author: "9to5Google",
//       postedOn: "4 hours ago"),
//   Article(
//     title: "Check your iPhone now: warning signs someone is spying on you",
//     author: "New York Times",
//     imageUrl: "https://picsum.photos/id/1001/960/540",
//     postedOn: "2 days ago",
//   ),
//   Article(
//     title:
//         "Amazon’s incredibly popular Lost Ark MMO is ‘at capacity’ in central Europe",
//     author: "MacRumors",
//     imageUrl: "https://picsum.photos/id/1002/960/540",
//     postedOn: "22 hours ago",
//   ),
//   Article(
//     title:
//         "Panasonic's 25-megapixel GH6 is the highest resolution Micro Four Thirds camera yet",
//     author: "Polygon",
//     imageUrl: "https://picsum.photos/id/1020/960/540",
//     postedOn: "2 hours ago",
//   ),
//   Article(
//     title: "Samsung Galaxy S22 Ultra charges strangely slowly",
//     author: "TechRadar",
//     imageUrl: "https://picsum.photos/id/1021/960/540",
//     postedOn: "10 days ago",
//   ),
//   Article(
//     title: "Snapchat unveils real-time location sharing",
//     author: "Fox Business",
//     imageUrl: "https://picsum.photos/id/1060/960/540",
//     postedOn: "10 hours ago",
//   ),
// ];
