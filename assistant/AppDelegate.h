//
//  AppDelegate.h
//  assistant
//
//  Created by ALEX on 2014/4/24.
//  Copyright (c) 2014年 miiitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGTabBarController.h"
#import "MenuViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Reachability.h>                    //判斷網路是否可用

@class NGTestTabBarController;
@class PaperFoldNavigationController;


typedef enum {
    ADVNavigationTypeTab = 0,
    ADVNavigationTypeMenu
} ADVNavigationType;


@interface AppDelegate : UIResponder <UIApplicationDelegate, NGTabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NGTestTabBarController *tabbarVC;
@property (strong, nonatomic) PaperFoldNavigationController *foldVC;
@property (strong, nonatomic) MenuViewController *menuVC;
@property (strong, nonatomic) UIViewController *mainVC;
@property (assign, nonatomic) ADVNavigationType navigationType;

@property (nonatomic, assign) CLLocationAccuracy filterDistance;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) Reachability *hostReach;                                  //判斷網路是否可用
@property (nonatomic, strong) Reachability *internetReach;                              //判斷網路是否可用
@property (nonatomic, strong) Reachability *wifiReach;                                  //判斷wifi網路是否可用
@property (nonatomic, readonly) int networkStatus;

+ (NSInteger)OSVersion;
+ (AppDelegate *)sharedDelegate;
+ (UIImage*)createWhiteGradientImageWithSize:(CGSize)size;
+ (UIImage*)createSolidColorImageWithColor:(UIColor*)color andSize:(CGSize)size;
+ (UIImage*)createGradientImageFromColor:(UIColor *)startColor toColor:(UIColor *)endColor withSize:(CGSize)size;
+ (void)customizeTabsForController:(UITabBarController *)tabVC;
+ (void)tabBarController:(NGTabBarController *)tabBarC setupItemsForOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)resetAfterTypeChange:(BOOL)cancel;

- (BOOL)isParseReachable;
- (void)presentWelcomeViewController;
- (void)presentWelcomeViewControllerAnimated:(BOOL)animated;
- (void)presentFirstSignInViewController;

- (void)presentGoogleMapController;
- (void)logOut;

- (BOOL)handleActionURL:(NSURL *)url;                                                   //偵測動作URL_照相機跟相簿偵測

@end
