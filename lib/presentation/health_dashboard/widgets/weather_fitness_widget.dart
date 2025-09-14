import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WeatherFitnessWidget extends StatelessWidget {
  const WeatherFitnessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Text(
            'Today\'s Wellness',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 16.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            children: [
              _buildWeatherCard(context),
              SizedBox(width: 4.w),
              _buildFitnessCard(context),
              SizedBox(width: 4.w),
              _buildHydrationCard(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 40.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 6.w),
              Spacer(),
              Text(
                '24°C',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            'Perfect for',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          Text(
            'Outdoor Activities',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFitnessCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 40.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.directions_walk_outlined,
                color: Colors.white,
                size: 6.w,
              ),
              Spacer(),
              Text(
                '6,247',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            'Steps today',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          Text(
            'Goal: 8,000',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHydrationCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 40.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop_outlined, color: Colors.white, size: 6.w),
              Spacer(),
              Text(
                '6/8',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            'Glasses of water',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          Text(
            'Keep hydrated!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
