import 'dart:math' as math;

import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
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
          child: Stack(
            children: [
              BarChart(
                BarChartData(
                  barTouchData: const BarTouchData(
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
                            child:
                                CustomLabelMedium(text: v.toInt().toString()),
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
                          ((v / interval).roundToDouble() - (v / interval))
                                  .abs() <
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
                            borderRadius: BorderRadius.zero,
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
              // 값 라벨 오버레이 (막대 내부 오른쪽 끝 정렬)
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final barCount = barItems.length;
                    if (barCount == 0) return const SizedBox.shrink();
                    final segmentHeight = (constraints.maxHeight -
                            (30.w + ((constraints.maxHeight - 120.w) / 8)) -
                            ((constraints.maxHeight - 120.w) / 8)) /
                        3;
                    barCount;
                    return Padding(
                      padding: EdgeInsets.only(
                        top: (constraints.maxHeight - 120.w) / 8,
                        bottom: 30.w + ((constraints.maxHeight - 120.w) / 8),
                        left: 90.w,
                        right: 0.w,
                      ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          barCount,
                          (i) {
                            final value = barItems[i].value.toDouble();

                            // 값을 0부터 plotMaxY의 값으로 정규화
                            final clamped = value.clamp(0, plotMaxY);

                            // 플롯 최대값 대비 비율
                            final ratio =
                                plotMaxY == 0 ? 0.0 : clamped / plotMaxY;

                            // constraints.maxWidth에 대한 플롯 최대값 대비 비율의 너비
                            // 실제 SizedBox를 그려야 할 공간은
                            // constraints.maxWidth에서 bottomTitle의 reservedSize(90.w)만큼을 뺀 값
                            // 그 너비에서 얼마만큼의 너비를 가져야 하는지를 계산
                            final ratioRatio =
                                ratio * (constraints.maxWidth - 90.w);

                            // ratioRatio는 실제 너비였음. 우리는 비율이 필요함
                            final ratioRatioRatio =
                                ratioRatio / (constraints.maxWidth - 90.w);

                            if (ratioRatioRatio <= 0.5) {
                              return SizedBox(
                                height: segmentHeight,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: FractionallySizedBox(
                                    widthFactor: 1 - ratioRatioRatio,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5.w),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: CustomLabelMedium(
                                          text: barItems[i].value.toString(),
                                          textColor:
                                          context.appColors.onBackground,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: segmentHeight,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: FractionallySizedBox(
                                    widthFactor: 1.0,
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(
                                        right: (1 - ratioRatioRatio) *
                                                (constraints.maxWidth - 90.w) +
                                            5.w,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: CustomLabelMedium(
                                          text: barItems[i].value.toString(),
                                          textColor:
                                              context.appColors.onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<BarItem> barItems;
}
