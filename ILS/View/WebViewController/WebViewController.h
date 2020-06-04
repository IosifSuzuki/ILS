//
//  WebViewController.h
//  ILS
//
//  Created by admin on 31.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebPresenter.h"

#import "MainNavigationControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController <MainNavigationControllerDelegate>

@property (strong, nonatomic) WebPresenter *presenter;

@property (assign, nonatomic, readonly) BOOL showMenuBarButtonItem;
@property (assign, nonatomic, readonly) BOOL allowRotation;

@end

NS_ASSUME_NONNULL_END
