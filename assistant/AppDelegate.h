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

+ (NSInteger)OSVersion;
+ (AppDelegate *)sharedDelegate;
+ (UIImage*)createWhiteGradientImageWithSize:(CGSize)size;
+ (UIImage*)createSolidColorImageWithColor:(UIColor*)color andSize:(CGSize)size;
+ (UIImage*)createGradientImageFromColor:(UIColor *)startColor toColor:(UIColor *)endColor withSize:(CGSize)size;
+ (void)customizeTabsForController:(UITabBarController *)tabVC;
+ (void)tabBarController:(NGTabBarController *)tabBarC setupItemsForOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)resetAfterTypeChange:(BOOL)cancel;


- (void)presentGoogleMapController;
- (void)logOut;

@end
