//
//  MainNavigationControllerProtocol.h
//  ILS
//
//  Created by admin on 11.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#ifndef MainNavigationControllerDelegate_h
#define MainNavigationControllerDelegate_h

#import <Foundation/Foundation.h>

@protocol MainNavigationControllerDelegate <NSObject>

@property (assign, nonatomic, readonly) BOOL showMenuBarButtonItem;

@optional
@property (assign, nonatomic, readonly) BOOL allowRotation;

@end
#endif /* MainNavigationControllerProtocol_h */
