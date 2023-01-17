import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workmanager/models/project_model.dart';
import 'package:workmanager/util/ui/common_widget/back_to_login.dart';

import '/base/base_state.dart';
import '/constants/constants.dart';
import '/pages/home/tab/menu/menu_tab.dart';
import '/pages/home/tab/profiles/profile_tab.dart';
import '/util/extension/extension.dart';
import 'home_provider.dart';
import 'home_vm.dart';
import 'tab/my_task/my_task_tab.dart';
import 'tab/quick/quick_tab.dart';
import 'widgets/add_new_button.dart';

class HomePage extends StatefulWidget {
  final ScopedReader watch;

  static Widget instance() {
    return Consumer(builder: (context, watch, _) {
      return HomePage._(watch);
    });
  }

  const HomePage._(this.watch);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends BaseState<HomePage, HomeViewModel> {
  int currentTab = 0;
  PageController tabController = PageController();
  ProjectModel? projectMode;

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void logOutClick() {
    getVm().logOut();
  }

  List<Widget> tabWidget = [];

  @override
  void initState() {
    super.initState();

    //notification
    getVm().initMessingToken();
    requestMessagingPermission();
    loadFCM();
    listenFCM();
    //tab widget
    tabWidget = [
      MyTaskTab.instance(mode: projectMode, closeProjectMode: closeProjectMode),
      MenuTab.instance(pressMode: setProjectMode),
      QuickTab.instance(),
      ProfileTab.instance(),
    ];
  }

  requestMessagingPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // ignore: unused_local_variable
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
  }

  listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                  title: Text(notification.title!),
                  content: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(notification.body!)]),
                  ));
            });
      }
    });
  }

  loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
          "high_important_channel", //id
          "high important notification", //title
          description:
              "this channel is used for important notification.", //description
          importance: Importance.high,
          enableVibration: true,
          playSound: true);

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void setProjectMode(ProjectModel value) async {
    setState(() {
      projectMode = value;
      tabWidget[0] = MyTaskTab.instance(
          mode: projectMode, closeProjectMode: closeProjectMode);
    });
    await tabController.animateToPage(
      0,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeIn,
    );
  }

  void closeProjectMode() async {
    setState(() {
      projectMode = null;
      tabWidget[0] = MyTaskTab.instance(
          mode: projectMode, closeProjectMode: closeProjectMode);
    });
    await tabController.animateToPage(
      0,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeIn,
    );
  }

  void tabClick(int index) {
    if (index > 1) {
      setState(() {
        currentTab = index - 1;
      });
    } else {
      setState(() {
        currentTab = index;
      });
    }
    tabController.animateToPage(
      currentTab,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeIn,
    );
  }

  void goTab(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (getVm().user == null) return const BackToLogin();
    return Scaffold(
      body: buildBody(),
      floatingActionButton: const AddNewButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildBottomNavigationBar(
        currentIndex: currentTab,
        press: tabClick,
      ),
    );
  }

  SizedBox buildBody() {
    return SizedBox(
      width: double.infinity,
      height: screenHeight,
      child: PageView.builder(
        itemCount: 4,
        onPageChanged: (index) => goTab(index),
        itemBuilder: (context, index) => tabWidget[index],
        controller: tabController,
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar({
    required int currentIndex,
    required Function press,
  }) {
    return BottomNavigationBar(
      selectedIconTheme: const IconThemeData(color: Colors.white),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      backgroundColor: const Color.fromARGB(255, 22, 60, 37),
      items: [
        buildBottomNavigationBarItem(
          title: StringTranslateExtension(AppStrings.myTask).tr(),
          icon: AppImages.myTaskIcon,
          index: 0,
        ),
        buildBottomNavigationBarItem(
          title: StringTranslateExtension(AppStrings.menu).tr(),
          icon: AppImages.menuIcon,
          index: 1,
        ),
        BottomNavigationBarItem(icon: Container(), label: ""),
        buildBottomNavigationBarItem(
          title: StringTranslateExtension(AppStrings.quick).tr(),
          icon: AppImages.quickIcon,
          index: 2,
        ),
        buildBottomNavigationBarItem(
          title: StringTranslateExtension(AppStrings.profiles).tr(),
          icon: AppImages.profileIcon,
          index: 3,
        ),
      ],
      onTap: (index) => press(index),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem({
    required String title,
    required String icon,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(
          top: 4,
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              color: Colors.white.withOpacity(currentTab == index ? 1 : .5),
              width: 24.w,
              height: 24.w,
            ),
            const SizedBox(height: 4),
            title
                .plain()
                .fSize(12)
                .color(Colors.white.withOpacity(currentTab == index ? 1 : .5))
                .b()
          ],
        ),
      ),
      label: title,
    );
  }

  @override
  HomeViewModel getVm() => widget.watch(viewModelProvider).state;
}
