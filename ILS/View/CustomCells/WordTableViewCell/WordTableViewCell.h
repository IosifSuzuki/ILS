//
//  WordTableViewCell.h
//  ILS
//
//  Created by admin on 10.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WordTableViewCell : UITableViewCell

@property (weak, class, readonly, nonatomic) NSString *identifierWordTableViewCell;
@property (assign, nonatomic) BOOL needTrain;

- (void)setDataToWord:(NSString *)wordText translatedWord:(NSString *)translatedWordText withAddedDate:(NSString *)dateText;

@end

NS_ASSUME_NONNULL_END
