//
//  AppDelegate.m
//  assistant
//
//  Created by ALEX on 2014/4/24.
//  Copyright (c) 2014年 miiitech. All rights reserved.
//
#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif


#import "AppDelegate.h"
#import "ADVTheme.h"

#import "NGTestTabBarController.h"
#import "RESideMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "AyiWellcomeViewController.h"
#import "SetProfileViewController.h"

static AppDelegate *sharedDelegate;

@implementation AppDelegate

@synthesize window = _window;
@synthesize hostReach       = _hostReach;                   //判斷網路是否可用
@synthesize internetReach   = _internetReach;               //判斷網路是否可用
@synthesize wifiReach       = _wifiReach;                   //判斷wifi網路是否可用
@synthesize networkStatus;
@synthesize filterDistance  = _filterDistance;
@synthesize currentLocation = _currentLocation;


#pragma mark - 接收用戶設定的搜尋半徑。
- (void)setFilterDistance:(CLLocationAccuracy)aFilterDistance {
	_filterDistance = aFilterDistance;
    
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setDouble:_filterDistance forKey:defaultsFilterDistanceKey];
	[userDefaults synchronize];
    
	// Notify the app of the filterDistance change:
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:_filterDistance] forKey:kPAWFilterDistanceKey];
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:kPAWFilterDistanceChangeNotification object:nil userInfo:userInfo];
	});
}

#pragma mark - 接收用戶當前經緯度資訊。
- (void)setCurrentLocation:(CLLocation *)aCurrentLocation {
	_currentLocation = aCurrentLocation;
    
	// Notify the app of the location change:
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:_currentLocation forKey:kPAWLocationKey];
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:kPAWLocationChangeNotification object:nil userInfo:userInfo];
	});
}

+ (NSInteger)OSVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

#pragma mark - app一開始執行及未開啓情況下接收推播訊息，app在背景運行的情況下
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // ****************************************************************************
    // Parse initialization
    // [Parse setApplicationId:@"APPLICATION_ID" clientKey:@"CLIENT_KEY"];
    //
    // Make sure to update your URL scheme to match this facebook id. It should be "fbFACEBOOK_APP_ID" where FACEBOOK_APP_ID is your Facebook app's id.
    // You may set one up at https://developers.facebook.com/apps
    // [PFFacebookUtils initializeWithApplicationId:@"FACEBOOK_APP_ID"];
    // ****************************************************************************
    
    [Parse setApplicationId:@"jQApO3abx7F3qf1htx9ZTnoP8bjjclY64g8DWtkS"
                  clientKey:@"0a9phtoy1RN0tRjBQIMMOQzkpBJTEDdIwRUlsrp1"];
    [PFFacebookUtils initializeFacebook];
    [PFTwitterUtils initializeWithConsumerKey:@"XRHzv2XCnOD4CpjNwbmdjjxpV"
                               consumerSecret:@"K0CyoMPKkyQSva1WseNxCFbyBDkWFb52ALNielz16qh0cLA48r"];
    
    
    
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

    // Grab values from NSUserDefaults:
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // Desired search radius:
	if ([userDefaults doubleForKey:defaultsFilterDistanceKey]) {
		// use the ivar instead of self.accuracy to avoid an unnecessary write to NAND on launch.
		_filterDistance = [userDefaults doubleForKey:defaultsFilterDistanceKey];
	} else {
		// if we have no accuracy in defaults, set it to 1000 feet.
		self.filterDistance = 1000 * kPAWFeetToMeters;
	}
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    //推播機制之代碼。 自定義應用程序啟動後覆蓋點。
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    if (application.applicationIconBadgeNumber != 0) {
        NSLog(@"install 1");
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveInBackground];
    }
    
    //如果當前用戶已經登入，直接跳過WelcomeView，來到GoogleMap
    if (![PFUser currentUser]) {
        
    }else{
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UINavigationController *mapView = (UINavigationController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"mapNavigation"];
        self.window.rootViewController = mapView;
        [self.window makeKeyAndVisible];
    }
    
    [self handlePushUserInfo:launchOptions];
    
    // Override point for customization after application launch.
    return YES;
}

