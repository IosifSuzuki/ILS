//
//  WordViewController.m
//  ILS
//
//  Created by admin on 12.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import "WordViewController.h"

@interface WordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

@end

@implementation WordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupController];
}

#pragma mark - Private

- (void)setupController {
    self.wordLabel.text = self.presenterWordText;
}

#pragma mark - Accessor

- (void)setPresenterWordText:(NSString *)presenterWordText {
    _presenterWordText = presenterWordText;
    
    self.wordLabel.text = self.presenterWordText;
}

@end
