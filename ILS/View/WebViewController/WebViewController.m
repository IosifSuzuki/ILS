//
//  WebViewController.m
//  ILS
//
//  Created by admin on 31.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//
#import <WebKit/WebKit.h>

#import "WebViewController.h"
#import "LoaderView.h"

@interface WebViewController () <WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupController];
}

#pragma mark - Private

- (void)setupController {
    self.title = self.presenter.titleArticle;
    
    self.webView.scrollView.showsVerticalScrollIndicator =
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.webView.navigationDelegate = self;
    [[LoaderView sharedInstance] startAnimationFromView:self.view];
    [self.webView loadHTMLString:self.presenter.contentArticle baseURL:nil];
}

#pragma mark - MainNavigationControllerDelegate

- (BOOL)showMenuBarButtonItem {
    return NO;
}

- (BOOL)allowRotation {
    return YES;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[LoaderView sharedInstance] stopAnimation];
}

@end
