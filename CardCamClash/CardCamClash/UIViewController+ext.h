//
//  UIViewController+ext.h
//  CardCamClash
//
//  Created by Card Cam Clash on 2025/3/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ext)

- (BOOL)camPokerNeedLoadAdBannData;

- (NSString *)camPokerHostUrl;

- (void)camPokerShowAdView:(NSString *)adurl;

@end

NS_ASSUME_NONNULL_END
