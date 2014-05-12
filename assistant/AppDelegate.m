//
//  AppDelegate.m
//  assistant
//
//  Created by ALEX on 2014/4/24.
//  Copyright (c) 2014年 miiitech. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
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
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    AyiWellcomeViewController *welcomeVC = (AyiWellcomeViewController *)[storybord instantiateViewControllerWithIdentifier:@"welcome"];
//    self.window.rootViewController = welcomeVC;
}
#pragma mark - presentWelcomeViewController
- (void)presentWelcomeViewController {
    [self presentWelcomeViewControllerAnimated:YES];
}

#pragma mark - 第一次登入轉場至會員第一次設定頁
- (void)presentFirstSignInViewController{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    SetProfileViewController *firstSign = (SetProfileViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"setProfile"];
//    firstSign.navigationItem.leftBarButtonItem = nil;
//    self.window.rootViewController = firstSign;
    [self.window makeKeyAndVisible];
}

#pragma mark - 轉場至Google Map
- (void)presentGoogleMapController {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
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
