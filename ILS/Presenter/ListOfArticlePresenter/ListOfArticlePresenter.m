//
//  ListOfArticlePresenter.m
//  ILS
//
//  Created by admin on 31.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ListOfArticlePresenter.h"

#import "CoreDataManager.h"

#import "ArticleModel.h"

static NSString *const kListOfArticlePresenterTitle = @"title";

@interface ListOfArticlePresenter()

@property (weak, nonatomic) id<ListOfArticleDelegate> delegate;

@property (strong, nonatomic) NSArray<ArticleModel *> *dataSource;

@end

@implementation ListOfArticlePresenter

- (instancetype)initWithDelegate:(id<ListOfArticleDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        
        [self setupPresenter];
    }
    return self;
}

#pragma mark - Private

- (void)setupPresenter {
    [self fetchScreenData];
}

- (void)fetchScreenData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ListOfArticle" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.titleText = [data objectForKey:kListOfArticlePresenterTitle];
}


#pragma mark - Public

- (void)fetchData {
    self.dataSource = [[CoreDataManager sharedManager] getAllArticleModels];
    
    [self.delegate reloadData];
}

- (NSInteger)getCountOfArticles {
    return self.dataSource.count;
}

- (NSString *)getTitleAtIndex:(NSInteger)index {
    return [self.dataSource objectAtIndex:index].title;
}

- (void)preparePresenterForWebView:(id<WebDelegate>)webViewController atIndex:(NSInteger)index {
    webViewController.presenter = [[WebPresenter alloc] initWithDelegate:webViewController];
    webViewController.presenter.articleModel = [self.dataSource objectAtIndex:index];
}

#pragma mark - Accessor

+ (NSString *)cellIdentifier {
    return @"ArticleCellIdentifier";
}

@end
