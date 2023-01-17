import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterAdHelper {
  static String get interadunitid {
    if (Platform.isAndroid) {
      // ignore: deprecated_member_use
      return "";

      //Your Interstitial ads id

      //Example  (return 'ca-app-pub-3940256099942544/6300978111';)
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
