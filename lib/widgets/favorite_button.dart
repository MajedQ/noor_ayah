import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../models/verse_model.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

/// زر المفضلة مع animation
class FavoriteButton extends StatefulWidget {
  final VerseModel verse;
  final double size;
  final bool showLabel;

  const FavoriteButton({
    super.key,
    required this.verse,
    this.size = 28.0,
    this.showLabel = false,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    final favoritesProvider = context.read<FavoritesProvider>();
    final isFavorite = favoritesProvider.isFavorite(widget.verse.id);

    // Haptic feedback
    AppHelpers.mediumHaptic();

    // Animation
    await _animationController.forward();
    await _animationController.reverse();

    // Toggle favorite
    await favoritesProvider.toggleFavorite(widget.verse);

    // Show message
    if (mounted) {
      AppHelpers.showSnackBar(
        context,
        isFavorite
            ? AppConstants.removedFromFavorites
            : AppConstants.addedToFavorites,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFavorite = favoritesProvider.isFavorite(widget.verse.id);

        return ScaleTransition(
          scale: _scaleAnimation,
          child: widget.showLabel
              ? TextButton.icon(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? AppColors.favoriteIcon : null,
                    size: widget.size,
                  ),
                  label: Text(
                    isFavorite
                        ? AppConstants.removeFromFavorites
                        : AppConstants.addToFavorites,
                  ),
                )
              : IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? AppColors.favoriteIcon : null,
                  ),
                  iconSize: widget.size,
                  tooltip: isFavorite
                      ? AppConstants.removeFromFavorites
                      : AppConstants.addToFavorites,
                ),
        );
      },
    );
  }
}
