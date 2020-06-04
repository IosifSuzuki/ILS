//
//  SignInPresenter.h
//  ILS
//
//  Created by admin on 03.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SignInProtocol <NSObject>


@end

@interface SignInPresenter : NSObject

@property (class, readonly, nonatomic) NSString *templateForRememberLogin;
@property (strong, nonatomic) NSString *yesText;
@property (strong, nonatomic) NSString *noText;
@property (strong, nonatomic) NSString *okText;
@property (strong, nonatomic) NSString *errorGredentialsText;
@property (strong, nonatomic) NSString *errorAuthorization;

- (instancetype)initWithDelegate:(id<SignInProtocol>)delegate;

@end

NS_ASSUME_NONNULL_END
