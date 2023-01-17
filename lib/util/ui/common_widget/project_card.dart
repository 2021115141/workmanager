import 'package:flutter/material.dart';
import 'package:workmanager/constants/app_colors.dart';
import 'package:workmanager/constants/constants.dart';
import 'package:workmanager/models/project_model.dart';
import 'package:workmanager/util/extension/dimens.dart';
import 'package:workmanager/util/extension/widget_extension.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    Key? key,
    required this.project,
    required this.press,
    required this.deletePress,
  }) : super(key: key);

  final ProjectModel project;
  final Function press;
  final Function deletePress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165.w,
      height: 180.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 10),
            color: const Color(0xFFE3E3E3).withOpacity(.5),
            blurRadius: 5.r,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                      color: AppColors.kColorNote[project.indexColor]
                          .withOpacity(.3),
                      shape: BoxShape.circle),
                  child: Center(
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                          color: AppColors.kColorNote[project.indexColor],
                          shape: BoxShape.circle),
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ).inkTap(
                    onTap: () => deletePress(project),
                    borderRadius: BorderRadius.circular(5)),
              ],
            ),
            const Spacer(),
            Text(
              project.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Text("${project.listTask.length} Task")
          ],
        ),
      ),
    ).inkTap(
      onTap: () => press(project),
      borderRadius: BorderRadius.circular(5),
    );
  }
}
