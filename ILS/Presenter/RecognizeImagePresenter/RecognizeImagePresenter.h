//
//  RecognizeImagePresenter.h
//  ILS
//
//  Created by admin on 28.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RecognizeImageDelegate <NSObject>

- (void)startAnimation;
- (void)stopAnimation;
- (void)makeSegue;

@end

@protocol ProposeWordsDelegate;
@interface RecognizeImagePresenter : NSObject

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSData *selectedImageData;
@property (strong, nonatomic) NSString *selectOptionForPhtotoSourceText;
@property (strong, nonatomic) NSString *cameraText;
@property (strong, nonatomic) NSString *photoLibraryText;
@property (strong, nonatomic) NSString *backText;

@property (weak, class, readonly, nonatomic) NSString *kSegueString;

- (instancetype)initWithDelegate:(id<RecognizeImageDelegate>)delegate;
- (void)makeRequest;
- (void)prepareMakeSegueWithDelegate:(id<ProposeWordsDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
