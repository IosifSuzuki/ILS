//
//  FirebaseManager.m
//  ILS
//
//  Created by admin on 03.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "FirebaseManager.h"
#import "LearningManager.h"

#import "AppDelegate.h"

#import "WordModel.h"
#import "ArticleModel.h"
#import "StatisticWordModel.h"

#import <CoreData/CoreData.h>
#import "UserModel.h"

@import Firebase;
@import FirebaseFirestore;
@import FirebaseDatabase;
@import GoogleSignIn;

@interface FirebaseManager() <GIDSignInDelegate>

@property (strong, nonatomic) FIRDatabaseReference *databaseRef;
@property (strong, nonatomic) FIRStorage *storage;

@property (copy, nonatomic, nullable) void (^signInWithGoogleCompletionBlock)(BOOL);

@end

@implementation FirebaseManager

- (instancetype)init {
    if (self = [super init]) {
        //empty
    }
    
    return self;
}

#pragma mark - Private

- (void)saveUserInfo:(NSDictionary *)userInfo {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    NSError *deleteError = nil;
    NSPersistentContainer *persistenContainer = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer;
    [persistenContainer.persistentStoreCoordinator executeRequest:delete withContext:persistenContainer.viewContext error:&deleteError];
    
    
    NSManagedObject *userCoreData = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:persistenContainer.viewContext];
    [userCoreData setValue:[userInfo objectForKey:@"email"] forKey:@"email"];
    [userCoreData setValue:[userInfo objectForKey:@"nickname"] forKey:@"nickname"];
    [userCoreData setValue:[userInfo objectForKey:@"balls"] forKey:@"balls"];
    [userCoreData setValue:[userInfo objectForKey:@"id"] forKey:@"id"];
    [userCoreData setValue:[userInfo objectForKey:@"region"] forKey:@"region"];
    [userCoreData setValue:[userInfo objectForKey:@"todayBalls"] forKey:@"todayBalls"];
    [userCoreData setValue:[userInfo objectForKey:@"day1agoBalls"] forKey:@"day1agoBalls"];
    [userCoreData setValue:[userInfo objectForKey:@"day2agoBalls"] forKey:@"day2agoBalls"];
    [userCoreData setValue:[userInfo objectForKey:@"day3agoBalls"] forKey:@"day3agoBalls"];
    [userCoreData setValue:[userInfo objectForKey:@"day4agoBalls"] forKey:@"day4agoBalls"];
    [userCoreData setValue:[NSDate dateWithTimeIntervalSinceReferenceDate:[[userInfo objectForKey:@"lastWorkout"] doubleValue]] forKey:@"lastWorkout"];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
}

- (NSDictionary *)normalizationUserData:(NSDictionary *)userDictionary {
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[[userDictionary objectForKey:@"lastWorkout"] floatValue]];
    NSDate *todayDate = [NSDate date];
    NSInteger curentDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:todayDate];
    NSInteger lastWorkoutDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:date];
    NSInteger leftDay = curentDay - lastWorkoutDay;
    
    NSInteger day4agoBalls = [[userDictionary objectForKey:@"day4agoBalls"] integerValue];
    NSInteger day3agoBalls = [[userDictionary objectForKey:@"day3agoBalls"] integerValue];
    NSInteger day2agoBalls = [[userDictionary objectForKey:@"day2agoBalls"] integerValue];
    NSInteger day1agoBalls = [[userDictionary objectForKey:@"day1agoBalls"] integerValue];
    NSInteger todayBalls = [[userDictionary objectForKey:@"todayBalls"] integerValue];
    NSInteger balls[5] = {
        day4agoBalls,
        day3agoBalls,
        day2agoBalls,
        day1agoBalls,
        todayBalls,
    };
    
    for (NSInteger i = 0; i < leftDay; i++) {
        for (NSInteger j = 4; j > 0; j--) {
            balls[j] = balls[j - 1];
        }
        balls[0] = 0;
    }
    
    return @{
        @"id": [userDictionary objectForKey:@"id"],
        @"email": [userDictionary objectForKey:@"email"],
        @"password": [userDictionary objectForKey:@"password"],
        @"nickname": [userDictionary objectForKey:@"nickname"],
        @"balls": [userDictionary objectForKey:@"balls"],
        @"region": [userDictionary objectForKey:@"region"],
        @"todayBalls": @(todayBalls),
        @"day1agoBalls": @(day1agoBalls),
        @"day2agoBalls": @(day2agoBalls),
        @"day3agoBalls": @(day3agoBalls),
        @"day4agoBalls": @(day4agoBalls),
        @"lastWorkout": [userDictionary objectForKey:@"lastWorkout"],
    };
}

