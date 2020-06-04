//
//  SignUpPresenter.h
//  ILS
//
//  Created by admin on 03.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SignUpViewControllerDelegate <NSObject>

- (void)showAlertWithTitle:(NSString *)title description:(NSString *)description withCompletionBlock:(void(^_Nullable)(void))completionBlock;

@end

@interface SignUpPresenter : NSObject

@property (strong, nonatomic) NSString *errorFillFormText;
@property (strong, nonatomic) NSString *errorEmailValidationText;
@property (strong, nonatomic) NSString *errorEmailValidationFormatText;
@property (strong, nonatomic) NSString *errorPasswordValidationFormatText;
@property (strong, nonatomic) NSString *errorPasswordIsNotEqualText;
@property (strong, nonatomic) NSString *errorNicknameValidationText;
@property (strong, nonatomic) NSString *signUpWasSuccessfulText;
@property (strong, nonatomic) NSString *errorSignUpText;
@property (strong, nonatomic) NSString *errorSignUpDetailText;
@property (strong, nonatomic) NSString *okText;

- (instancetype)initWithDelegate:(id<SignUpViewControllerDelegate>)delegate;

- (BOOL)validateEmail:(NSString *)email password:(NSString *)password repeatPassword:(NSString *)repeatPassword  nickname:(NSString *)nickname;

@end

NS_ASSUME_NONNULL_END
