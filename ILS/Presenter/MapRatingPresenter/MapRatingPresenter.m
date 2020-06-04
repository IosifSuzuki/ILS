//
//  MapRatingPresenter.m
//  ILS
//
//  Created by admin on 30.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "MapRatingPresenter.h"

#import "FirebaseManager.h"

#import "UserModel.h"

static NSString *const kMapRatingPresenterTitle = @"title";

@interface MapRatingPresenter()

@property (weak, nonatomic) id<MapRatingDelegate> delegate;

@end

@implementation MapRatingPresenter

@synthesize ukraineRect = _ukraineRect;

- (instancetype)initWithDelegate:(id<MapRatingDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        
        [self setupPresenter];
    }
    return self;
}

#pragma mark - Private

- (void)setupPresenter {
    [self fetchData];
}

- (void)fetchData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MapRating" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.titleText = [data objectForKey:kMapRatingPresenterTitle];
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"MapGeo" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    
    NSArray<NSDictionary *> *pointsDictionary = [[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil] objectForKey:@"rectCountry"];
    MKMapRect resultMapRect = MKMapRectNull;
    for (NSDictionary *pointDictionary in pointsDictionary) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[[pointDictionary objectForKey:@"latitude"] doubleValue] longitude:[[pointDictionary objectForKey:@"longitude"] doubleValue]];
        MKMapPoint pointMap = MKMapPointForCoordinate(location.coordinate);
        MKMapRect rectMap = MKMapRectMake(pointMap.x, pointMap.y, 1, 1);
        resultMapRect = MKMapRectUnion(resultMapRect, rectMap);
    }
    self->_ukraineRect = resultMapRect;
    
    NSArray *regionsArray = [[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil] objectForKey:@"regions"];
    NSMutableArray<UserInMapModel *> *mutableDataSource = [[NSMutableArray alloc] initWithCapacity:[regionsArray count]];
    
    [self.delegate startAnimation];
    
    dispatch_group_t group = dispatch_group_create();
    for (NSDictionary *regionDictionary in regionsArray) {
        CLLocation *regionLocation = [[CLLocation alloc] initWithLatitude:[[regionDictionary objectForKey:@"latitude"] doubleValue] longitude:[[regionDictionary objectForKey:@"longitude"] doubleValue]];
        dispatch_group_enter(group);
        [[FirebaseManager sharedManager] getBestUserFromRegion:[regionDictionary objectForKey:@"name"] withCompletionBlock:^(UserModel *userModel) {
            UserInMapModel *userInMapModel;
            if (userModel) {
                userInMapModel = [[UserInMapModel alloc] initWithCoordinate:regionLocation.coordinate withTitle:userModel.nickName withSubtitle:[NSString stringWithFormat:@"balls: %ld", userModel.balls] withUserId:userModel.userId];
            } else {
                userInMapModel = [[UserInMapModel alloc] initWithCoordinate:regionLocation.coordinate withTitle:@"Нема представника з регіону" withSubtitle:nil withUserId:nil];
            }
            
            [mutableDataSource addObject:userInMapModel];
            self.dataSource = [mutableDataSource copy];
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.delegate addAnotation:self.dataSource];
        [self.delegate stopAnimation];
    });
}

- (void)userIconFor:(id<MKAnnotation>)annotation withCompletionBlock:(void (^)(NSData *))completionBlock {
    UserInMapModel *userInMapModel = (UserInMapModel *)annotation;
    if (userInMapModel.userId) {
    [[FirebaseManager sharedManager] getIconUserWithUserId:userInMapModel.userId withCompletionBlock:^(NSData * data) {
        completionBlock(data);
    }];
    } else {
        completionBlock(nil);
    }
}


@end
