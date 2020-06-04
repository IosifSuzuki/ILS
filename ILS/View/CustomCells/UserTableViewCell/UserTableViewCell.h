//
//  UserTableViewCell.h
//  ILS
//
//  Created by admin on 29.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UserTableViewCellDelegate <NSObject>

@property (assign, nonatomic) NSInteger numberInRating;
@property (strong, nonatomic) NSString *nicknameUser;
@property (strong, nonatomic) NSString *regionUser;
@property (assign, nonatomic) NSInteger ballsUser;
@property (retain, nonatomic) NSString *userIdForIcon;

@end

@interface UserTableViewCell : UITableViewCell <UserTableViewCellDelegate>

@property (weak, class, readonly, nonatomic) NSString *identifierUserTableViewCell;

@property (assign, nonatomic) NSInteger numberInRating;
@property (retain, nonatomic) NSString *nicknameUser;
@property (retain, nonatomic) NSString *regionUser;
@property (assign, nonatomic) NSInteger ballsUser;
@property (retain, nonatomic) NSString *userIdForIcon;

@end

NS_ASSUME_NONNULL_END
