//
//  WordTableViewCell.m
//  ILS
//
//  Created by admin on 10.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "WordTableViewCell.h"
#import "AppSupportClass.h"

@interface WordTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *translatedWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *addedWordDateLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;

@end

@implementation WordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
}

#pragma mark - Accessor

+ (NSString *)identifierWordTableViewCell {
    return NSStringFromClass([WordTableViewCell class]);
}

- (void)setNeedTrain:(BOOL)needTrain {
    _needTrain = needTrain;
    
    self.infoImageView.hidden = needTrain;
}

#pragma mark - Private

- (void)setupView {
    self.containerView.subviews.firstObject.layer.cornerRadius = 6.f;
    self.containerView.subviews.firstObject.clipsToBounds = YES;
    
    self.tintColor = AppSupportClass.declineColor;
}

#pragma mark - Public

- (void)setDataToWord:(NSString *)wordText translatedWord:(NSString *)translatedWordText withAddedDate:(NSString *)dateText {
    self.wordLabel.text = wordText;
    self.translatedWordLabel.text = [translatedWordText stringByReplacingOccurrencesOfString:@"; " withString:@";\n"];
    self.addedWordDateLabel.text = dateText;
}

@end
