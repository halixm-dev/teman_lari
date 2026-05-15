import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class KudosButton extends StatefulWidget {
  final int initialCount;
  final bool isInitiallyKudosed;

  const KudosButton({
    super.key,
    this.initialCount = 0,
    this.isInitiallyKudosed = false,
  });

  @override
  State<KudosButton> createState() => _KudosButtonState();
}

class _KudosButtonState extends State<KudosButton>
    with SingleTickerProviderStateMixin {
  late int _count;
  late bool _isKudosed;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
    _isKudosed = widget.isInitiallyKudosed;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.15), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(
      parent: _animController,
      curve: const Cubic(0.34, 1.56, 0.64, 1),
    ));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animController.forward(from: 0);
    setState(() {
      if (_isKudosed) {
        _count--;
      } else {
        _count++;
      }
      _isKudosed = !_isKudosed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _isKudosed ? AppColors.brandOrangeTint : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: _isKudosed ? AppColors.brandOrange : AppColors.gray300,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isKudosed ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                size: 18,
                color:
                    _isKudosed ? AppColors.brandOrange : AppColors.gray500,
              ),
              if (_count > 0) ...[
                const SizedBox(width: 6),
                Text(
                  _formatCount(_count),
                  style: AppTypography.bodySm.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                        _isKudosed ? AppColors.brandOrange : AppColors.gray500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
