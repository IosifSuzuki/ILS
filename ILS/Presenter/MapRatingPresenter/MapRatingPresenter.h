//
//  MapRatingPresenter.h
//  ILS
//
//  Created by admin on 30.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKGeometry.h>
#import <MapKit/MKAnnotation.h>

#import "UserInMapModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MapRatingDelegate <NSObject>

- (void)startAnimation;
- (void)stopAnimation;
- (void)addAnotation:(NSArray<id<MKAnnotation>> *)annotations;

@end


@interface MapRatingPresenter : NSObject

@property (strong, nonatomic) NSString *titleText;
@property (assign, readonly, nonatomic) MKMapRect ukraineRect;

@property (strong, nonatomic) NSArray<UserInMapModel *> *dataSource;

- (instancetype)initWithDelegate:(id<MapRatingDelegate>)delegate;

- (void)userIconFor:(id<MKAnnotation>)annotation withCompletionBlock:(void (^)(NSData *))completionBlock;

@end

NS_ASSUME_NONNULL_END
