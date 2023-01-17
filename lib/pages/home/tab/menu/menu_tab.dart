import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:workmanager/util/ads/ad_helper.dart';

import '/constants/constants.dart';
import '/base/base_state.dart';
import '/models/project_model.dart';
import '/util/extension/dimens.dart';
import '/util/extension/widget_extension.dart';
import 'widgets/add_project_button.dart';
import '../../../../util/ui/common_widget/project_card.dart';
import 'menu_provider.dart';
import 'menu_vm.dart';

class MenuTab extends StatefulWidget {
  final ScopedReader watch;

  final Function pressMode;

  static Widget instance({required Function pressMode}) {
    return Consumer(builder: (context, watch, _) {
      return MenuTab._(watch, pressMode);
    });
  }

  const MenuTab._(this.watch, this.pressMode);

  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

class MenuState extends BaseState<MenuTab, MenuViewModel> {
  late BannerAd _bannerAd;
  bool showAds = true;
  bool _isBannerAdReady = false;
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  bool isToDay = true;

  @override
  void initState() {
    super.initState();
    if (showAds) {
      _initGoogleMobileAds();
      _bannerAd = BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              _isBannerAdReady = true;
            });
          },
          onAdFailedToLoad: (ad, err) {
            _isBannerAdReady = false;
            ad.dispose();
          },
        ),
      );

      _bannerAd.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      appBar: buildAppBar(),
      backgroundColor: const Color.fromARGB(255, 240, 243, 236),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Flexible(
          //height: MediaQuery.of(context).size.height * 0.72,
          child: SingleChildScrollView(
            child: StreamBuilder<List<ProjectModel>?>(
              stream: getVm().bsProject,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return AppStrings.somethingWentWrong.text12().tr().center();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return AppStrings.loading.text12().tr().center();
                }

                List<ProjectModel> data = snapshot.data!;

                return Wrap(
                  spacing: 12.w,
                  runSpacing: 24.w,
                  children: [
                    SizedBox(
                      height: 7.w,
                      width: screenWidth,
                    ),
                    for (int i = 0; i < data.length; i++)
                      ProjectCard(
                        project: data[i],
                        press: widget.pressMode,
                        deletePress: getVm().deleteProject,
                      ),
                    AddProjectButton(
                      press: getVm().addProject,
                    )
                  ],
                ).pad(0, 16);
              },
            ),
          ),
        ),
        if (_isBannerAdReady)
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
          ),
      ],
    );
  }

  AppBar buildAppBar() => StringTranslateExtension(AppStrings.projects)
      .tr()
      .plainAppBar(color: AppColors.kWhiteBackground)
      .backgroundColor(AppColors.kPrimaryColor)
      .bAppBar();

  @override
  MenuViewModel getVm() => widget.watch(viewModelProvider).state;
}
