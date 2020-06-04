//
//  MainMenuViewController.h
//  ILS
//
//  Created by admin on 11.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainMenuViewController : UIViewController

@property (weak, nonatomic) MainNavigationController *fromNavigationController;

- (void)showMenuAnimated:(BOOL)animated withCompletionBlock:(void(^_Nullable)(void))completion;
- (void)closeMenuAnimated:(BOOL)animated withCompletionBlock:(void(^_Nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
