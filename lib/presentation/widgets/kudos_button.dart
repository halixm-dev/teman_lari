import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class KudosButton extends StatefulWidget {
  final int initialCount;
  final ValueChanged<bool>? onKudosChanged;

  const KudosButton({super.key, this.initialCount = 0, this.onKudosChanged});

  @override
  State<KudosButton> createState() => KudosButtonState();
}

class KudosButtonState extends State<KudosButton>
    with TickerProviderStateMixin {
  late int _kudosCount;
  bool _isKudosed = false;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _floatController;
  late Animation<double> _floatOpacityAnimation;
  late Animation<double> _floatSlideAnimation;

  @override
  void initState() {
    super.initState();
    _kudosCount = widget.initialCount;

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Spring curve for bouncy scale: 1 -> 0.85 -> 1.15 -> 1.0
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.85,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.85,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_scaleController);

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _floatOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_floatController);

    _floatSlideAnimation = Tween<double>(begin: 0.0, end: -24.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void externalKudos() {
    if (!_isKudosed) {
      _onTap();
    }
  }

  void _onTap() {
    HapticFeedback.lightImpact();
    setState(() {
      _isKudosed = !_isKudosed;
      if (_isKudosed) {
        _kudosCount++;
        _scaleController.forward(from: 0.0);
        _floatController.forward(from: 0.0);
      } else {
        _kudosCount = (_kudosCount - 1).clamp(0, 9999);
        _scaleController.reverse(from: 1.0);
      }
    });

    if (widget.onKudosChanged != null) {
      widget.onKudosChanged!(_isKudosed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white54 : Colors.black45;
    final activeColor = AppColors.brandOrange;

    return Semantics(
      button: true,
      label: _isKudosed ? 'Remove kudos' : 'Give kudos',
      value: '$_kudosCount kudos',
      child: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Floating +1
            Positioned(
              top: -12,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatSlideAnimation.value),
                    child: Opacity(
                      opacity: _floatOpacityAnimation.value,
                      child: const Text(
                        '+1',
                        style: TextStyle(
                          color: AppColors.brandOrange,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          fontFamily: 'JetBrains Mono',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // The Button Row
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _isKudosed
                          ? AppColors.brandOrange.withValues(alpha: 0.08)
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.04)
                                : Colors.black.withValues(alpha: 0.02)),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isKudosed
                            ? AppColors.brandOrange.withValues(alpha: 0.2)
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.black.withValues(alpha: 0.06)),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isKudosed
                              ? Icons.thumb_up_rounded
                              : Icons.thumb_up_outlined,
                          color: _isKudosed ? activeColor : defaultColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$_kudosCount',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _isKudosed ? activeColor : defaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
