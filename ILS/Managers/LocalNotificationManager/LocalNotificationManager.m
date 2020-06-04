//
//  LocalNotificationManager.m
//  ILS
//
//  Created by admin on 04.06.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import "LocalNotificationManager.h"

static NSString *const kLocalNotificationManager = @"ILS";

@interface LocalNotificationManager() <UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UNUserNotificationCenter *userNotificationCenter;

@end

@implementation LocalNotificationManager

+ (instancetype)sharedManager {
    static LocalNotificationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocalNotificationManager alloc] init];
        [sharedInstance setupManager];
    });
    
    return sharedInstance;
}

#pragma mark - Private

- (void)setupManager {
    self.userNotificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    self.userNotificationCenter.delegate = self;
}

- (void)getNotificationSettings {
    [self.userNotificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"Settings: %@", settings);
    }];
}

#pragma mark - Public

- (void)requestAutorization {
    [self.userNotificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"Granded: %d", granted);
        if (!granted) {
            return;
        }
        [self getNotificationSettings];
    }];
}

- (void)sheduleNotificationThrough:(NSTimeInterval)timeInterval withMessage:(NSString *)message {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = kLocalNotificationManager;
    content.body = message;
    content.sound = [UNNotificationSound defaultSound];
    
    UNTimeIntervalNotificationTrigger *triger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:kLocalNotificationManager content:content trigger:triger];
    
    [self.userNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark: - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}


@end
