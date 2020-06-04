//
//  AppSupportClass.m
//  ILS
//
//  Created by admin on 02.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "AppSupportClass.h"

@implementation AppSupportClass

+ (UIColor *)mainColor {
    return getColorFromHex(0x3783E0, 1.f);
}

+ (UIColor *)declineColor {
    return getColorFromHex(0xFF455F, 1.f);
}

+ (UIColor *)acceptColor {
    return getColorFromHex(0x47F257, 1.f);
}

@end
