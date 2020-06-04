//
//  SignInPresenter.m
//  ILS
//
//  Created by admin on 03.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "SignInPresenter.h"

static NSString *const kSignInPresenterYes = @"yes";
static NSString *const kSignInPresenterNo = @"no";
static NSString *const kSignInPresenterOk = @"ok";
static NSString *const kSignInPresenterErrorCredentials = @"errorCredentials";
static NSString *const kSignInPresenterErrorAuthorization = @"errorAuthorization";

@interface SignInPresenter()

@property (weak, nonatomic) id<SignInProtocol> delegate;

@end

@implementation SignInPresenter

- (instancetype)initWithDelegate:(id<SignInProtocol>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        
        [self setupPresenter];
    }
    
    return self;
}

#pragma mark - Private

- (void)setupPresenter {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SignIn" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.yesText = [data objectForKey:kSignInPresenterYes];
    self.noText = [data objectForKey:kSignInPresenterNo];
    self.okText = [data objectForKey:kSignInPresenterOk];
    self.errorGredentialsText = [data objectForKey:kSignInPresenterErrorCredentials];
    self.errorAuthorization = [data objectForKey:kSignInPresenterErrorAuthorization];
}

- (void)fetchScreenData {
    
}

#pragma mark - Accessor

+ (NSString *)templateForRememberLogin {
    return @"Запам'ятати логін: %@";
}

@end
