//
//  LoaderView.h
//  ILS
//
//  Created by admin on 14.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoaderView : UIView

+ (instancetype)sharedInstance;

- (void)startAnimationFromView:(UIView *)view;
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
