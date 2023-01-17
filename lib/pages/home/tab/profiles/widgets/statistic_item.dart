import 'package:flutter/material.dart';
import 'package:workmanager/constants/app_colors.dart';
import 'package:workmanager/constants/images.dart';
import 'package:workmanager/util/extension/dimens.dart';
import 'package:workmanager/util/extension/widget_extension.dart';

class StatisticIcon extends StatelessWidget {
  const StatisticIcon({
    Key? key,
    required this.color,
    required this.title,
    required this.ratio,
  }) : super(key: key);

  final Color color;
  final String title;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: AppColors.kGrayBorderColor,
              width: 1,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                ),
                image: const AssetImage(
                  AppImages.imgStatistic,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: '${ratio.toStringAsFixed(1)}%'
                .bold()
                .fSize(18)
                .lHeight(21.09)
                .b()
                .center(),
          ),
        ),
        const SizedBox(height: 14),
        title.plain().fSize(16).weight(FontWeight.w500).lHeight(20).b(),
      ],
    );
  }
}