#pragma mark - Accessor

+ (NSInteger)maxSentences {
    return 5;
}

#pragma mark - Public

+ (instancetype)sharedManager {
    static FirebaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FirebaseManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)configure {
    [FIRApp configure];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GoogleService-Info" ofType:@"plist"];
    NSDictionary *googleServiceDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    [GIDSignIn sharedInstance].clientID = [googleServiceDictionary objectForKey:@"CLIENT_ID"];
    [GIDSignIn sharedInstance].delegate = self;
    
    self.databaseRef = [[FIRDatabase database] reference];
    self.storage = [FIRStorage storage];
}

- (void)createUserWithEmail:(NSString *)email password:(NSString *)password nickname:(NSString *)nickname completionSuccerBlock:(void (^)(BOOL)) completionBlock {
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (!error) {
            [[[self.databaseRef child:@"users"] child:authResult.user.uid] setValue: @{
                @"id": authResult.user.uid,
                @"email": email,
                @"password": @"-2",
                @"nickname": nickname,
                @"balls": @(0),
                @"region": @"nil",
                @"todayBalls": @(0),
                @"day1agoBalls": @(0),
                @"day2agoBalls": @(0),
                @"day3agoBalls": @(0),
                @"day4agoBalls": @(0),
                @"lastWorkout": @([[NSDate date] timeIntervalSinceReferenceDate]),
            } withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                completionBlock(YES);
            }];
        } else {
            completionBlock(NO);
        }
    }];
}

- (void)getBestUsersWithTotalsBalls:(BOOL)flag withCompletionBlock:(void (^)(NSArray<UserModel *>*))completionBlock {
    NSString *orderByChildQuery = [NSString stringWithFormat:@"%@", flag ? @"balls" : @"todayBalls"];
    [[[[self.databaseRef child:@"users"] queryOrderedByChild:orderByChildQuery] queryLimitedToFirst:100] observeSingleEventOfType:FIRDataEventTypeValue andPreviousSiblingKeyWithBlock:^(FIRDataSnapshot * _Nonnull snapshot, NSString * _Nullable prevKey) {
        NSMutableArray *bestUsers = [NSMutableArray array];
        for(FIRDataSnapshot *userInfoSnapShot in snapshot.children) {
            UserModel *userModel = [UserModel createUserModelWithDictionary:(NSDictionary *)userInfoSnapShot.value];
            [bestUsers addObject:userModel];
        }
        completionBlock([[bestUsers reverseObjectEnumerator] allObjects]);
    }];
}

- (void)getBestUserFromRegion:(NSString *)region withCompletionBlock:(void (^)(UserModel *))completionBlock {
    [[[[self.databaseRef child:@"users"] queryOrderedByChild:@"region"] queryEqualToValue:region] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot.value isEqual:[NSNull null]]) {
            completionBlock(nil);
        } else {
            UserModel *userModel;
            for (FIRDataSnapshot *userSnapshot in snapshot.children) {
                UserModel *currentUserModel = [UserModel createUserModelWithDictionary:(NSDictionary *)userSnapshot.value];
                if (!userModel || userModel.balls < currentUserModel.balls) {
                    userModel = currentUserModel;
                }
            }
            completionBlock(userModel);
        }
    }];
}


- (void)updateNickUserWithId:(NSString *)userId nickName:(NSString *)nickname withCompletionBlock:(void (^)(BOOL))completionBlock {
    [[[[self.databaseRef child:@"users"] child:userId] child:@"nickname"] setValue:nickname withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            completionBlock(NO);
        } else {
            completionBlock(YES);
        }
    }];
}

