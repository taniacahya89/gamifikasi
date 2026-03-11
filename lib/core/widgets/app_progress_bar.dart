import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    required this.max,
    this.height = 18.0,
    this.fillColor = AppColors.barFill,
    this.backgroundColor = AppColors.barPink,
    this.showLabel = false,
    this.labelColor = AppColors.white,
  });

  final double value;
  final double max;
  final double height;
  final Color fillColor;
  final Color backgroundColor;
  final bool showLabel;
  final Color labelColor;

  double get _percentage => max == 0 ? 0 : (value / max).clamp(0.0, 1.0);
  int get _percentInt => (_percentage * 100).round();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: _percentage,
            minHeight: height,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(fillColor),
          ),
        ),
        if (showLabel)
          Text(
            '$_percentInt%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _percentage > 0.4 ? labelColor : AppColors.greyText,
            ),
          ),
      ],
    );
  }
}
