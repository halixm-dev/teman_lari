import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RunControls extends StatefulWidget {
  final bool isRunning;
  final bool isLocked;
  final bool isAudioCoachOn;
  final bool isFinished;
  final VoidCallback onToggleRunning;
  final VoidCallback onToggleLock;
  final VoidCallback onToggleAudioCoach;

  const RunControls({
    super.key,
    required this.isRunning,
    required this.isLocked,
    required this.isAudioCoachOn,
    required this.isFinished,
    required this.onToggleRunning,
    required this.onToggleLock,
    required this.onToggleAudioCoach,
  });

  @override
  State<RunControls> createState() => _RunControlsState();
}

class _RunControlsState extends State<RunControls> {
  final _holdProgress = ValueNotifier<double>(0.0);
  Timer? _holdTimer;
  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

  @override
  void dispose() {
    _holdTimer?.cancel();
    _holdProgress.dispose();
    super.dispose();
  }

  void _onLongPressStart() {
    if (!widget.isRunning) return;
    _holdProgress.value = 0.0;
    _holdTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _holdProgress.value = (timer.tick * 16) / 500;
      if (_holdProgress.value >= 1.0) {
        timer.cancel();
        _holdTimer = null;
        widget.onToggleRunning();
      }
    });
  }

  void _onLongPressEnd() {
    _holdTimer?.cancel();
    _holdTimer = null;
    _holdProgress.value = 0.0;
  }

  void _onLongPressCancel() {
    _holdTimer?.cancel();
    _holdTimer = null;
    _holdProgress.value = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _IconButton(
            icon: widget.isLocked ? Icons.lock : Icons.lock_open,
            onPressed: widget.isFinished ? null : widget.onToggleLock,
            isActive: widget.isLocked,
            semanticLabel: widget.isLocked ? 'Unlock screen' : 'Lock screen',
            tooltip: widget.isLocked ? 'Unlock Screen' : 'Lock Screen',
          ),
          _IconButton(
            icon: widget.isAudioCoachOn ? Icons.volume_up : Icons.volume_off,
            onPressed: widget.isFinished ? null : widget.onToggleAudioCoach,
            isActive: widget.isAudioCoachOn,
            semanticLabel: widget.isAudioCoachOn
                ? 'Disable audio coach'
                : 'Enable audio coach',
            tooltip: widget.isAudioCoachOn ? 'Mute Coach' : 'Unmute Coach',
          ),
          // Play / Pause FAB
          if (!widget.isFinished)
            Tooltip(
              key: _tooltipKey,
              message: widget.isRunning ? 'Hold to Pause' : 'Tap to Start',
              triggerMode: TooltipTriggerMode.manual,
              child: Semantics(
                button: true,
                label: widget.isRunning ? 'Pause workout' : 'Start workout',
                child: GestureDetector(
                  onTap: widget.isRunning
                      ? () {
                          HapticFeedback.mediumImpact();
                          _tooltipKey.currentState?.ensureTooltipVisible();
                        }
                      : widget.onToggleRunning,
                  onLongPressStart: (_) => _onLongPressStart(),
                  onLongPressEnd: (_) => _onLongPressEnd(),
                  onLongPressCancel: _onLongPressCancel,
                  onLongPress: widget.isRunning ? null : null,
                  child: ValueListenableBuilder<double>(
                    valueListenable: _holdProgress,
                    builder: (context, progress, _) {
                      final primaryColor = theme.colorScheme.primary;
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (progress > 0)
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  color: theme.colorScheme.onPrimary.withValues(
                                    alpha: 0.6,
                                  ),
                                  strokeWidth: 4,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            Icon(
                              widget.isRunning ? Icons.pause : Icons.play_arrow,
                              color: theme.colorScheme.onPrimary,
                              size: 36,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isActive;
  final String semanticLabel;
  final String tooltip;

  const _IconButton({
    required this.icon,
    required this.onPressed,
    required this.isActive,
    required this.semanticLabel,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Material(
          color: isActive
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : theme.colorScheme.surfaceContainerHighest,
          shape: const CircleBorder(),
          child: Semantics(
            button: true,
            label: semanticLabel,
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: Icon(
                icon,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
