import 'dart:developer';
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

const testRewardedId = "ca-app-pub-3940256099942544/5224354917";
const testAndroidBannerId = "ca-app-pub-3940256099942544/6300978111";
const testIOSBannerId = "ca-app-pub-3940256099942544/2934735716";
const iOSTestRewardedId = "ca-app-pub-3940256099942544/1712485313";

class AdsManager {
  static RewardedAd? _rewardedAd;
  static BannerAd? bannerAd;

  static AdRequest _createAdRequest() {
    return const AdRequest(
        keywords: ["Game", "Games", "Mobile Games", "Mobile Game"]);
  }

  static initializeRewardedAds() {
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? testRewardedId
            : iOSTestRewardedId,
        request: _createAdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;

          initializeRewardedAds();
        }));
  }

  static initializeBannerAds(){
    bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? testAndroidBannerId
          : testIOSBannerId,
      request: _createAdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, err) {
          log(err.toString());
          ad.dispose();
        },
      ),
    )..load();
  }

  // Show rewarded ad if probability is < 0.4
  static void showRewardedAd(double showAdProbability) {
    log("Show ad probability is $showAdProbability");

    if (_rewardedAd == null || showAdProbability >= 0.4) {
      log('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          log('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        initializeRewardedAds();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        log('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        initializeRewardedAds();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      log('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedAd = null;
  }

  static void disposeAds() {
    _rewardedAd?.dispose();
    bannerAd?.dispose();
  }
}
