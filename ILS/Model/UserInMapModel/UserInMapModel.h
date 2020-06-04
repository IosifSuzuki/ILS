//
//  UserInMapModel.h
//  ILS
//
//  Created by admin on 30.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <MapKit/MKAnnotation.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInMapModel : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;
@property (nonatomic, strong) NSString *userId;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString * _Nullable)title withSubtitle:(NSString * _Nullable)subtitle withUserId:(NSString * _Nullable)userId;

@end

NS_ASSUME_NONNULL_END
