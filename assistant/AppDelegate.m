//
//  AppDelegate.m
//  assistant
//
//  Created by ALEX on 2014/4/24.
//  Copyright (c) 2014年 miiitech. All rights reserved.
//

#import "AppDelegate.h"
#import "ADVTheme.h"

#import "NGTestTabBarController.h"
#import "RESideMenu.h"

#import <QuartzCore/QuartzCore.h>

static AppDelegate *sharedDelegate;

@implementation AppDelegate

+ (NSInteger)OSVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [ADVThemeManager customizeAppAppearance];
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        [self setupTabbariPad];
        
        self.window.rootViewController = self.mainVC;
        self.window.backgroundColor = [UIColor blackColor];
        [self.window makeKeyAndVisible];
    } else {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        if (![[NSUserDefaults standardUserDefaults] valueForKey:@"NavigationType"]) {
            [[NSUserDefaults standardUserDefaults] setInteger:ADVNavigationTypeTab forKey:@"NavigationType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        self.navigationType = [[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"];
        if (_navigationType == ADVNavigationTypeTab) {
            [self setupTabbar];
        } else {
            [self setupMenu];
        }
        
        self.window.rootViewController = self.mainVC;
        self.window.backgroundColor = [UIColor blackColor];
        [self.window makeKeyAndVisible];
    }

    
    // Override point for customization after application launch.
    return YES;
}

-(void)styleNavigationBarWithColor:(UIColor*)color {
    
    UIImage* menubarImage = [AppDelegate createWhiteGradientImageWithSize:CGSizeMake(320, 64)];
    
    //UIImage* menubarImage = [self createSolidColorImageWithColor:color andSize:CGSizeMake(320, 64)];
    
    UINavigationBar* navAppeareance = [UINavigationBar appearance];
    
    [navAppeareance setBackgroundImage:menubarImage forBarMetrics:UIBarMetricsDefault];
}

+ (UIImage*)createSolidColorImageWithColor:(UIColor*)color andSize:(CGSize)size {
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)createGradientImageFromColor:(UIColor *)startColor toColor:(UIColor *)endColor withSize:(CGSize)size {
    
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    drawLinearGradient(currentContext, fillRect, startColor.CGColor, endColor.CGColor);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)createWhiteGradientImageWithSize:(CGSize)size {
    
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    UIColor * whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    UIColor* whiteTransparent = [UIColor colorWithWhite:1.0f alpha:0.2f];
    drawLinearGradient(currentContext, fillRect, whiteColor.CGColor, whiteTransparent.CGColor);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)setupTabbar {
    if (!self.tabbarVC) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
        UINavigationController *navMag1 = [mainStoryboard instantiateViewControllerWithIdentifier:@"NearbyNav"];
        UINavigationController *navMag2 = [mainStoryboard instantiateViewControllerWithIdentifier:@"TasksNav"];
        UINavigationController *navMag3 = [mainStoryboard instantiateViewControllerWithIdentifier:@"CallHelpNav"];
        UINavigationController *navMag4 = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProfileNav"];
        UINavigationController *navMag5 = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsNav"];
        
        
        navMag1.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"附近"];
        navMag2.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"任務"];
        navMag3.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"呼叫幫手"];
        navMag4.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"個人檔案"];
        navMag5.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"設定"];
        
        
        NSArray *viewControllers = [NSArray arrayWithObjects:navMag1, navMag2, navMag3, navMag4,navMag5, nil];
        
        NGTabBarController *tabBarController = [[NGTestTabBarController alloc] initWithDelegate:self];
        
        tabBarController.viewControllers = viewControllers;
        
        [AppDelegate tabBarController:tabBarController setupItemsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        self.tabbarVC = (NGTestTabBarController *)tabBarController;
    }
    
    self.mainVC = _tabbarVC;
}

- (void)setupTabbariPad {
    if (!self.tabbarVC) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad"
                                                                 bundle: nil];
        UINavigationController *navMag1 = [mainStoryboard instantiateViewControllerWithIdentifier:@"NearbyNav"];
        UINavigationController *navMag2 = [mainStoryboard instantiateViewControllerWithIdentifier:@"TasksNav"];
        UINavigationController *navMag3 = [mainStoryboard instantiateViewControllerWithIdentifier:@"CallHelpNav"];
        UINavigationController *navMag4 = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProfileNav"];
        UINavigationController *navMag5 = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsNav"];
        navMag1.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"附近"];
        navMag2.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"任務"];
        navMag3.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"呼叫幫手"];
        navMag4.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"個人檔案"];
        navMag5.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"設定"];
        
        
        NSArray *viewControllers = [NSArray arrayWithObjects:navMag1, navMag2, navMag3, navMag4,navMag5, nil];
        
        NGTabBarController *tabBarController = [[NGTestTabBarController alloc] initWithDelegate:self];
        
        tabBarController.viewControllers = viewControllers;
        
        [AppDelegate tabBarController:tabBarController setupItemsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        self.tabbarVC = (NGTestTabBarController *)tabBarController;
    }
    
    self.mainVC = _tabbarVC;
}


////////////////////////////////////////////////////////////////////////
#pragma mark - NGTabBarControllerDelegate
////////////////////////////////////////////////////////////////////////

