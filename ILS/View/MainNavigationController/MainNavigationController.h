//
//  MainNavigationController.h
//  ILS
//
//  Created by admin on 11.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainNavigationController : UINavigationController

@property (assign, nonatomic) BOOL isOpenMenu;

- (void)showStartViewController;

@end

NS_ASSUME_NONNULL_END
