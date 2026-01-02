import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/movie.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../services/news_service.dart';
import '../pages/detail_movie_page.dart';

class HomePage extends StatelessWidget {
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeContent(),
    );
  }
}

//
// ================= KONTEN HOME =================
//
class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  // WARNA
  static const Color navy = Color(0xFF0A1F44);
  static const Color navySoft = Color(0xFF1E3A8A);

  // BANNER
  final List<String> bannerAssets = [
    "assets/banner/promo1.jpg",
    "assets/banner/promo2.jpg",
    "assets/banner/promo3.jpg",
  ];

  late PageController bannerController;
  int bannerIndex = 0;

  // MOVIE
  List<Movie> allMovies = [];
  List<Movie> filteredMovies = [];
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    bannerController = PageController(viewportFraction: 0.88);
    _autoSlideBanner();
  }

  // ================= OPEN URL =================
  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _autoSlideBanner() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      bannerIndex = (bannerIndex + 1) % bannerAssets.length;
      bannerController.animateToPage(
        bannerIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      _autoSlideBanner();
    });
  }

  void _searchMovie(String text) {
    setState(() {
      filteredMovies = text.isEmpty
          ? allMovies
          : allMovies
              .where(
                  (m) => m.title.toLowerCase().contains(text.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: ApiService.getMovies(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        allMovies = snap.data!;
        filteredMovies =
            filteredMovies.isEmpty ? allMovies : filteredMovies;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Container(
                padding: const EdgeInsets.only(bottom: 28),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [navy, navySoft],
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        "Bioskop App",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 16),

                      // SEARCH
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: searchCtrl,
                          onChanged: _searchMovie,
                          decoration: InputDecoration(
                            hintText: "Cari judul film...",
                            prefixIcon:
                                const Icon(Icons.search, color: navy),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // BANNER
                      SizedBox(
                        height: 180,
                        child: PageView.builder(
                          controller: bannerController,
                          itemCount: bannerAssets.length,
                          itemBuilder: (_, i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              image: DecorationImage(
                                image: AssetImage(bannerAssets[i]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= SEDANG TAYANG =================
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Sedang Tayang",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: navy),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: filteredMovies.length,
                  itemBuilder: (_, i) {
                    final m = filteredMovies[i];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailMoviePage(movie: m),
                        ),
                      ),
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                m.poster,
                                height: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              m.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ================= SPOTLIGHT NEWS =================
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Spotlight",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: navy),
                ),
              ),

              const SizedBox(height: 12),

              FutureBuilder<List<Article>>(
                future: NewsService.getNews(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final news = snap.data!;
                  return SizedBox(
                    height: 220,
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.9),
                      itemCount: news.length,
                      itemBuilder: (_, i) {
                        final a = news[i];
                        return GestureDetector(
                          onTap: () => _openUrl(a.url),
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              image: DecorationImage(
                                image: NetworkImage(a.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              alignment: Alignment.bottomLeft,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black87
                                  ],
                                ),
                              ),
                              child: Text(
                                a.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
