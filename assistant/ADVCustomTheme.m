//
//  ADVCustomTheme.m
//  
//
//  Created by Valentin Filip on 7/9/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "ADVCustomTheme.h"
#import "UIImage+iPhone5.h"
#import "AppDelegate.h"
#import "Utils.h"

@implementation ADVCustomTheme

- (UIStatusBarStyle)statusBarStyle {
    return UIStatusBarStyleBlackOpaque;
}

- (UIColor *)mainColor {
    return [UIColor colorWithWhite:0.3 alpha:1.0];
}

- (UIColor *)secondColor {
    return [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
}

- (UIColor *)navigationTextColor {
    return [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
}

- (UIColor *)highlightColor
{
    return [UIColor colorWithRed:0.63f green:0.71f blue:0.78f alpha:1.00f];
}

- (UIColor *)shadowColor
{
    return [UIColor colorWithRed:0.16f green:0.20f blue:0.38f alpha:1.00f];
}

- (UIColor *)highlightShadowColor
{
    return [UIColor colorWithRed:0.16f green:0.20f blue:0.38f alpha:1.00f];
}

- (UIColor *)navigationTextShadowColor {
    return [UIColor whiteColor];
}

- (UIFont *)navigationFont { 
    return [UIFont fontWithName:@"Avenir-Black" size:17.0f];
}

- (UIFont *)barButtonFont {
    return [UIFont fontWithName:@"Avenir-Black" size:15.0f];
}


- (UIFont *)segmentFont {
    return [UIFont fontWithName:@"Avenir-Black" size:13.0f];
}

- (UIColor *)backgroundColor
{
    return [UIColor colorWithWhite:0.85 alpha:1.0];
}

- (UIColor *)baseTintColor
{
    return nil;
}

- (UIColor *)accentTintColor
{
    return nil;
}

- (UIColor *)selectedTabbarItemTintColor
{
    return [UIColor colorWithRed:0.50f green:0.84f blue:0.06f alpha:1.00f];
}

- (UIColor *)switchThumbColor
{
    return [UIColor colorWithRed:0.87f green:0.87f blue:0.89f alpha:1.00f];
}

- (UIColor *)switchOnColor
{
    return [UIColor colorWithRed:0.16f green:0.65f blue:0.51f alpha:1.00f];
}

- (UIColor *)switchTintColor
{
    return [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];;
}

- (CGSize)shadowOffset
{
    return CGSizeMake(0, 0);
}

- (UIImage *)topShadow
{
    return nil;
}

- (UIImage *)bottomShadow
{
    return [UIImage imageNamed:@"bottomShadow"];
}

- (UIImage *)navigationBackgroundForBarMetrics:(UIBarMetrics)metrics
{    
    NSString *name = @"navigationBackground";
    if(![Utils isVersion6AndBelow])
        name = @"navigationBackground-7";
    if (metrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 8.0, 10.0, 8.0)];
    
    CGFloat height = 7 > [AppDelegate OSVersion] ? 45 : 64;
    UIImage *bottomImage = [self viewBackground];
    
    CGSize newSize = CGSizeMake(320, height);
    UIGraphicsBeginImageContext( newSize );
    
    [bottomImage drawInRect:CGRectMake(0, 0, newSize.width, bottomImage.size.height)];
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)navigationBackgroundForIPadAndOrientation:(UIInterfaceOrientation)orientation {
    NSString *name = @"navigationBackgroundRight";
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
    return image;
}

- (UIImage *)barButtonBackgroundForState:(UIControlState)state style:(UIBarButtonItemStyle)style barMetrics:(UIBarMetrics)barMetrics
{
    NSString *name;
    if([Utils isVersion6AndBelow]){
        name = @"barButton";
        if (style == UIBarButtonItemStyleDone) {
            name = [name stringByAppendingString:@"Done"];
        }
        if (barMetrics == UIBarMetricsLandscapePhone) {
            name = [name stringByAppendingString:@"Landscape"];
        }
        if (state == UIControlStateHighlighted) {
            name = [name stringByAppendingString:@"Highlighted"];
        }
    }
    else{
        name = @"barButton-7";
        if (style == UIBarButtonItemStyleDone) {
            name = [name stringByAppendingString:@"Done"];
        }
        if (barMetrics == UIBarMetricsLandscapePhone) {
            name = [name stringByAppendingString:@"Landscape"];
        }
        if (state == UIControlStateSelected) {
            name = [name stringByAppendingString:@"Highlighted"];
        }
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    return image;
}

- (UIImage *)backBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics
{
    NSString *name = @"backButton";
    if(![Utils isVersion6AndBelow])
        name = nil;
    if (barMetrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    return image;
}

- (UIImage *)toolbarBackgroundForBarMetrics:(UIBarMetrics)metrics
{
    NSString *name = @"toolbarBackground";
    if (metrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
    return image;
}

- (UIImage *)searchBackground
{
    return [UIImage imageNamed:@"searchBackground"];
}


- (UIImage *)searchScopeBackground
{
    UIImage *scopeBg = [UIImage imageNamed:@"searchScopeBackground"];
    return scopeBg ? scopeBg : [self searchBackground];
}

- (UIImage *)searchFieldImage
{
    UIImage *image = [UIImage imageNamed:@"searchField"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0)];
    return image;
}

- (UIImage *)searchScopeButtonBackgroundForState:(UIControlState)state
{
    NSString *name = @"searchScopeButton";
    if (state == UIControlStateSelected) {
        name = [name stringByAppendingString:@"Selected"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0)];
    return image;
}

- (UIImage *)searchScopeButtonDivider
{
    return [UIImage imageNamed:@"searchScopeButtonDivider"];
}

- (UIImage *)searchImageForIcon:(UISearchBarIcon)icon state:(UIControlState)state
{
    NSString *name;
    if (icon == UISearchBarIconSearch) {
        name = @"searchIconSearch";
    } else if (icon == UISearchBarIconClear) {
        name = @"searchIconClear";
        if (state == UIControlStateHighlighted) {
            name = [name stringByAppendingString:@"Highlighted"];
        }
    }
    return (name ? [UIImage imageNamed:name] : nil);
}

- (UIImage *)segmentedBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics;
{
    NSString *name = @"segmentedBackground";
    if (barMetrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    if (state == UIControlStateSelected) {
        name = [name stringByAppendingString:@"Selected"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    return image;
}

- (UIImage *)segmentedDividerForBarMetrics:(UIBarMetrics)barMetrics
{
    NSString *name = @"segmentedDivider";
    if (barMetrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 0.0, 10.0, 0.0)];
    return image;
}

- (UIImage *)tableBackground
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return [self tableBackgroundForSize:window.frame.size];
}

- (UIImage *)tableBackgroundForSize:(CGSize)size {
    
    UIImage *image;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kBlurredBackground"]) {
//        image = [UIImage tallImageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"kBlurredBackground"]];
//    } else {
//        UIColor *startColor = [UIColor colorFromNSString:[[NSUserDefaults standardUserDefaults] objectForKey:@"kBlurredGradientStartColor"]];
//        startColor = startColor ? startColor : [UIColor colorWithRed:0.07f green:0.55f blue:0.52f alpha:1.00f];
//        
//        UIColor *endColor = [UIColor colorFromNSString:[[NSUserDefaults standardUserDefaults] objectForKey:@"kBlurredGradientEndColor"]];
//        endColor = endColor ? endColor : [UIColor colorWithRed:0.33f green:0.16f blue:0.80f alpha:1.00f];
//        
//        image = [AppDelegate createGradientImageFromColor:startColor toColor:endColor withSize:size];
//    }

    UIColor *startColor = [UIColor colorWithRed:224.0f/255.0f green:213.0f/255.0f blue:45.0f/255.0f alpha:1.00f];
    
    UIColor *endColor = [UIColor colorWithRed:222.0f/255.0f green:150.0f/255.0f blue:35.0f/255.0f alpha:1.00f];
    
    image = [AppDelegate createGradientImageFromColor:startColor toColor:endColor withSize:size];
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}

- (UIImage *)tableSectionHeaderBackground {
    UIImage *image = [UIImage imageNamed:@"list-section-header-bg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}


- (UIImage *)tableFooterBackground {
    UIImage *image = [UIImage imageNamed:@"list-footer-bg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}

- (UIImage *)gradientImageWithStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor andSize:(CGSize)size {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    NSString *imageName = scale > 1 ? @"background@2x.png" : @"background.png";
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    if (!image || [[NSUserDefaults standardUserDefaults] boolForKey:@"kBlurredGradientNewColors"]) {
//        startColor = startColor ? startColor : [UIColor colorWithRed:0.07f green:0.55f blue:0.52f alpha:1.00f];
//        endColor = endColor ? endColor : [UIColor colorWithRed:0.33f green:0.16f blue:0.80f alpha:1.00f];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:[UIColor stringFromUIColor:startColor] forKey:@"kBlurredGradientStartColor"];
//        [[NSUserDefaults standardUserDefaults] setObject:[UIColor stringFromUIColor:endColor] forKey:@"kBlurredGradientEndColor"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        UIColor *startColor = [UIColor colorWithRed:224.0f/255.0f green:213.0f/255.0f blue:45.0f/255.0f alpha:1.00f];
        
        UIColor *endColor = [UIColor colorWithRed:222.0f/255.0f green:150.0f/255.0f blue:35.0f/255.0f alpha:1.00f];
        
        image = [AppDelegate createGradientImageFromColor:startColor toColor:endColor withSize:size];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kBlurredGradientNewColors"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    } else {
        image = [UIImage imageWithContentsOfFile:filePath];
    }
    
    return image;
}

- (UIImage *)viewBackground
{
    UIWindow *window = [AppDelegate sharedDelegate].window;
    return [self viewBackgroundForSize:window.bounds.size];
}


- (UIImage *)viewBackgroundForSize:(CGSize)size
{
    UIImage *image;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kBlurredBackground"]) {
        image = [UIImage tallImageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"kBlurredBackground"]];
    } else {
        UIColor *startColor = [UIColor colorFromNSString:[[NSUserDefaults standardUserDefaults] objectForKey:@"kBlurredGradientStartColor"]];
        UIColor *endColor = [UIColor colorFromNSString:[[NSUserDefaults standardUserDefaults] objectForKey:@"kBlurredGradientEndColor"]];
        image = [self gradientImageWithStartColor:startColor andEndColor:endColor andSize:size];
    }
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}

- (UIImage *)viewBackgroundPattern
{
    UIImage *image = [UIImage tallImageNamed:@"backgroundMenu"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    return image;
}


- (UIImage *)viewBackgroundTimeline
{
    UIImage *image = [UIImage tallImageNamed:@"background-timeline"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 30, 10, 10)];
    return image;
}

- (UIImage *)switchOnImage
{
    return [[UIImage imageNamed:@"switchOnBackground"]
            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
}

- (UIImage *)switchOffImage
{
    return [[UIImage imageNamed:@"switchOffBackground"]
            resizableImageWithCapInsets:UIEdgeInsetsMake(5, 20, 5, 20)];
}

- (UIImage *)switchOnIcon
{
    return [UIImage imageNamed:@"switchOnIcon"];
}

- (UIImage *)switchOffIcon
{
    return [UIImage imageNamed:@"switchOffIcon"];
}

- (UIImage *)switchTrack
{
    return [UIImage imageNamed:@"switchTrack"];
}

- (UIImage *)switchThumbForState:(UIControlState)state {
    NSString *name = @"switchHandle";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    }
    return [UIImage imageNamed:name];
}

- (UIImage *)sliderThumbForState:(UIControlState)state
{
    NSString *name = @"sliderThumb";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    } else if (state == UIControlStateReserved) {
        name = [name stringByAppendingString:@"-small"];
    }
    return [UIImage imageNamed:name];
}

- (UIImage *)sliderMinTrack
{
    UIImage *image = [UIImage imageNamed:@"sliderMinTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    return image;
}

- (UIImage *)sliderMaxTrack
{
    UIImage *image = [UIImage imageNamed:@"sliderMaxTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    return image;
}

- (UIImage *)sliderMinTrackSmall
{
    UIImage *image = [UIImage imageNamed:@"sliderMinTrack-small"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
    return image;
}

- (UIImage *)sliderMaxTrackSmall
{
    UIImage *image = [UIImage imageNamed:@"sliderMaxTrack-small"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
    return image;
}

- (UIImage *)progressTrackImage
{
    UIImage *image = [UIImage imageNamed:@"progress-segmented-track"];
    return image;
}

- (UIImage *)progressProgressImage
{
    UIImage *image = [UIImage imageNamed:@"progress-segmented-fill"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    return image;
}

- (UIImage *)progressPercentTrackImage
{
    UIImage *image = [UIImage imageNamed:@"progressTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    return image;
}

- (UIImage *)progressPercentProgressImage
{
    UIImage *image = [UIImage imageNamed:@"progressProgress"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    return image;
}

- (UIImage *)progressPercentProgressValueImage {
    UIImage *image = [UIImage imageNamed:@"progressValue"];
    return image;
}

- (UIImage *)stepperBackgroundForState:(UIControlState)state
{
    NSString *name = @"stepperBackground";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    } else if (state == UIControlStateDisabled) {
        name = [name stringByAppendingString:@"Disabled"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 13.0, 0.0, 13.0)];
    return image;
}

- (UIImage *)stepperDividerForState:(UIControlState)state
{
    NSString *name = @"stepperDivider";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    }
    return [UIImage imageNamed:name];
}

- (UIImage *)stepperIncrementImage
{
    return [UIImage imageNamed:@"stepperIncrement"];
}

- (UIImage *)stepperDecrementImage
{
    return [UIImage imageNamed:@"stepperDecrement"];
}

- (UIImage *)buttonBackgroundForState:(UIControlState)state
{
    NSString *name = @"button";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    } else if (state == UIControlStateDisabled) {
        name = [name stringByAppendingString:@"Disabled"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0)];
    return image;
}

- (UIImage *)tabBarBackground
{
    UIImage *bottomImage = [self viewBackground];
    UIImage *image       = [[UIImage imageNamed:@"tabBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    CGSize newSize = CGSizeMake(320, 73);
    UIGraphicsBeginImageContext( newSize );
    
    UIWindow *window = [AppDelegate sharedDelegate].window;
    CGFloat padding;
    if(UIInterfaceOrientationIsLandscape(window.rootViewController.interfaceOrientation)) {
        padding = bottomImage.size.height - (bottomImage.size.height - CGRectGetMaxX(window.frame) + 73);
    } else {
        padding = bottomImage.size.height - (CGRectGetMaxY(window.frame) - bottomImage.size.height + 73);
    }
    [bottomImage drawInRect:CGRectMake(0, -padding, newSize.width, bottomImage.size.height)];
    
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
     
    return newImage;
}

- (UIImage *)tabBarSelectionIndicator
{
    return [UIImage imageNamed:@"tabBarSelectionIndicator"];
}

- (UIImage *)imageForTab:(SSThemeTab)tab
{
    return nil;
}

- (UIImage *)finishedImageForTab:(SSThemeTab)tab selected:(BOOL)selected
{
    NSString *name = nil;
    if (tab == SSThemeTabSecure) {
        name = @"tabbar-tab1";
    } else if (tab == SSThemeTabDocs) {
        name = @"tabbar-tab2";
    } else if (tab == SSThemeTabBugs) {
        name = @"tabbar-tab3";
    } else if (tab == SSThemeTabBook) {
        name = @"tabbar-tab4";
    } else if (tab == SSThemeTabOptions) {
        name = @"tabbar-tab5";
    }
    if (selected) {
        name = [name stringByAppendingString:@"-selected"];
    }
    return (name ? [UIImage imageNamed:name] : nil);
}


@end