#pragma mark - 一般開啓狀態的時候，收到的推播訊息
//可直接使用 [userInfo objectForKey:@"aps"] 获取推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //    [[NSNotificationCenter defaultCenter] postNotificationName:PAPAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:userInfo];
    
    if (application.applicationIconBadgeNumber != 0) {
        //未讀通知數量歸零
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveEventually];
    }
    
    //因為開啓狀態時，
    [self handlePush:userInfo];
}

// ****************************************************************************
// 應用程序切換方法，以支持Facebook單點登錄
// ****************************************************************************
// Facebook oauth callback
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [FBAppCall handleOpenURL:url sourceApplication:nil withSession:[PFFacebookUtils session]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

#pragma mark - 推播用到DeviceToken。
/*
 *啟用的條件，需要在接收推播的ViewController加入
 *[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeSound];
 */

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [PFPush storeDeviceToken:deviceToken];
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
    NSLog(@"install 2");
    
    //    [[PFInstallation currentInstallation] addUniqueObject:@"" forKey:kPAPInstallationChannelsKey];
    if ([PFUser currentUser]) {
        // Make sure they are subscribed to their private push channel
        NSString *privateChannelName = [[PFUser currentUser] objectForKey:kPAPUserPrivateChannelKey];
        if (privateChannelName && privateChannelName.length > 0) {
            [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kPAPInstallationChannelsKey];
        }
    }
    [[PFInstallation currentInstallation] saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	if ([error code] != 3010) { // 3010 is for the iPhone Simulator
        NSLog(@"Application failed to register for push notifications: %@", error);
	}
}


#pragma mark - 收到推播訊息，在背景情況或未開啓App收到推播要做的事情
- (void)handlePushUserInfo:(NSDictionary *)userInfo {
    if ([UIApplication sharedApplication].applicationIconBadgeNumber != 0) {
        //未讀通知數量歸零
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    // If the app was launched in response to a push notification, we'll handle the payload here
    // 如果推出推送通知的應用程序，我們將在這裡處理的有效載荷
    NSLog(@"userInfo PayLoad here is = %@", userInfo);
    if (userInfo) {
        //do something
        //PAPAppDelegateApplicationDidReceiveRemoteNotification = @"com.taxiii.adhoc.appDelegate.applicationDidReceiveRemoteNotification"
        [[NSNotificationCenter defaultCenter] postNotificationName:PAPAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:userInfo];
        
        if ([PFUser currentUser]) {
            // if the push notification payload references a photo, we will attempt to push this view controller into view
            NSString *passengerId = [userInfo objectForKey:@"fu"];                      //"乘客用戶ID" , key = "fu"
            NSString *type = [userInfo objectForKey:kPAPPushPayloadActivityTypeKey];    //有兩種，請求接送、答應接送
            
            if ([type isEqualToString:kPAPPushPayloadActivitySendPlzKey]) {
                //乘客請求接送，司機端要顯示Alert 讓司機搶單。
                NSLog(@"self.window.rootViewController = %@", self.window.rootViewController);
                
            }else if ([type isEqualToString:kPAPPushPayloadActivityTakeUpKey]){
                //司機答應接送
                NSLog(@"self.window.rootViewController = %@", self.window.rootViewController);
            }
        }
    }
}

#pragma mark - 收到推播訊息，在前景運行中的App收到推播要做的事情
- (void)handlePush:(NSDictionary *)launchOptions{
    if ([UIApplication sharedApplication].applicationIconBadgeNumber != 0) {
        //未讀通知數量歸零
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    // If the app was launched in response to a push notification, we'll handle the payload here
    // 如果推出推送通知的應用程序，我們將在這裡處理的有效載荷
    NSLog(@"launchOptions PayLoad here is = %@", launchOptions);
    
    if (launchOptions) {
        //do something
        //PAPAppDelegateApplicationDidReceiveRemoteNotification = @"com.taxiii.adhoc.appDelegate.applicationDidReceiveRemoteNotification"
        [[NSNotificationCenter defaultCenter] postNotificationName:PAPAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:launchOptions];
        
        if ([PFUser currentUser]) {
            // if the push notification payload references a photo, we will attempt to push this view controller into view
            NSString *passengerId;
            NSString *driverUserId;
            if ([launchOptions objectForKey:@"pu"]) {
                passengerId = [launchOptions objectForKey:@"pu"];                      //"乘客用戶ID" , key = "fu"
            }else if ([launchOptions objectForKey:@"du"]){
                driverUserId = [launchOptions objectForKey:@"du"];                     //"司機用戶ID" , key = "du"
            }
            
            NSString *type = [launchOptions objectForKey:kPAPPushPayloadActivityTypeKey];    //有兩種，請求接送、答應接送
            
            if ([type isEqualToString:kPAPPushPayloadActivitySendPlzKey]) {
                //乘客請求接送，司機端要顯示Alert 讓司機搶單。
                
                
                UINavigationController *navi = (UINavigationController *)self.window.rootViewController;
                
                NSLog(@"self.window.rootViewController 2 = %@, pu = %@", navi.viewControllers.lastObject, passengerId);
                
//                if ([navi.viewControllers.lastObject isKindOfClass:[GoogleMapViewController class]]) {
//                    GoogleMapViewController *googleMap = navi.viewControllers.lastObject;
//                    [googleMap setDetailItem:passengerId];
//                    [googleMap getSendPlzAlert];
//                }
                
                
            }else if ([type isEqualToString:kPAPPushPayloadActivityTakeUpKey]){
                //司機答應接送
                UINavigationController *navi = (UINavigationController *)self.window.rootViewController;
                NSLog(@"self.window.rootViewController 21 = %@", self.window.rootViewController);
//                if ([navi.viewControllers.lastObject isKindOfClass:[GoogleMapViewController class]]) {
//                    GoogleMapViewController *googleMap = navi.viewControllers.lastObject;
//                    [googleMap setDetailItem:driverUserId];
//                    [googleMap getTakeOutAlert:driverUserId];
//                }
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    //發送時，該應用程序將要由積極轉移到非活動狀態。這可能會發生某些類型的暫時中斷的（例如呼入電話呼叫或SMS消息），或者當用戶退出應用程序和它開始過渡到背景狀態。
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //使用這個方法來暫停正在進行的任務，禁用定時器，並踩下油門，OpenGL ES的幀速率。遊戲應該使用這個方法來暫停遊戲。
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    //使用這個方法來釋放共享資源，保存用戶數據，無效計時器，並儲存足夠的應用程序狀態信息到應用程序恢復的情況下其目前的狀態是後終止。
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //如果你的應用程序支持後台運行，這種方法被稱為代替applicationWillTerminate：當用戶退出。
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [currentUser setObject:@NO forKey:kPAPUserIsReadLocationKey];
        
        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [ACL setPublicReadAccess:YES];
        currentUser.ACL = ACL;
        
        [currentUser saveEventually:^(BOOL succeeded, NSError *error) {
            
        }];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //調用從背景到非活動狀態的轉變的一部分，在這裡您可以撤消許多就進入背景的變化。
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //重新啟動已暫停（或尚未開始），而應用程序是無效的任何任務。如果應用程序是以前的背景下，選擇性地刷新用戶界面。
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        NSLog(@"install 3");
        [[PFInstallation currentInstallation] saveEventually];
    }
    
    // Clears out all notifications from Notification Center.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 0;
    
    // Handle an interruption during the authorization flow, such as the user clicking the home button.
    //授權流程，如點擊home鍵，用戶在處理中斷。
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // 當應用程序即將終止調用。如果適當的保存數據。另請參閱applicationDidEnterBackground：
}

#pragma mark - setupAppearance 自定樣式
- (void)setupAppearance {
    
}

#pragma mark - monitorReachability 偵測網路是否正常運作
- (void)monitorReachability {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostname:@"api.parse.com"];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}

#pragma mark - 網路訊號改變
//Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification* )note {
    Reachability *curReach = (Reachability *)[note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NSLog(@"Reachability changed: %@", curReach);
    networkStatus = [curReach currentReachabilityStatus];
    
    /*
     有網路情況下，重新載入物件的方法
     */
    //    if ([self isParseReachable] && [PFUser currentUser] && self.paphomeViewController.objects.count == 0) {
    //        // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
    //        // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
    //        [self.paphomeViewController loadObjects];
    //    }
}

#pragma mark - isParseReachable
- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}
#pragma mark - presentWelcomeViewControllerAnimated
- (void)presentWelcomeViewControllerAnimated:(BOOL)animated {
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AyiWellcomeViewController *welcomeVC = (AyiWellcomeViewController *)[storybord instantiateViewControllerWithIdentifier:@"welcome"];
    self.window.rootViewController = welcomeVC;
}
#pragma mark - presentWelcomeViewController
- (void)presentWelcomeViewController {
    [self presentWelcomeViewControllerAnimated:YES];
}

#pragma mark - 第一次登入轉場至會員第一次設定頁
- (void)presentFirstSignInViewController{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SetProfileViewController *firstSign = (SetProfileViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"setProfile"];
    firstSign.navigationItem.leftBarButtonItem = nil;
    self.window.rootViewController = firstSign;
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

- (BOOL)handleActionURL:(NSURL *)url {
    if ([[url host] isEqualToString:kPAPLaunchURLHostTakePicture]) {
        if ([PFUser currentUser]) {
            //偵測到拍照動作，就轉場至Ask畫面的拍照按鈕
            /*
             這裡原先的拍照按鈕剛好等於tabBar的中間鈕，所以現在就暫時取消。
             return [self.tabBarController shouldPresentPhotoCaptureController];
             */
        }
    }
    return NO;
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
							
//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//}


//#pragma mark - presentWelcomeViewControllerAnimated
//- (void)presentWelcomeViewControllerAnimated:(BOOL)animated {
//    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
////    AyiWellcomeViewController *welcomeVC = (AyiWellcomeViewController *)[storybord instantiateViewControllerWithIdentifier:@"welcome"];
////    self.window.rootViewController = welcomeVC;
//}
//#pragma mark - presentWelcomeViewController
//- (void)presentWelcomeViewController {
//    [self presentWelcomeViewControllerAnimated:YES];
//}
//
//#pragma mark - 第一次登入轉場至會員第一次設定頁
//- (void)presentFirstSignInViewController{
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
////    SetProfileViewController *firstSign = (SetProfileViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"setProfile"];
////    firstSign.navigationItem.leftBarButtonItem = nil;
////    self.window.rootViewController = firstSign;
//    [self.window makeKeyAndVisible];
//}
//
//#pragma mark - 轉場至Google Map
//- (void)presentGoogleMapController {
//    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
//    UINavigationController *googleMap = (UINavigationController *)[storybord instantiateViewControllerWithIdentifier:@"mapNavigation"];
//    self.window.rootViewController = googleMap;
//    [self.window makeKeyAndVisible];
//}
//
//#pragma mark - 登出
//- (void)logOut{
//    // clear cache
//    [[CMCache sharedCache] clear];
//    
//    // clear NSUserDefaults
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsCacheFacebookFriendsKey];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    NSLog(@"install 4");
//    [[PFInstallation currentInstallation] setObject:@[@""] forKey:kPAPInstallationChannelsKey];
//    [[PFInstallation currentInstallation] removeObjectForKey:kPAPInstallationUserKey];
//    [[PFInstallation currentInstallation] removeObjectForKey:@"channels"];
//    [[PFInstallation currentInstallation] removeObjectForKey:@"deviceToken"];
//    [[PFInstallation currentInstallation] saveInBackground];
//    
//    // Clear all caches
//    [PFQuery clearAllCachedResults];
//    
//    //要把用戶名稱刪除
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults removeObjectForKey:kCMUserNameString];
//    [userDefaults removeObjectForKey:@"mediumImage"];
//    [userDefaults removeObjectForKey:@"smallRoundedImage"];
//    [userDefaults synchronize];
//    [PFUser logOut];
//    
//    [self presentWelcomeViewController];
//}




@end
