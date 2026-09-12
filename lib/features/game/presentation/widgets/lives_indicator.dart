import 'package:flutter/material.dart';

import '../../../../core/constants/game_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

class LivesIndicator extends StatelessWidget {
  const LivesIndicator({
    super.key,
    required this.lives,
    this.totalLives = GameConstants.startingLives,
    this.size = AppDimens.iconSm,
  });

  final int lives;
  final int totalLives;
  final double size;

  @override
  Widget build(BuildContext context) {
    final currentLives = lives.clamp(0, totalLives);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalLives,
        (index) {
          final isFull = index < currentLives;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.p4 / 2),
            child: _AnimatedHeart(
              isFull: isFull,
              size: size,
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedHeart extends StatefulWidget {
  const _AnimatedHeart({
    required this.isFull,
    required this.size,
  });

  final bool isFull;
  final double size;

  @override
  State<_AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<_AnimatedHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 0.85)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 35,
      ),
    ]).animate(_controller);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.2), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.1), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.1, end: 1.0), weight: 35),
    ]).animate(_controller);

    _colorAnimation = ColorTween(
      begin: const Color(0xFFFF2D55),
      end: AppColors.livesEmpty,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(covariant _AnimatedHeart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When a life is lost (full -> empty), trigger the blink/flash animation
    if (oldWidget.isFull && !widget.isFull) {
      _controller.forward(from: 0.0);
    } else if (!oldWidget.isFull && widget.isFull) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.isAnimating) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Icon(
                Icons.favorite,
                color: _colorAnimation.value,
                size: widget.size,
              ),
            ),
          );
        }

        return Icon(
          Icons.favorite,
          color: widget.isFull ? AppColors.livesFull : AppColors.livesEmpty,
          size: widget.size,
        );
      },
    );
  }
}
