//
//  AppSupportClass.h
//  ILS
//
//  Created by admin on 02.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define getColorFromHex(rgbHex, a) \
    [UIColor colorWithRed:(float)(((NSInteger)(rgbHex) & 0xFF0000) >> 16) / 255.f \
                    green:(float)(((NSInteger)(rgbHex) & 0x00FF00) >> 8) / 255.f \
                    blue:(float)(((NSInteger)(rgbHex) & 0x0000FF) >> 0) / 255.f \
                    alpha: a]

static NSString *const kSignInViewControllerRememberMe = @"SignInViewControllerRememberMe";
static NSString *const kSignInViewControllerLoginText = @"SignInViewControllerLoginText";

static const CGFloat ILSView_CornerRadius = 3.f;
static const CGFloat ILS_CornerRadius = 8.f;

@interface AppSupportClass : NSObject

@property (class, readonly, nonatomic) UIColor *mainColor;
@property (class, readonly, nonatomic) UIColor *acceptColor;
@property (class, readonly, nonatomic) UIColor *declineColor;

@end