- (CGSize)tabBarController:(NGTabBarController *)tabBarController
sizeOfItemForViewController:(UIViewController *)viewController
                   atIndex:(NSUInteger)index
                  position:(NGTabBarPosition)position {
    if (NGTabBarIsVertical(position)) {
        return CGSizeMake(150.0f, 45.f);
    } else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            return (CGSize){72, 45};
        }
        
        
        if (UIInterfaceOrientationIsPortrait(viewController.interfaceOrientation)) {
            return CGSizeMake(viewController.view.frame.size.width / tabBarController.viewControllers.count, 45.f);
        } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
                   && [UIScreen mainScreen].bounds.size.height == 568)
        {
            return CGSizeMake(142, 45.f);
        } else {
            return CGSizeMake(viewController.view.frame.size.width / tabBarController.viewControllers.count, 45.f);
        }
    }
}



- (void)setupMenu {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                             bundle: nil];
    self.mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"NearbyNav"];
}


- (void)resetAfterTypeChange:(BOOL)cancel {
    UINavigationController *settingsNav;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"] == ADVNavigationTypeTab) {
        [self setupTabbar];
        _tabbarVC.selectedIndex = 4;
        settingsNav = [_tabbarVC.viewControllers lastObject];
        [settingsNav popToRootViewControllerAnimated:NO];
    } else {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                                 bundle: nil];
        settingsNav = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsNav"];
        self.mainVC = settingsNav;
    }
    
    self.window.rootViewController = self.mainVC;
    
    if (!cancel) {
        UIViewController *settingsVC = settingsNav.viewControllers[0];
        [settingsVC performSegueWithIdentifier:@"selectNavigationTypeNoAnim" sender:settingsVC];
    }
}

+ (AppDelegate *)sharedDelegate {
    if (!sharedDelegate) {
        sharedDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return sharedDelegate;
}


+ (void)customizeTabsForController:(UITabBarController *)tabVC {
    NSArray *items = tabVC.tabBar.items;
    for (int idx = 0; idx < items.count; idx++) {
        UITabBarItem *item = items[idx];
        [ADVThemeManager customizeTabBarItem:item forTab:((SSThemeTab)idx)];
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:0.37f green:0.38f blue:0.42f alpha:1.00f], UITextAttributeTextColor,
      [UIFont fontWithName:@"OpenSans" size:9], UITextAttributeFont,
      nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIFont fontWithName:@"OpenSans" size:9], UITextAttributeFont,
      nil]
                                             forState:UIControlStateSelected];
}


+ (void)tabBarController:(NGTabBarController *)tabBarC setupItemsForOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSArray *VCs = tabBarC.viewControllers;
    for (int idx = 0; idx < VCs.count; idx++) {
        UIViewController *VC = VCs[idx];
        
        NSString *imageName = [NSString stringWithFormat:@"tabbar-tab%d", idx+1];
        NSString *selectedImageName = [NSString stringWithFormat:@"tabbar-tab%d", idx+1];
        UIFont *font = nil;
        CGFloat imageOffset = 0;
        //        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        //            imageName = [imageName stringByAppendingString:@"-landscape"];
        //            selectedImageName = [selectedImageName stringByAppendingString:@"-landscape"];
        //            font = [UIFont boldSystemFontOfSize:6];
        //            imageOffset = 2;
        //        }
        VC.ng_tabBarItem.image = [UIImage imageNamed:imageName];
        VC.ng_tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
        
        VC.ng_tabBarItem.titleColor = [UIColor colorWithRed:0.80f green:0.85f blue:0.89f alpha:1.00f];
        VC.ng_tabBarItem.selectedTitleColor = [UIColor whiteColor];
        
        VC.ng_tabBarItem.titleFont = font;
        VC.ng_tabBarItem.imageOffset = imageOffset;
    }
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - presentWelcomeViewControllerAnimated
- (void)presentWelcomeViewControllerAnimated:(BOOL)animated {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
//    AyiWellcomeViewController *welcomeVC = (AyiWellcomeViewController *)[storybord instantiateViewControllerWithIdentifier:@"welcome"];
//    self.window.rootViewController = welcomeVC;
}
#pragma mark - presentWelcomeViewController
- (void)presentWelcomeViewController {
    [self presentWelcomeViewControllerAnimated:YES];
}

#pragma mark - 第一次登入轉場至會員第一次設定頁
- (void)presentFirstSignInViewController{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
//    SetProfileViewController *firstSign = (SetProfileViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"setProfile"];
//    firstSign.navigationItem.leftBarButtonItem = nil;
//    self.window.rootViewController = firstSign;
    [self.window makeKeyAndVisible];
}

#pragma mark - 轉場至Google Map
- (void)presentGoogleMapController {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    UINavigationController *googleMap = (UINavigationController *)[storybord instantiateViewControllerWithIdentifier:@"mapNavigation"];
    self.window.rootViewController = googleMap;
    [self.window makeKeyAndVisible];
}

#pragma mark - 登出
- (void)logOut{
    // clear cache
    [[CMCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"install 4");
    [[PFInstallation currentInstallation] setObject:@[@""] forKey:kPAPInstallationChannelsKey];
    [[PFInstallation currentInstallation] removeObjectForKey:kPAPInstallationUserKey];
    [[PFInstallation currentInstallation] removeObjectForKey:@"channels"];
    [[PFInstallation currentInstallation] removeObjectForKey:@"deviceToken"];
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    //要把用戶名稱刪除
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kCMUserNameString];
    [userDefaults removeObjectForKey:@"mediumImage"];
    [userDefaults removeObjectForKey:@"smallRoundedImage"];
    [userDefaults synchronize];
    [PFUser logOut];
    
    [self presentWelcomeViewController];
}

@end
