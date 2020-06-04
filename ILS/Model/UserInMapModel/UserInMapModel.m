//
//  UserInMapModel.m
//  ILS
//
//  Created by admin on 30.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "UserInMapModel.h"

@implementation UserInMapModel 

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate withTitle:(NSString * _Nullable)title withSubtitle:(NSString * _Nullable)subtitle withUserId:(NSString * _Nullable)userId {
    if (self = [super init]) {
        self->_coordinate = coordinate;
        self->_title = title;
        self->_subtitle = subtitle;
        self->_userId = userId;
    }
    
    return self;
}

#pragma mark - Private



@end
