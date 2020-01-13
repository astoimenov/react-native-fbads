//
//  CTKBannerView.m
//  rn-fbads
//
//  Created by Mike Grabowski on 23/01/2017.
//  Copyright © 2017 callstack. All rights reserved.
//

@import FBAudienceNetwork;
#import "CTKBannerView.h"
#import <React/RCTUtils.h>

@interface CTKBannerView () <FBAdViewDelegate>

@end

@implementation CTKBannerView

- (void)setSize:(NSNumber *)size {
  _size = size;
  [self createViewIfCan];
}

- (void)setPlacementId:(NSString *)placementId {
  _placementId = placementId;
  [self createViewIfCan];
}

// Initialise BannerAdView as soon as all the props are set
- (void)createViewIfCan {
  if (!_placementId || !_size) {
    return;
  }

  FBAdSize fbAdSize = [self fbAdSizeForHeight:_size];

  FBAdView *adView = [[FBAdView alloc] initWithPlacementID:_placementId
                                                    adSize:fbAdSize
                                        rootViewController:RCTPresentedViewController()];

  adView.frame = CGRectMake(0, 0, adView.bounds.size.width, adView.bounds.size.height);
  adView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  adView.delegate = self;

  [adView loadAd];

  [self addSubview:adView];
}

- (FBAdSize)fbAdSizeForHeight:(NSNumber *)height {
  switch ([height intValue]) {
    case 90:
      return kFBAdSizeHeight90Banner;
    case 250:
      return kFBAdSizeHeight250Rectangle;
    case 50:
    default:
      return kFBAdSizeHeight50Banner;
  }
}

# pragma mark - FBAdViewDelegate

- (void)adViewDidClick:(FBAdView *)adView
{
  if (_onAdPress) {
    _onAdPress(nil);
  }
}

- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error
{
  if (_onAdError) {
    _onAdError(RCTJSErrorFromNSError(error));
  } else {
    RCTMakeAndLogError(error.localizedDescription, nil, error.userInfo);
  }
}

- (void)adViewDidFinishHandlingClick:(FBAdView *)adView {}
- (void)adViewWillLogImpression:(FBAdView *)adView {}

@end
