import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final MovieService _movieService = MovieService();
  Movie? _movie;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });
      
      final movie = await _movieService.getMovieById(widget.movieId);
      setState(() {
        _movie = movie;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error.isNotEmpty) {
      return _buildErrorState();
    }

    if (_movie == null) {
      return _buildEmptyState();
    }

    return _buildMovieDetails();
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
            'Loading movie details...',
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
              'Failed to load movie details',
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
              onPressed: _loadMovieDetails,
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
              'Movie not found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The movie you are looking for could not be found.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
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

  Widget _buildMovieDetails() {
    return CustomScrollView(
      slivers: [
        // App Bar với poster
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Poster background
                Image.network(
                  _movie!.posterLink,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Icon(
                        Icons.movie,
                        size: 100,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                // Movie info overlay
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _movie!.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _movie!.year,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        
        // Movie content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating và thông tin cơ bản
                _buildBasicInfo(),
                const SizedBox(height: 24),
                
                // Overview
                if (_movie!.overview.isNotEmpty) ...[
                  _buildSectionTitle('Overview'),
                  const SizedBox(height: 8),
                  _buildOverview(),
                  const SizedBox(height: 24),
                ],
                
                // Genres
                if (_movie!.genres.isNotEmpty) ...[
                  _buildSectionTitle('Genres'),
                  const SizedBox(height: 8),
                  _buildGenres(),
                  const SizedBox(height: 24),
                ],
                
                // Directors
                if (_movie!.directors.isNotEmpty) ...[
                  _buildSectionTitle('Directors'),
                  const SizedBox(height: 8),
                  _buildDirectors(),
                  const SizedBox(height: 24),
                ],
                
                // Actors
                if (_movie!.actors.isNotEmpty) ...[
                  _buildSectionTitle('Cast'),
                  const SizedBox(height: 8),
                  _buildActors(),
                  const SizedBox(height: 24),
                ],
                
                // Additional info
                _buildSectionTitle('Additional Information'),
                const SizedBox(height: 8),
                _buildAdditionalInfo(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfo() {
    return Row(
      children: [
        // IMDB Rating
        Expanded(
          child: _buildInfoCard(
            icon: Icons.star,
            title: 'IMDB Rating',
            value: _movie!.imdbRating,
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        // Meta Score
        Expanded(
          child: _buildInfoCard(
            icon: Icons.analytics,
            title: 'Meta Score',
            value: _movie!.metaScore,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        // Runtime
        Expanded(
          child: _buildInfoCard(
            icon: Icons.access_time,
            title: 'Runtime',
            value: _movie!.runtime,
            color: Colors.green,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms).slideY(
      begin: 0.2,
      end: 0,
      duration: 300.ms,
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildOverview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Text(
        _movie!.overview,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          height: 1.5,
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(
      begin: 0.2,
      end: 0,
      duration: 300.ms,
    );
  }

  Widget _buildGenres() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _movie!.genres.map((genre) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            genre,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildDirectors() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _movie!.directors.map((director) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.movie_creation,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  director,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildActors() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _movie!.actors.map((actor) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  actor,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildAdditionalInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow('Certificate', _movie!.certificate),
          if (_movie!.gross.isNotEmpty) _buildInfoRow('Gross', _movie!.gross),
          if (_movie!.votes.isNotEmpty) _buildInfoRow('Votes', _movie!.votes),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
