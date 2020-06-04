//
//  FirebaseManager.h
//  ILS
//
//  Created by admin on 03.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@class WordModel;
@class UserModel;
@class ArticleModel;
@class StatisticWordModel;
@interface FirebaseManager : NSObject

@property (assign, class, readonly, nonatomic) NSInteger maxSentences;

+ (instancetype)sharedManager;

- (void)configure;
- (void)createUserWithEmail:(NSString *)email password:(NSString *)password nickname:(NSString *)nickname completionSuccerBlock:(void (^)(BOOL)) completionBlock;
- (void)getBestUsersWithTotalsBalls:(BOOL)flag withCompletionBlock:(void (^)(NSArray<UserModel *>*))completionBlock;
- (void)getBestUserFromRegion:(NSString *)region withCompletionBlock:(void (^)(UserModel *))completionBlock;
- (void)signInUserWithEmail:(NSString *)email password:(NSString *)password completionSuccerBlock:(void (^)(BOOL)) completionBlock;
- (void)signInUserWithGoogleFromController:(id)presenterVC completionSuccerBlock:(void (^)(BOOL))completionBlock;


- (void)updateWord:(WordModel *)wordModel toUserId:(NSString *)userId withCompletionBlock:(void(^)(void))completionBlock;
- (void)addWord:(WordModel *)wordModel toUserId:(NSString *)userId withCompletionBlock:(void(^)(NSArray<StatisticWordModel *> *))completionBlock;
- (void)getWordsWithUserId:(NSString *)userId withCompletionBlock:(void (^)(NSArray<WordModel *> *))completionBlock;
- (void)updateIconUserForUserId:(NSString *)userId with:(NSData *)data withCompletionBlock:(void (^)(BOOL))completionBlock;
- (void)getIconUserWithUserId:(NSString *)userId withCompletionBlock:(void (^)(NSData *))completionBlock;
- (void)updateNickUserWithId:(NSString *)userId nickName:(NSString *)nickname withCompletionBlock:(void (^)(BOOL))completionBlock;
- (void)updateRegionUserWithId:(NSString *)userId region:(NSString *)region withCompletionBlock:(void (^)(BOOL))completionBlock;
- (void)updateBallsWithId:(NSString *)userId balls:(NSInteger)balls withCompletionBlock:(void (^)(BOOL))completionBlock;

- (void)getSentencesWithCompletionBlock:(void (^)(NSArray<NSString *> *))sentences;

- (void)uploadImageWithUserId:(NSString *)userId withData:(NSData *)data withCompletionBlock:(void (^)(NSURL * _Nullable fullPathToImage))completionBlock;

- (void)getArticlesWithCompletionBlock:(void (^)(NSArray<ArticleModel *> *))completionBlock;

@end

NS_ASSUME_NONNULL_END
