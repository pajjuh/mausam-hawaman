import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/current_weather.dart';

class CropConditionsCard extends StatefulWidget {
  final CurrentWeather currentWeather;

  const CropConditionsCard({super.key, required this.currentWeather});

  @override
  State<CropConditionsCard> createState() => _CropConditionsCardState();
}

class _CropConditionsCardState extends State<CropConditionsCard> {
  String _selectedCrop = 'Wheat';

  final List<String> _crops = ['Wheat', 'Rice', 'Cotton', 'Sugarcane', 'Maize'];

  String _evaluateCondition() {
    final temp = widget.currentWeather.temperature;
    
    // Simplified logic for demonstration based on general crop temp requirements
    switch (_selectedCrop) {
      case 'Wheat':
        if (temp >= 15 && temp <= 25) return 'Ideal';
        if (temp > 25 && temp <= 30) return 'Acceptable';
        return 'Stressful';
      case 'Rice':
        if (temp >= 22 && temp <= 32) return 'Ideal';
        if (temp > 32 && temp <= 35) return 'Acceptable';
        return 'Stressful';
      case 'Cotton':
        if (temp >= 21 && temp <= 30) return 'Ideal';
        if (temp > 30 && temp <= 35) return 'Acceptable';
        return 'Stressful';
      case 'Sugarcane':
        if (temp >= 27 && temp <= 32) return 'Ideal';
        if (temp > 32 && temp <= 38) return 'Acceptable';
        return 'Stressful';
      case 'Maize':
        if (temp >= 21 && temp <= 27) return 'Ideal';
        if (temp > 27 && temp <= 32) return 'Acceptable';
        return 'Stressful';
      default:
        return 'Unknown';
    }
  }

  Color _getConditionColor(String condition) {
    switch (condition) {
      case 'Ideal':
        return AppColors.success;
      case 'Acceptable':
        return AppColors.warning;
      case 'Stressful':
        return AppColors.danger;
      default:
        return AppColors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final condition = _evaluateCondition();
    final color = _getConditionColor(condition);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(16),
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Flexible(child: Icon(Icons.eco_rounded, color: AppColors.success)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Growing Conditions', 
                            style: AppTextStyles.displaySmall,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: DropdownButton<String>(
                      value: _selectedCrop,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                      elevation: 16,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      underline: Container(
                        height: 2,
                        color: AppColors.primary,
                      ),
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _selectedCrop = value;
                          });
                        }
                      },
                      items: _crops.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Temp: ${widget.currentWeather.temperature.round()}°C',
                          style: AppTextStyles.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Condition: $condition',
                          style: AppTextStyles.displayMedium.copyWith(color: color),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        condition == 'Ideal'
                            ? Icons.thumb_up_alt_rounded
                            : condition == 'Stressful'
                                ? Icons.warning_rounded
                                : Icons.thumbs_up_down_rounded,
                        color: color,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
