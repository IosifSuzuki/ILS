//
//  WordsPageViewController.h
//  ILS
//
//  Created by admin on 12.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavigationControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface WordsPageViewController : UIPageViewController <MainNavigationControllerDelegate>

@property (assign, nonatomic, readonly) BOOL showMenuBarButtonItem;

@end

NS_ASSUME_NONNULL_END
