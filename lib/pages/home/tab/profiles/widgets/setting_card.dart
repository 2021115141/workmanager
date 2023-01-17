import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workmanager/constants/constants.dart';
import '/util/extension/dimens.dart';
import '/util/extension/widget_extension.dart';

class SettingCard extends StatefulWidget {
  const SettingCard(
      {Key? key,
      required this.pressToProfile,
      required this.pressSignOut,
      required this.pressUploadAvatar})
      : super(key: key);

  final Function pressToProfile, pressSignOut, pressUploadAvatar;

  @override
  State<SettingCard> createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  final ImagePicker _picker = ImagePicker();

  void takePhoto(ImageSource source) async {
    final pickerFile = await _picker.pickImage(source: source);

    if (pickerFile != null) {
      widget.pressUploadAvatar(pickerFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildLanguage(),
        buildChangeAvatar(),
        buildSignOut(),
      ],
    );
  }

  Widget buildLanguage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppStrings.Language.plain()
                .fSize(15)
                .weight(FontWeight.w600)
                .b()
                .tr()
                .pad(15, 0, 10),
            const Icon(Icons.person).pad(10).inkTap(
                  onTap: widget.pressToProfile,
                  borderRadius: BorderRadius.circular(100),
                ),
          ],
        ),
        SizedBox(height: 2.w),
        Row(
          children: [
            'English'
                .plain()
                .fSize(14)
                .weight(FontWeight.w500)
                .b()
                .pad(2, 5)
                .inkTap(
                  onTap: () async {
                    await EasyLocalization.of(context)
                        ?.setLocale(const Locale('en', 'US'));
                  },
                  borderRadius: BorderRadius.circular(5),
                ),
          ],
        ).pad(10, 0, 0),
      ],
    );
  }

  Widget buildChangeAvatar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppStrings.ChangeAvatar.plain()
            .fSize(15)
            .weight(FontWeight.w600)
            .b()
            .tr()
            .pad(15, 0, 10),
        SizedBox(height: 5.w),
        Row(
          children: [
            Row(
              children: [
                const Icon(Icons.image),
                'Gallery'
                    .plain()
                    .fSize(14)
                    .weight(FontWeight.w500)
                    .b()
                    .pad(2, 5)
              ],
            ).inkTap(
              onTap: () {
                takePhoto(ImageSource.gallery);
              },
              borderRadius: BorderRadius.circular(5),
            ),
            SizedBox(width: 20.w),
            Row(
              children: [
                const Icon(Icons.camera_alt),
                'Camera'.plain().fSize(14).weight(FontWeight.w500).b().pad(2, 5)
              ],
            ).inkTap(
              onTap: () {
                takePhoto(ImageSource.camera);
              },
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ).pad(15, 0, 0),
      ],
    );
  }

  Widget buildSignOut() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.logout_outlined).pad(0, 15, 0),
        'Sign Out'.plain().fSize(18).weight(FontWeight.w600).b(),
      ],
    ).pad(15, 5, 20, 10).inkTap(
          onTap: widget.pressSignOut,
          borderRadius: BorderRadius.circular(10),
        );
  }
}