- (void)addWord:(WordModel *)wordModel toUserId:(NSString *)userId withCompletionBlock:(void(^)(NSArray<StatisticWordModel *> *))completionBlock{
    if (wordModel.translatedWordText) {
        NSString *soundName = wordModel.soundName ? wordModel.soundName : @"nil";
        
        dispatch_group_t group = dispatch_group_create();
        __block NSArray<StatisticWordModel *> *statisticWordModelsForWord = [NSArray array];
        
        dispatch_group_enter(group);
        [[[[self.databaseRef child:@"words"] child:userId] child:wordModel.idWord] setValue:@{
            @"id": wordModel.idWord,
            @"word": wordModel.wordText,
            @"translatedWord": wordModel.translatedWordText,
            @"soundName": soundName,
            @"xPositive": @(0),
            @"xNegative": @(0),
            @"delta": @([[NSDate date] timeIntervalSinceReferenceDate]),
            @"startLearn": @([[NSDate date] timeIntervalSinceReferenceDate]),
        } withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [[[[self.databaseRef child:@"statisticWords"] queryOrderedByChild:@"word"] queryEqualToValue:wordModel.wordText] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if ([[NSNull null] isEqual:snapshot.value] || ((NSArray *)snapshot.children.allObjects).count != LearningManager.levels) {
                for (NSInteger index = 0; index < LearningManager.levels; index++) {
                    NSDictionary *statisticWordModelDicrionary = @{
                        @"word": wordModel.wordText,
                        @"level": @(index),
                        @"xPositive": @(0),
                        @"xNegative": @(0),
                    };
                    ;
                    NSMutableArray<StatisticWordModel *> *mutableStatisticWordModelsForWord = [NSMutableArray arrayWithArray:statisticWordModelsForWord];
                    StatisticWordModel *statisticWordModel = [StatisticWordModel createStatisticWordModelWithDictionary:statisticWordModelDicrionary];
                    [mutableStatisticWordModelsForWord addObject:statisticWordModel];
                    statisticWordModelsForWord = [mutableStatisticWordModelsForWord copy];
                    dispatch_group_enter(group);
                    [[[self.databaseRef child:@"statisticWords"] childByAutoId] setValue:statisticWordModelDicrionary withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                        dispatch_group_leave(group);
                    }];
                }
            }
            dispatch_group_leave(group);
        }];
        
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            completionBlock(statisticWordModelsForWord);
        });
        
    } else {
        completionBlock(nil);
    }
}

- (void)getWordsWithUserId:(NSString *)userId withCompletionBlock:(void (^)(NSArray<WordModel *> *))completionBlock {
    [[[self.databaseRef child:@"words"] child:userId] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        dispatch_group_t group = dispatch_group_create();
        __block NSMutableArray *wordsModel = [NSMutableArray arrayWithCapacity:[snapshot.children.allObjects count]];
        for (FIRDataSnapshot *wordSnapshot in snapshot.children) {
            dispatch_group_enter(group);
            __block WordModel *wordModel = [WordModel modelWithWordModelDictionary:(NSDictionary *)wordSnapshot.value];
            [wordsModel addObject:wordModel];
            [[[[self.databaseRef child:@"statisticWords"] queryOrderedByChild:@"word"] queryEqualToValue:wordModel.wordText] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSMutableArray *mutableStatisticWordModels = [NSMutableArray arrayWithCapacity:LearningManager.levels];
                NSLog(@"%@", snapshot.value);
                for (FIRDataSnapshot *statisticWordShanpshot in snapshot.children) {
                    StatisticWordModel *statisticWordModel = [StatisticWordModel createStatisticWordModelWithDictionary:statisticWordShanpshot.value];
                    [mutableStatisticWordModels addObject:statisticWordModel];
                }
                wordModel.statisticWordModels = [mutableStatisticWordModels copy];
                dispatch_group_leave(group);
            }];
        }
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            completionBlock([wordsModel copy]);
        });
    }];
}

- (void)updateWord:(WordModel *)wordModel toUserId:(NSString *)userId withCompletionBlock:(void(^)(void))completionBlock {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [[[[self.databaseRef child:@"words"] child:userId] child:wordModel.idWord] setValue:@{
        @"id": wordModel.idWord,
        @"word": wordModel.wordText,
        @"translatedWord": wordModel.translatedWordText,
        @"soundName": wordModel.soundName,
        @"xPositive": @(0),
        @"xNegative": @(0),
        @"delta": @([wordModel.delta timeIntervalSinceReferenceDate]),
        @"startLearn": @([[NSDate date] timeIntervalSinceReferenceDate])
    } withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        dispatch_group_leave(group);
    }];
    
    
    dispatch_group_enter(group);
    [[[[self.databaseRef child:@"statisticWords"] queryOrderedByChild:@"word"] queryEqualToValue:wordModel.wordText] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        for (FIRDataSnapshot *statisticWord in snapshot.children) {
            NSInteger level = [[(NSDictionary *)statisticWord.value objectForKey:@"level"] intValue];
            NSString *childKey = statisticWord.key;
            StatisticWordModel *statisticWordModel;
            for (StatisticWordModel *tmpStatisticWordModel in wordModel.statisticWordModels) {
                if (tmpStatisticWordModel.level == level) {
                    statisticWordModel = tmpStatisticWordModel;
                    break;
                }
            }
            NSDictionary *statisticWordModelDicrionary = @{
                @"word": wordModel.wordText,
                @"level": @(level),
                @"xPositive": @(statisticWordModel.positiveX),
                @"xNegative": @(statisticWordModel.negativeX),
            };
            dispatch_group_enter(group);
            [[[self.databaseRef child:@"statisticWords"] child:childKey] setValue:statisticWordModelDicrionary withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                dispatch_group_leave(group);
            }];
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        completionBlock();
    });
}

