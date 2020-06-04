//
//  RecognizeImagePresenter.m
//  ILS
//
//  Created by admin on 28.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "RecognizeImagePresenter.h"
#import "ProposeWordsPresenter.h"

#import "UserModel.h"
#import "WordModel.h"

#import "ImaggaAPIManager.h"
#import "FirebaseManager.h"
#import "CoreDataManager.h"

static NSString *const kRecognizeImagePresenterTitle = @"title";
static NSString *const kRecognizeImagePresenterOprionDescription = @"optionMessage";
static NSString *const kRecognizeImagePresenterCameraSource = @"cameraSource";
static NSString *const kRecognizeImagePresenterPhotoLibrarySource = @"photoLibrarySource";
static NSString *const kRecognizeImagePresenterBack = @"back";


@interface RecognizeImagePresenter()

@property (weak, nonatomic) id<RecognizeImageDelegate> delegate;
@property (strong, nonatomic) UserModel *userModel;

@property (strong, nonatomic) NSArray<WordModel *> *proposeWords;

@end

@implementation RecognizeImagePresenter

- (instancetype)initWithDelegate:(id<RecognizeImageDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        
        [self setupPresenter];
    }
    return self;
}

#pragma mark - Private

- (void)setupPresenter {
    [self fetchScreenData];
    [self fetchData];
}

- (void)fetchScreenData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RecognizeImage" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.titleText = [data objectForKey:kRecognizeImagePresenterTitle];
    self.selectOptionForPhtotoSourceText = [data objectForKey:kRecognizeImagePresenterOprionDescription];
    self.photoLibraryText = [data objectForKey:kRecognizeImagePresenterPhotoLibrarySource];
    self.cameraText = [data objectForKey:kRecognizeImagePresenterCameraSource];
    self.backText = [data objectForKey:kRecognizeImagePresenterBack];
}

- (void)fetchData {
    self.userModel = [[CoreDataManager sharedManager] userModel];
}

#pragma mark - Public

- (void)makeRequest {
    [self.delegate startAnimation];
    dispatch_group_t group = dispatch_group_create();
    __block NSURL *fullPathToImage = nil;
    dispatch_group_enter(group);
    [[FirebaseManager sharedManager] uploadImageWithUserId:self.userModel.userId withData:self.selectedImageData withCompletionBlock:^(NSURL * _Nullable localFullPathToImage) {
        fullPathToImage = localFullPathToImage;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[ImaggaAPIManager sharedManager] purposeWordsFromImage:fullPathToImage.absoluteString withCompletionBlock:^(NSArray<WordModel *> *wordsModels) {
            if (wordsModels) {
                self.proposeWords = [wordsModels copy];
            } else {
                self.proposeWords = [NSArray array];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate stopAnimation];
                [self.delegate makeSegue];
            });
        }];
    });
}

- (void)prepareMakeSegueWithDelegate:(id<ProposeWordsDelegate>)delegate {
    ProposeWordsPresenter *presenter = [[ProposeWordsPresenter alloc] initWithDelegate:delegate];
    presenter.proposeWords = [self.proposeWords copy];
    delegate.presenter = presenter;
}

#pragma mark - Accessor

+ (NSString *)kSegueString {
    return @"kProposeWordsTableViewControllerSegue";
}

@end
