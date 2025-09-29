import 'dart:math' as math;

import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_label_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_label_medium.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BarItem {
  final String label;
  final int value;

  BarItem({required this.label, required this.value});
}

class StepCountStatisticsChart extends StatelessWidget {
  final LocalizationManager localizationManager = LocalizationManager();

  StepCountStatisticsChart({
    super.key,
    required this.barItems,
  });

  @override
  Widget build(BuildContext context) {
    // 원하는 라벨 개수: 5개(0 포함) → 구간은 4개
    const segments = 4;

    // 최댓값
    final rawMax = barItems.isEmpty
        ? 0.0
        : barItems.map((e) => e.value.toDouble()).reduce(math.max);

    // 5의 배수 올림
    double ceilToMultipleOf5(double v) =>
        (v <= 0 ? 5 : (v / 5).ceil() * 5).toDouble();

    // 눈금 간격과 우리가 보여줄 마지막 눈금(targetMax)
    final interval = ceilToMultipleOf5(rawMax / segments);
    final double targetMax = interval * segments;

    // 플롯용 실제 최대값은 살짝 크게(윗쪽 여백)
    const topHeadroomFactor = 0.15; // 필요시 0.1~0.2 사이로 조절
    final double plotMaxY = targetMax + interval * topHeadroomFactor;

    return CustomRoundedBorderedContainer(
      width: double.infinity,
      borderWidth: 0.5.w,
      color: context.appColors.background,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
        child: SizedBox(
          height: 170.w,
          child: BarChart(
            BarChartData(
              barTouchData: BarTouchData(
                enabled: false,
              ),
              rotationQuarterTurns: 1,
              minY: 0,
              maxY: plotMaxY,
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                      color: context.appColors.borderColor, width: 1.w),
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    minIncluded: true,
                    maxIncluded: true,
                    reservedSize: 30.w,
                    interval: interval,
                    getTitlesWidget: (v, meta) {
                      // 0~targetMax까지만 라벨 출력
                      if (v < -1e-6 || v > targetMax + 1e-6)
                        return const SizedBox.shrink();
                      return SideTitleWidget(
                        meta: meta,
                        // axisSide: meta.axisSide,
                        child: CustomLabelMedium(
                            text: v.toInt().toString()), // 1300처럼 정수로
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 90.w,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= barItems.length) {
                        return const SizedBox.shrink();
                      }
                      if (Localizations.localeOf(context).languageCode ==
                          "ko") {
                        return SideTitleWidget(
                          meta: meta,
                          child: CustomBodyLarge(
                            text: barItems[index].label,
                          ),
                        );
                      } else {
                        return SideTitleWidget(
                          meta: meta,
                          child: CustomLabelMedium(
                            text: barItems[index].label,
                          ),
                        );
                      }
                    },
                  ),
                ),
                leftTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                drawHorizontalLine: true,
                horizontalInterval: interval,
                checkToShowHorizontalLine: (v) {
                  const eps = 1e-6;
                  if (v < -eps || v > targetMax + eps) return false;
                  final aligned =
                      ((v / interval).roundToDouble() - (v / interval)).abs() <
                          eps;
                  return aligned;
                },
                getDrawingHorizontalLine: (value) => FlLine(
                    color: context.appColors.borderColor, strokeWidth: 1.w),
              ),
              barGroups: barItems.asMap().entries.map(
                (e) {
                  final index = e.key;
                  final data = e.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                          toY: data.value.toDouble(),
                          color: context.appColors.primary,
                          width: 30.w,
                          borderRadius: BorderRadius.zero),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }

  final List<BarItem> barItems;
}
