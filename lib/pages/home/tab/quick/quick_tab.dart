import 'package:flutter/material.dart';
import '/base/base_state.dart';
import '/constants/app_colors.dart';
import '/routing/app_routes.dart';
import '/models/quick_note_model.dart';
import '/util/extension/dimens.dart';
import '/util/extension/widget_extension.dart';
import '../../../../util/ui/common_widget/quick_note_card.dart';
import 'quick_provider.dart';
import 'quick_vm.dart';

class QuickTab extends StatefulWidget {
  final ScopedReader watch;

  static Widget instance() {
    return Consumer(builder: (context, watch, _) {
      return QuickTab._(watch);
    });
  }

  const QuickTab._(this.watch);

  @override
  State<StatefulWidget> createState() {
    return QuickState();
  }
}

class QuickState extends BaseState<QuickTab, QuickViewModel> {
  bool isFullQuickNote = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      appBar: buildAppBar(),
    );
  }

  Widget buildBody() {
    return Container(
      color: AppColors.kWhiteBackground,
      height: screenHeight,
      width: screenWidth,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 32.w),
            StreamBuilder<List<QuickNoteModel>?>(
                stream: getVm().bsListQuickNote,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  List<QuickNoteModel> data = snapshot.data!;
                  return Column(
                    children: [
                      if (data.isEmpty) buildNoneNote(),
                      for (int i = 0; i < data.length; i++)
                        isFullQuickNote == true ||
                                (!isFullQuickNote &&
                                    data[i].isSuccessful == false)
                            ? QuickNoteCard(
                                note: data[i],
                                color: AppColors.kColorNote[data[i].indexColor],
                                successfulPress: () =>
                                    getVm().successfulQuickNote(data[i]),
                                checkedPress: getVm().checkedNote,
                                deletePress: () {
                                  getVm().deleteNote(data[i]);
                                },
                              )
                            : const SizedBox(),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() => 'Quick Notes'
          .plainAppBar(color: AppColors.kWhiteBackground)
          .backgroundColor(AppColors.kPrimaryColor)
          .actions(
        [
          Switch(
            value: isFullQuickNote,
            onChanged: (value) {
              setState(() {
                isFullQuickNote = !isFullQuickNote;
              });
            },
          ),
        ],
      ).bAppBar();

  Widget buildNoneNote() =>
      'You are not have a note, create a note to continue'.desc().inkTap(
        onTap: () {
          Get.toNamed(AppRoutes.NEW_NOTE);
        },
      );

  @override
  QuickViewModel getVm() => widget.watch(viewModelProvider).state;
}
