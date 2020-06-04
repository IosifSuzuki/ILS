//
//  LocalNotificationManager.h
//  ILS
//
//  Created by admin on 04.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalNotificationManager : NSObject

+ (instancetype)sharedManager;

- (void)requestAutorization;
- (void)sheduleNotificationThrough:(NSTimeInterval)timeInterval withMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
