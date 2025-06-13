import 'package:flutter/material.dart';

class BlurControls extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const BlurControls({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.blur_on,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Text('Blur', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Text(
                value.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Slider(
            value: value,
            min: 0.0,
            max: 20.0,
            divisions: 100,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
