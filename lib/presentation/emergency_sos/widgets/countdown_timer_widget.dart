import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';


class CountdownTimerWidget extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback? onTimerComplete;
  final VoidCallback? onCancel;

  const CountdownTimerWidget({
    super.key,
    this.initialSeconds = 30,
    this.onTimerComplete,
    this.onCancel,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget>
    with TickerProviderStateMixin {
  late Timer _timer;
  late int _remainingSeconds;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _startTimer();
    _pulseController.repeat(reverse: true);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0 && _isActive) {
        setState(() {
          _remainingSeconds--;
        });

        // Haptic feedback for last 5 seconds
        if (_remainingSeconds <= 5) {
          HapticFeedback.heavyImpact();
        }
      } else if (_remainingSeconds == 0 && _isActive) {
        _timer.cancel();
        _pulseController.stop();
        widget.onTimerComplete?.call();
      }
    });
  }

  void _cancelTimer() {
    setState(() {
      _isActive = false;
    });
    _timer.cancel();
    _pulseController.stop();
    HapticFeedback.heavyImpact();
    widget.onCancel?.call();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Emergency Status Text
        Text(
          _isActive ? 'Emergency Call in Progress' : 'Emergency Cancelled',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: _isActive ? colorScheme.error : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 8.h),

        // Countdown Timer Circle
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isActive ? _pulseAnimation.value : 1.0,
              child: Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isActive
                      ? colorScheme.error.withValues(alpha: 0.1)
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                  border: Border.all(
                    color: _isActive
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant,
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Text(
                    _remainingSeconds.toString(),
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: _isActive
                          ? colorScheme.error
                          : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.sp,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 4.h),

        // Timer Description
        Text(
          _isActive
              ? 'Calling campus security automatically'
              : 'Emergency call cancelled',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 6.h),

        // Cancel Button
        if (_isActive)
          SizedBox(
            width: 80.w,
            height: 7.h,
            child: ElevatedButton(
              onPressed: _cancelTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Cancel Emergency',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onError,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
