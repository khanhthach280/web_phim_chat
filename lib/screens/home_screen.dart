import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/movie_card.dart';
import 'chat_screen.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService _movieService = MovieService();
  List<Movie> _movies = [];
  bool _isLoading = true;
  String _error = '';
  bool _isUsingMockData = false;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    print('===== load movie');
    try {
      setState(() {
        _isLoading = true;
        _error = '';
        _isUsingMockData = false;
      });
      
      final movies = await _movieService.getMovies();
      setState(() {
        _movies = movies;
        _isLoading = false;
        // Kiểm tra nếu đang sử dụng mock data
        _isUsingMockData = movies.length > 0 && movies[0].id <= 5;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isUsingMockData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'Movie Collection',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadMovies,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh movies',
          ),
        ],
      ),
      body: Column(
        children: [
          // Mock data notification
          if (_isUsingMockData)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.orange.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    color: Colors.orange[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Đang hiển thị dữ liệu mẫu. Server chưa sẵn sàng.',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().slideY(
              begin: -1,
              end: 0,
              duration: 300.ms,
            ),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ChatScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error.isNotEmpty) {
      return _buildErrorState();
    }

    if (_movies.isEmpty) {
      return _buildEmptyState();
    }

    return _buildMoviesList();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading movies...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load movies',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadMovies,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No movies found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'There are no movies available at the moment.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadMovies,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildMoviesList() {
    return Column(
      children: [
        // Header with movie count
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Text(
            '${_movies.length} movies available',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ).animate().fadeIn(duration: 300.ms),
        
        // Movies list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: _movies.length,
            itemBuilder: (context, index) {
              final movie = _movies[index];
              return MovieCard(
                movie: movie,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movieId: movie.id),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
