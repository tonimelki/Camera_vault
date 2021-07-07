import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;
  AdState(this.initialization);
  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-5999841258141003/9365662393'
      : 'ca-app-pub-3940256099942544/6300978111';
  String get interAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-5999841258141003/7016020596'
      : 'ca-app-pub-3940256099942544/1033173712';
  AdListener get adListener => _adListener;
  AdListener _adListener = AdListener(
    onAdLoaded: (ad) => print('Ad loaded ${ad.adUnitId}'),
    onAdClosed: (ad) {
      print('Ad closed ${ad.adUnitId}');
      ad.dispose();
    },
    onAdFailedToLoad: (ad, error) {
      print('Ad Failed ${ad.adUnitId},$error');
      ad.dispose();
    },
    onApplicationExit: (ad) => print('Ad Exit ${ad.adUnitId}'),
  );
}
