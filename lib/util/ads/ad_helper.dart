import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';

      //Your Banner Add Id
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
