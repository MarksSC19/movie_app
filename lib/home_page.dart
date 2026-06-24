import 'package:flutter/material.dart';
import 'api_services.dart';
import 'item_movie_list_widget.dart';
import 'movie_models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiServices _apiServices = ApiServices();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<Movie>> _popularMovies;
  Future<List<Movie>>? _searchResults;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _popularMovies = _apiServices.getPopularMovies();
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = null;
      });
    } else {
      setState(() {
        _isSearching = true;
        _searchResults = _apiServices.searchMovies(query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1016),
      appBar: AppBar(
        title: const Text('CineVerse', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F1016),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.movie_filter),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar películas...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF00D2FF)),
                fillColor: const Color(0xFF1E202B),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Lista de películas
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _isSearching ? _searchResults : _popularMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar datos', style: TextStyle(color: Colors.white)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No se encontraron películas', style: TextStyle(color: Colors.white)));
                }

                final List<Movie> movies = snapshot.data!;
                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return ItemMovieListWidget(
                      movie: movie,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => _DetailScreen(movie: movie),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailScreen extends StatelessWidget {
  final Movie movie;
  const _DetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1016),
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: const Color(0xFF0F1016),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(movie.posterUrl, height: 400, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Calificación: ${movie.voteAverage}/10', style: const TextStyle(color: Colors.amber, fontSize: 16)),
                  const SizedBox(height: 16),
                  Text(movie.overview, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
