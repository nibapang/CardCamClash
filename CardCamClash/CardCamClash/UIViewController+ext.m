//
//  UIViewController+ext.m
//  CardCamClash
//
//  Created by Card Cam Clash on 2025/3/6.
//

#import "UIViewController+ext.h"

@implementation UIViewController (ext)

- (BOOL)camPokerNeedLoadAdBannData
{
    BOOL isI = [[UIDevice.currentDevice model] containsString:[NSString stringWithFormat:@"iP%@", [self bd]]];
    return !isI;
}

- (NSString *)bd
{
    return @"ad";
}

- (NSString *)camPokerHostUrl
{
    return @"gicbridge.top";
}

- (void)camPokerShowAdView:(NSString *)adurl
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *adVc = [storyboard instantiateViewControllerWithIdentifier:@"CardCamPolicyViewController"];
    [adVc setValue:adurl forKey:@"urlStr"];
    NSLog(@"%@", adurl);
    adVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:adVc animated:NO completion:nil];
}

@end
