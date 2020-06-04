//
//  ProfilePresenter.h
//  ILS
//
//  Created by admin on 15.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Charts/Charts-Swift.h>
#import "User+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileDelegate <NSObject>

- (void)updateProfileIconWithData:(NSData *)iconProfileData;
- (void)startAnimation;
- (void)stopAnimation;

@end

@interface ProfilePresenter : NSObject <IChartAxisValueFormatter>

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *noSelectedText;
@property (strong, nonatomic) NSString *emailText;
@property (strong, nonatomic) NSString *yourRegionText;
@property (strong, nonatomic) NSString *cameraText;
@property (strong, nonatomic) NSString *photoLibraryText;
@property (strong, nonatomic) NSString *selectOptionForPhtotoSourceText;
@property (strong, nonatomic) NSString *backText;
@property (assign, nonatomic) NSInteger selectedRegion;
@property (strong, nonatomic) NSArray <NSNumber *> *valuesForStatistic;

@property (strong, nonatomic) NSString *userNickName;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userRegion;
@property (strong, nonatomic) NSString *userBalls;

@property (strong, nonatomic, nullable) NSData *nIconProfile;
@property (strong, nonatomic, nullable) NSString *nNickName;
@property (strong, nonatomic, nullable) NSString *nRegion;

- (instancetype)initWithDelegate:(id<ProfileDelegate>)delegate;
- (NSInteger)numberOfRegion;
- (NSString *)regionWithIndex:(NSInteger)index;
- (NSString *)getRegion:(NSString *)region;
- (void)updateIconPhotoWithURL:(NSString *)iconPhotoURL;
- (void)updateChart;
- (void)getUserIcon;
- (void)updateUserProfile;

@end

NS_ASSUME_NONNULL_END
