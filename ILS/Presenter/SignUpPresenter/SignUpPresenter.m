//
//  SignUpPresenter.m
//  ILS
//
//  Created by admin on 03.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "SignUpPresenter.h"

static NSString *const kSignUpPresenterErrorFillForm = @"errorFillForm";
static NSString *const kSignUpPresenterErrorEmailValidation = @"errorEmailValidation";
static NSString *const kSignUpPresenterErrorEmailValidationFormat = @"errorEmailValidationFormat";
static NSString *const kSignUpPresenterErrorPasswordValidationFormat = @"errorPasswordValidationFormat";
static NSString *const kSignUpPresenterErrorPasswordIsNotEqual = @"errorPasswordIsNotEqual";
static NSString *const kSignUpPresenterErrorNicknameValidation = @"errorNicknameValidation";
static NSString *const kSignUpPresenterSignUpWasSuccessful = @"signUpWasSuccessful";
static NSString *const kSignUpPresenterErrorSignUp = @"errorSignUp";
static NSString *const kSignUpPresenterErrorSignUpDetail = @"errorSignUpDetail";
static NSString *const kSignUpPresenterOkText = @"ok";


@interface SignUpPresenter()

@property (weak, nonatomic) id<SignUpViewControllerDelegate> delegate;

@end

@implementation SignUpPresenter

- (instancetype)initWithDelegate:(id<SignUpViewControllerDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        
        [self setupPresenter];
    }
    
    return self;
}

#pragma mark - Private

- (void)setupPresenter {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SignUp" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    self.errorFillFormText = [data objectForKey:kSignUpPresenterErrorFillForm];
    self.errorEmailValidationText = [data objectForKey:kSignUpPresenterErrorEmailValidation];
    self.errorEmailValidationFormatText = [data objectForKey:kSignUpPresenterErrorEmailValidationFormat];
    self.errorPasswordValidationFormatText = [data objectForKey:kSignUpPresenterErrorPasswordValidationFormat];
    self.errorPasswordIsNotEqualText = [data objectForKey:kSignUpPresenterErrorPasswordIsNotEqual];
    self.errorNicknameValidationText = [data objectForKey:kSignUpPresenterErrorNicknameValidation];
    self.signUpWasSuccessfulText = [data objectForKey:kSignUpPresenterSignUpWasSuccessful];
    self.errorSignUpText = [data objectForKey:kSignUpPresenterErrorSignUp];
    self.errorSignUpDetailText = [data objectForKey:kSignUpPresenterErrorSignUpDetail];
    self.okText = [data objectForKey:kSignUpPresenterOkText];
    
}

- (BOOL)validateText:(NSString *)text withPattern:(NSString *)pattern {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    if ([regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)]) {
        return YES;
    }
    return NO;
}

- (BOOL)validateEmail:(NSString *)emailText {
    NSString *emailPattern = @"^([a-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}@([a-z0-9!#$%&'*+-/=?^_`{|}~]){1,64}\\.([a-z0-9]){2,64}$";
    
    return [self validateText:emailText withPattern:emailPattern];
}

- (BOOL)validatePassword:(NSString *)password {
    NSString *passwordPattern = @"^([a-z0-9!#$%&'*+-/=?^_`{|}~]){8,64}$";
    
    return [self validateText:password withPattern:passwordPattern];
}

- (BOOL)validateNickname:(NSString *)nickname {
    NSString *nicknamePattern = @"^([\\w0-9_]){3,64}$";
    
    return [self validateText:nickname withPattern:nicknamePattern];
}

- (NSInteger)getCountOfLetterWithText:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\D" options:NSRegularExpressionCaseInsensitive error:nil];
    
    return [regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)];
}

#pragma mark - Public

- (BOOL)validateEmail:(NSString *)email password:(NSString *)password repeatPassword:(NSString *)repeatPassword  nickname:(NSString *)nickname {
    
    NSString *titleText = self.errorFillFormText;
    NSString *descriptionText;
    
    if (![self validateEmail:email]) {
        descriptionText = self.errorEmailValidationText;
    } else if (password.length < 8 || [self getCountOfLetterWithText:password] < 4) {
        descriptionText = self.errorEmailValidationFormatText;
    } else if (![self validatePassword:password]) {
        descriptionText = self.errorPasswordValidationFormatText;
    } else if (![password isEqualToString:repeatPassword]) {
        descriptionText = self.errorPasswordIsNotEqualText;
    } else if (![self validateNickname:nickname]) {
       descriptionText = self.errorNicknameValidationText;
    }
    
    if (descriptionText) {
        [self.delegate showAlertWithTitle:titleText description:descriptionText withCompletionBlock:nil];
        return NO;
    }
    return YES ;
}
@end
