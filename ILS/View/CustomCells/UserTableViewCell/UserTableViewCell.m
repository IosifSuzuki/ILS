//
//  UserTableViewCell.m
//  ILS
//
//  Created by admin on 29.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "UserTableViewCell.h"

#import "AppSupportClass.h"

#import "FirebaseManager.h"

@interface UserTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *ratingNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ballsLabel;

@end

@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setupView];
}

#pragma mark - Accessor


+ (NSString *)identifierUserTableViewCell {
    return NSStringFromClass([UserTableViewCell class]);
}

- (void)setBallsUser:(NSInteger)ballsUser {
    self.ballsLabel.text = [NSString stringWithFormat:@"%ld", ballsUser];
}

- (void)setNicknameUser:(NSString *)nicknameUser {
    self.nicknameLabel.text = nicknameUser;
}

- (void)setRegionUser:(NSString *)regionUser {
    self.regionNameLabel.text = [regionUser isEqualToString:@"nil"] ? @"Невідомо" : regionUser;
}

- (void)setNumberInRating:(NSInteger)numberInRating {
    self.ratingNumberLabel.text = [NSString stringWithFormat:@"#%ld", numberInRating];
    
    UIColor *textColor = self.ratingNumberLabel.textColor;
    switch (numberInRating) {
        case 1: {
            textColor = getColorFromHex(0xC9B037, 1.f);
        }
            break;
        case 2: {
            textColor = getColorFromHex(0xD7D7D7, 1.f);
        }
            break;
        case 3: {
            textColor = getColorFromHex(0x6A3805, 1.f);
        }
            break;
        default:
            break;
    }
    
    self.ratingNumberLabel.textColor = textColor;
}

- (void)setUserIdForIcon:(NSString *)userIdForIcon {
    __weak typeof(self) weakSelf = self;
    [[FirebaseManager sharedManager] getIconUserWithUserId:userIdForIcon withCompletionBlock:^(NSData *date) {
        weakSelf.iconImage.contentMode = UIViewContentModeScaleAspectFill;
        weakSelf.iconImage.image = [UIImage imageWithData:date];
    }];
}

#pragma mark - Private

- (void)setupView {
    self.containerView.layer.cornerRadius = ILS_CornerRadius;
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.borderWidth = 1.f;
    self.containerView.layer.borderColor = getColorFromHex(0xF4F4F4, 1.f).CGColor;
    
    self.iconImage.layer.cornerRadius = CGRectGetHeight(self.iconImage.bounds) / 2.f;
    self.iconImage.clipsToBounds = YES;
    self.iconImage.layer.borderColor = AppSupportClass.mainColor.CGColor;
    self.iconImage.layer.borderWidth = 1.f;
}

@end
