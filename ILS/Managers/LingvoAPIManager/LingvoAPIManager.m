//
//  LingvoAPIManager.m
//  ILS
//
//  Created by admin on 17.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LingvoAPIManager.h"

#import "WordModel.h"

static NSString *const LingoAPI_KEY = @"NTExNWY4YmQtYmExNC00YTJiLTgwZWItODUwZjZkNmMxYjQ3OmM1MDc4MTVhN2U3ZDQ2OTU4YzlkNWRlMWNmM2UyNzA2";

@interface LingvoAPIManager()

@property (strong, nonatomic) NSString *authorizationKey;
@property (weak, nonatomic, readonly) NSURL *URLAuthenticate;

@end

@implementation LingvoAPIManager

- (instancetype)init {
    if (self = [super init]) {
        //empty
    }
    
    return self;
}


#pragma mark - Public

+ (instancetype)sharedManager {
    static LingvoAPIManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LingvoAPIManager alloc] init];
    });
    
    return sharedInstance;
}

- (NSURL *)URLAuthenticate {
    return [[NSURL alloc] initWithString:@"https://developers.lingvolive.com/api/v1.1/authenticate"];
}

- (NSURL *)URLTranslateWord:(NSString *)word {
    return [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://developers.lingvolive.com/api/v1/Minicard?text=%@&srcLang=1033&dstLang=1058&isCaseSensitive=false", word]];
}

- (void)beginAuthenticateService:(void (^)(BOOL))completionBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.URLAuthenticate
         cachePolicy:NSURLRequestUseProtocolCachePolicy
         timeoutInterval:40.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"Basic %@", LingoAPI_KEY] forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completionBlock(NO);
        } else {
            self.authorizationKey = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            completionBlock(YES);
        }
        
    }] resume];
}

- (void)translateWord:(NSString *)word withCompletionBlock:(void (^)(WordModel * _Nullable))completionBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self URLTranslateWord:word]  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.authorizationKey] forHTTPHeaderField:@"Authorization"];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil);
        } else {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *translatedWord = [[responseDictionary objectForKey:@"Translation"] objectForKey:@"Translation"];
            NSString *sondName = [[responseDictionary objectForKey:@"Translation"] objectForKey:@"SoundName"];
            
            WordModel *wordModel = [WordModel modelWithIdWord:word wordText:word translatedWordText:translatedWord withSoundName:sondName withDelta:[[NSDate date] timeIntervalSinceReferenceDate] withStartLearn:[[NSDate date] timeIntervalSinceReferenceDate] withXPositive:0 withXNegative:0];
            
            completionBlock(wordModel);
        }
    }] resume];
}

@end
