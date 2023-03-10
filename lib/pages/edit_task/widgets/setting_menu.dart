import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/base/base_state.dart';
import 'package:workmanager/constants/constants.dart';
import 'package:workmanager/util/extension/extension.dart';

import '../../../routing/app_routes.dart';

// ignore: must_be_immutable
class SettingMenu extends StatelessWidget {
  SettingMenu(
      {Key? key,
      required this.appBarHeight,
      required this.taskId,
      this.acceptDelete})
      : super(key: key);

  final double appBarHeight;
  final String taskId;
  VoidCallback? acceptDelete;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 228.w,
        height: 88.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Column(
          children: [
            buildEditItem('Edit task'),
            buildDeleteItem('Delete task', context),
          ],
        ),
      ),
    ).pad(0, 14, appBarHeight, 0);
  }

  Widget buildEditItem(String text) => SizedBox(
        height: 44.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: text.plain().fSize(17).lines(1).b().tr(),
            ),
          ],
        ),
      ).pad(0, 16).inkTap(
            onTap: () {
              Get.offAndToNamed(AppRoutes.EDIT_TASK, arguments: taskId);
            },
            borderRadius: BorderRadius.circular(5.r),
          );

  Widget buildDeleteItem(String text, BuildContext context) => SizedBox(
        height: 44.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: text.plain().fSize(17).lines(1).b().tr(),
            ),
          ],
        ),
      ).pad(0, 16).inkTap(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                        title: const Text(AppStrings.confirmDelete).tr(),
                        actions: [
                          CupertinoDialogAction(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(AppStrings.no).tr()),
                          CupertinoDialogAction(
                              onPressed: () => acceptDelete!(),
                              child: const Text(AppStrings.yes).tr())
                        ],
                      ));
            },
            borderRadius: BorderRadius.circular(5.r),
          );
}
