//
//  ImaggaAPIManager.m
//  ILS
//
//  Created by admin on 28.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ImaggaAPIManager.h"

#import "WordModel.h"

static NSString *const API_AUTHORIZATION_KEY = @"YWNjX2M2NTYyNGVkZDg2OWFmOTo2MzQyOTRiZWFmYWRlYjUwZmU1Y2VlMjE4ZWVjZjdlMg==";

@interface ImaggaAPIManager()

@property (strong, nonatomic) NSString *recognizeImageTemplateURL;

@end

@implementation ImaggaAPIManager

- (instancetype)init {
    if (self = [super init]) {
        [self setupManager];
    }
    
    return self;
}

#pragma mark - Private

- (void)setupManager {
    self.recognizeImageTemplateURL = @"https://api.imagga.com/v2/tags?image_url=%@&language=en,uk";
}


#pragma mark - Public

+ (instancetype)sharedManager {
    static ImaggaAPIManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImaggaAPIManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)purposeWordsFromImage:(NSString *)imageURL withCompletionBlock:(void (^)(NSArray<WordModel *> * _Nullable ))completionBlock {
    NSString *urlString = [NSString stringWithFormat:self.recognizeImageTemplateURL, [imageURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURL *urlRequest = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlRequest
         cachePolicy:NSURLRequestUseProtocolCachePolicy
         timeoutInterval:40.0];
    [request setHTTPMethod:@"GET"];
    NSString *authStr = [NSString stringWithFormat:@"%@", API_AUTHORIZATION_KEY];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", authStr];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completionBlock(nil);
        } else {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@",responseDictionary);
            
            NSArray *array = [[responseDictionary objectForKey:@"result"] objectForKey:@"tags"];
            NSMutableArray<WordModel *> *result = [NSMutableArray array];
            
            for (NSDictionary *wordDictionary in array) {
                NSDictionary *detailWordDictionary = [wordDictionary objectForKey:@"tag"];
                [result addObject:[WordModel modelWithIdWord:[detailWordDictionary objectForKey:@"en"] wordText:[detailWordDictionary objectForKey:@"en"] translatedWordText:[detailWordDictionary objectForKey:@"uk"] withSoundName:@"nil" withDelta:[[NSDate date] timeIntervalSinceReferenceDate] withStartLearn:[[NSDate date] timeIntervalSinceReferenceDate] withXPositive:0 withXNegative:0]];
            }
            
            completionBlock([result copy]);

        }
        
    }] resume];
}

@end