- (void)updateRegionUserWithId:(NSString *)userId region:(NSString *)region withCompletionBlock:(void (^)(BOOL))completionBlock {
    [[[[self.databaseRef child:@"users"] child:userId]child:@"region"] setValue:region withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            completionBlock(NO);
        } else {
            completionBlock(YES);
        }
    }];
}

- (void)updateBallsWithId:(NSString *)userId balls:(NSInteger)balls withCompletionBlock:(void (^)(BOOL))completionBlock {
    [[[self.databaseRef child:@"users"] child:userId] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableDictionary *userDictionary = [NSMutableDictionary dictionaryWithDictionary:[self normalizationUserData:snapshot.value]];
        
        NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[[userDictionary objectForKey:@"lastWorkout"] doubleValue]];
        NSDate *todayDate = [NSDate date];
        NSInteger curentDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:todayDate];
        NSInteger lastWorkoutDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:date];
        
        NSInteger leftDay = curentDay - lastWorkoutDay;
        
        NSInteger day4agoBalls = [[userDictionary objectForKey:@"day4agoBalls"] integerValue];
        NSInteger day3agoBalls = [[userDictionary objectForKey:@"day3agoBalls"] integerValue];
        NSInteger day2agoBalls = [[userDictionary objectForKey:@"day2agoBalls"] integerValue];
        NSInteger day1agoBalls = [[userDictionary objectForKey:@"day1agoBalls"] integerValue];
        NSInteger todayBalls = [[userDictionary objectForKey:@"todayBalls"] integerValue];
        NSInteger arrBalls[5] = {
            day4agoBalls,
            day3agoBalls,
            day2agoBalls,
            day1agoBalls,
            todayBalls,
        };
        
        for (NSInteger i = 0; i < leftDay; i++) {
            for (NSInteger j = 0; j < 4; j++) {
                arrBalls[j] = arrBalls[j + 1];
            }
            arrBalls[4] = 0;
        }

        [userDictionary setValue:@(arrBalls[4] + balls) forKey:@"todayBalls"];
        [userDictionary setValue:@(arrBalls[3]) forKey:@"day1agoBalls"];
        [userDictionary setValue:@(arrBalls[2]) forKey:@"day2agoBalls"];
        [userDictionary setValue:@(arrBalls[1]) forKey:@"day3agoBalls"];
        [userDictionary setValue:@(arrBalls[0]) forKey:@"day4agoBalls"];
        
        [userDictionary setValue:@([[userDictionary objectForKey:@"balls"] integerValue] + balls) forKey:@"balls"];
        [userDictionary setValue:@([[NSDate date] timeIntervalSinceReferenceDate]) forKey:@"lastWorkout"];
        
        [[[self.databaseRef child:@"users"] child:userId] setValue:[userDictionary copy] withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            completionBlock(YES);
        }];
    }];
}

- (void)signInUserWithEmail:(NSString *)email password:(NSString *)password completionSuccerBlock:(void (^)(BOOL)) completionBlock {
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (!error) {
            [[[self.databaseRef child:@"users"] child:authResult.user.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSDictionary *userInfo = (NSDictionary *)snapshot.value;
                [self saveUserInfo:userInfo];
                completionBlock(YES);
            }];
        } else {
            completionBlock(NO);
        }
    }];
}

- (void)signInUserWithGoogleFromController:(id)presenterVC completionSuccerBlock:(void (^)(BOOL))completionBlock {
    [GIDSignIn sharedInstance].presentingViewController = presenterVC;
    self.signInWithGoogleCompletionBlock = completionBlock;
    
    [[GIDSignIn sharedInstance] signIn];
}

- (void)updateIconUserForUserId:(NSString *)userId with:(NSData *)data withCompletionBlock:(void (^)(BOOL))completionBlock {
    FIRStorageReference *userIconRef = [[[self.storage reference] child:@"userIcon"] child:userId];
    
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    metadata.contentType = @"image/jpeg";
    
    FIRStorageUploadTask *uploadTask = [userIconRef putData:data metadata:metadata completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if (error) {
            completionBlock(NO);
        } else {
            completionBlock(YES);
        }
    }];
    
    [uploadTask resume];
}

