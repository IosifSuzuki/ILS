//
//  MapRatingViewController.m
//  ILS
//
//  Created by admin on 30.05.2020.
//  Copyright © 2020 admin. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "AppSupportClass.h"

#import "MapRatingViewController.h"

#import "MapRatingPresenter.h"

#import "LoaderView.h"

@interface MapRatingViewController () <MapRatingDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *focustToUkraineBarButtonItem;

@property (assign, nonatomic) BOOL firstAppear;

@property (strong, nonatomic) MapRatingPresenter *presenter;

@end

@implementation MapRatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.firstAppear = YES;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self focusToUkraineMap];
}

#pragma mark - Private

- (void)setupController {
    self.presenter = [[MapRatingPresenter alloc] initWithDelegate:self];
    self.title = self.presenter.titleText;
    
    self.navigationItem.rightBarButtonItem = self.focustToUkraineBarButtonItem;
    
    [self.mapView registerClass:[MKMarkerAnnotationView class] forAnnotationViewWithReuseIdentifier:MKMapViewDefaultAnnotationViewReuseIdentifier];
}

- (void)focusToUkraineMap {
    [self.mapView setVisibleMapRect:self.presenter.ukraineRect animated:YES];
}

#pragma mark - MKMapViewDelegate

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    if (!fullyRendered) {
        return;
    }
    if (self.firstAppear) {
        self.firstAppear = NO;
        [self focusToUkraineMap];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:MKMapViewDefaultAnnotationViewReuseIdentifier];
    annotationView.canShowCallout = YES;
    annotationView.titleVisibility = MKFeatureVisibilityHidden;
    annotationView.animatesWhenAdded = YES;
    
    UIImageView *pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    pinImageView.contentMode = UIViewContentModeCenter;
    pinImageView.layer.cornerRadius = CGRectGetHeight(pinImageView.bounds) / 2.f;
    pinImageView.clipsToBounds = YES;
    pinImageView.layer.borderWidth = 2.f;
    pinImageView.layer.borderColor = AppSupportClass.mainColor.CGColor;
    pinImageView.image = [UIImage systemImageNamed:@"person"];
    annotationView.leftCalloutAccessoryView = pinImageView;
    
    [self.presenter userIconFor:annotation withCompletionBlock:^(NSData * data) {
        if (data) {
            pinImageView.image = [UIImage imageWithData:data];
            pinImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
    }];
    
    return annotationView;
}

#pragma mark - Action

- (IBAction)tapToFocusToUkraine:(UIBarButtonItem *)sender {
    [self focusToUkraineMap];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - MapRatingDelegate

- (void)startAnimation{
    [[LoaderView sharedInstance] startAnimationFromView:self.view];
}

- (void)stopAnimation {
    [[LoaderView sharedInstance] stopAnimation];
}

- (void)addAnotation:(NSArray<id<MKAnnotation>> *)annotations {
    [self.mapView addAnnotations:annotations];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

#pragma mark - Override

- (BOOL)showMenuBarButtonItem {
    return NO;
}

- (BOOL)allowRotation {
    return YES;
}

@end