- (void)uploadImageWithUserId:(NSString *)userId withData:(NSData *)data withCompletionBlock:(void (^)(NSURL * _Nullable fullPathToImage))completionBlock {
    FIRStorageReference *userImageRef = [[[self.storage reference] child:@"userImage"] child:userId];
    
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    metadata.contentType = @"image/jpeg";
    __block NSURL *path;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    FIRStorageUploadTask *uploadTask = [userImageRef putData:data metadata:metadata completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil);
        } else {
            [userImageRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                path = URL;
                dispatch_group_leave(group);
            }];
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        completionBlock(path);
    });
    
    [uploadTask resume];
}

- (void)getIconUserWithUserId:(NSString *)userId withCompletionBlock:(void (^)(NSData *))completionBlock {
    FIRStorageReference *userIconRef = [[[self.storage reference] child:@"userIcon"] child:userId];
    
    [userIconRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            completionBlock(data);
        }
    }];
}

- (void)getSentencesWithCompletionBlock:(void (^)(NSArray<NSString *> *))blockWithSentences {
    [[[[self.databaseRef child:@"sentences"] queryOrderedByChild:@"completed"] queryLimitedToFirst:5] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray *sentences = (NSArray *)snapshot.value;
        NSMutableArray<NSString *> *sentencesText = [NSMutableArray arrayWithCapacity:FirebaseManager.maxSentences];
        for (NSDictionary *sentence in sentences) {
            if (![sentence isKindOfClass:[NSNull class]]) {
                NSInteger index = [sentences indexOfObject:sentence];
                NSInteger completed = [[sentence objectForKey:@"completed"] integerValue];
                NSString *text = [sentence objectForKey:@"text"];
                [[[[self.databaseRef child:@"sentences"] child:[NSString stringWithFormat:@"%ld", index]] child:@"completed"] setValue:@(completed + 1)];
                [sentencesText addObject:text];
            }
        }
        blockWithSentences(sentencesText);
    }];
}

- (void)getArticlesWithCompletionBlock:(void (^)(NSArray<ArticleModel *> *))completionBlock {
    [[self.databaseRef child:@"articles"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray *articlesArray = (NSArray *)snapshot.value;
        NSMutableArray<ArticleModel *> *mutableArticleModels = [NSMutableArray arrayWithCapacity:articlesArray.count];
        for (NSDictionary *articleDictionary in articlesArray) {
            NSString *title = [articleDictionary objectForKey:@"title"];
            NSString *content = [articleDictionary objectForKey:@"content"];
            ArticleModel *articleModel = [ArticleModel createArticleModelWithTitle:title content:content];
            [mutableArticleModels addObject:articleModel];
        }
        completionBlock([mutableArticleModels copy]);
    }];
}

#pragma mark - GIDSignInDelegate

- (BOOL)application:(nonnull UIApplication *)application
            openURL:(nonnull NSURL *)url
            options:(nonnull NSDictionary<NSString *, id> *)options {
  return [[GIDSignIn sharedInstance] handleURL:url];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error == nil) {
//        GIDAuthentication *authentication = user.authentication;
//        FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
//                                                                         accessToken:authentication.accessToken];
        [[[self.databaseRef child:@"users"] child:user.userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (![snapshot exists]) {
                NSDictionary *userInfo = @{
                    @"id": user.userID,
                    @"email": user.profile.email,
                    @"password": @"-1",
                    @"nickname": user.profile.name,
                    @"balls": @(0),
                    @"region": @"nil",
                    @"todayBalls": @(0),
                    @"day1agoBalls": @(0),
                    @"day2agoBalls": @(0),
                    @"day3agoBalls": @(0),
                    @"day4agoBalls": @(0),
                    @"lastWorkout": @([[NSDate date] timeIntervalSinceReferenceDate]),
                };
                
                [[[self.databaseRef child:@"users"] child:user.userID] setValue: userInfo
                                                            withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    [self saveUserInfo:userInfo];
                    
                    self.signInWithGoogleCompletionBlock(YES);
                }];
            } else {
                NSDictionary *userInfo = (NSDictionary *)snapshot.value;
                [self saveUserInfo:userInfo];
                self.signInWithGoogleCompletionBlock(YES);
            }
        }];
    } else {
        if (![[error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The user canceled the sign-in flow."]) {
            self.signInWithGoogleCompletionBlock(NO);
        }
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
  // Perform any operations when the user disconnects from app here.
  // ...
}

@end
