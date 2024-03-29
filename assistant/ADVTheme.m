//
//  ADVTheme.m
//  
//
//  Created by Valentin Filip on 7/9/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "ADVTheme.h"

#import "ADVDefaultTheme.h"
#import "ADVCustomTheme.h"
#import "AppDelegate.h"

@implementation ADVThemeManager

+ (id <ADVTheme>)sharedTheme
{
    static id <ADVTheme> sharedTheme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Create and return the theme:
//        sharedTheme = [[ADVDefaultTheme alloc] init];
        sharedTheme = [[ADVCustomTheme alloc] init];
    });
    
    return sharedTheme;
}

+ (void)customizeAppAppearance
{
    id <ADVTheme> theme = [self sharedTheme];
    UIStatusBarStyle statusBarStyle = [theme statusBarStyle];
    if (statusBarStyle) {
        [[UIApplication sharedApplication]
         setStatusBarStyle:statusBarStyle animated:NO];
    }
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundImage:[theme navigationBackgroundForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setBackgroundImage:[theme navigationBackgroundForBarMetrics:UIBarMetricsLandscapePhone] forBarMetrics:UIBarMetricsLandscapePhone];
   
    UIBarButtonItem *barButtonItemAppearance = [UIBarButtonItem appearance];
            
    [barButtonItemAppearance setBackgroundImage:[theme barButtonBackgroundForState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    [barButtonItemAppearance setBackButtonBackgroundImage:[theme backBackgroundForState:UIControlStateNormal barMetrics:UIBarMetricsDefault] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barButtonItemAppearance setBackButtonBackgroundImage:[theme backBackgroundForState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [barButtonItemAppearance setBackButtonBackgroundImage:[theme backBackgroundForState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    [barButtonItemAppearance setBackButtonBackgroundImage:[theme backBackgroundForState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone] forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
    
    UISegmentedControl *segmentedAppearance = [UISegmentedControl appearance];
    [segmentedAppearance setBackgroundImage:[theme segmentedBackgroundForState:UIControlStateNormal barMetrics:UIBarMetricsDefault] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedAppearance setBackgroundImage:[theme segmentedBackgroundForState:UIControlStateSelected barMetrics:UIBarMetricsDefault] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmentedAppearance setBackgroundImage:[theme segmentedBackgroundForState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    [segmentedAppearance setBackgroundImage:[theme segmentedBackgroundForState:UIControlStateSelected barMetrics:UIBarMetricsLandscapePhone] forState:UIControlStateSelected barMetrics:UIBarMetricsLandscapePhone];
    
    [segmentedAppearance setDividerImage:[theme segmentedDividerForBarMetrics:UIBarMetricsDefault] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedAppearance setDividerImage:[theme segmentedDividerForBarMetrics:UIBarMetricsLandscapePhone] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    
    UITabBar *tabBarAppearance = [UITabBar appearance];
    [tabBarAppearance setBackgroundImage:[theme tabBarBackground]];
    [tabBarAppearance setSelectionIndicatorImage:[theme tabBarSelectionIndicator]];
    
    
    UIToolbar *toolbarAppearance = [UIToolbar appearance];
    [toolbarAppearance setBackgroundImage:[theme toolbarBackgroundForBarMetrics:UIBarMetricsDefault] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [toolbarAppearance setBackgroundImage:[theme toolbarBackgroundForBarMetrics:UIBarMetricsLandscapePhone] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsLandscapePhone];
    
    UISearchBar *searchBarAppearance = [UISearchBar appearance];
    [searchBarAppearance setBackgroundImage:[theme searchBackground]];
    [searchBarAppearance setSearchFieldBackgroundImage:[theme searchFieldImage] forState:UIControlStateNormal];
    [searchBarAppearance setImage:[theme searchImageForIcon:UISearchBarIconSearch state:UIControlStateNormal] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchBarAppearance setImage:[theme searchImageForIcon:UISearchBarIconClear state:UIControlStateNormal] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [searchBarAppearance setImage:[theme searchImageForIcon:UISearchBarIconClear state:UIControlStateHighlighted] forSearchBarIcon:UISearchBarIconClear state:UIControlStateHighlighted];
    [searchBarAppearance setScopeBarBackgroundImage:[theme searchScopeBackground]];
    [searchBarAppearance setScopeBarButtonBackgroundImage:[theme searchScopeButtonBackgroundForState:UIControlStateNormal] forState:UIControlStateNormal];
    [searchBarAppearance setScopeBarButtonBackgroundImage:[theme searchScopeButtonBackgroundForState:UIControlStateSelected] forState:UIControlStateSelected];
    [searchBarAppearance setScopeBarButtonDividerImage:[theme searchScopeButtonDivider] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal];
    
    UISlider *sliderAppearance = [UISlider appearance];
    [sliderAppearance setThumbImage:[theme sliderThumbForState:UIControlStateNormal] forState:UIControlStateNormal];
    [sliderAppearance setThumbImage:[theme sliderThumbForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [sliderAppearance setMinimumTrackImage:[theme sliderMinTrack] forState:UIControlStateNormal];
    [sliderAppearance setMaximumTrackImage:[theme sliderMaxTrack] forState:UIControlStateNormal];
    
    UIProgressView *progressAppearance = [UIProgressView appearance];
    [progressAppearance setTrackImage:[theme progressTrackImage]];

    
    UISwitch *switchAppearance = [UISwitch appearance];
    [switchAppearance setOnTintColor:[theme switchOnColor]];

        
    NSMutableDictionary *titleTextAttributesNav = [[NSMutableDictionary alloc] init];
    UIColor *navTextColor = [theme navigationTextColor];
    if (navTextColor) {
        titleTextAttributesNav[UITextAttributeTextColor] = navTextColor;
    }
    
    UIColor *navTextShadowColor = [theme navigationTextShadowColor];
    if (navTextShadowColor) {
        titleTextAttributesNav[UITextAttributeTextShadowColor] = navTextShadowColor;
        CGSize shadowOffset = [theme shadowOffset];
        titleTextAttributesNav[UITextAttributeTextShadowOffset] = [NSValue valueWithCGSize:shadowOffset];
    }
    UIFont *navTextFont = [theme navigationFont];
    if (navTextFont) {
        titleTextAttributesNav[UITextAttributeFont] = navTextFont;
    }
    
    [navigationBarAppearance setTitleTextAttributes:titleTextAttributesNav];
    
    NSMutableDictionary *titleTextAttributesBarButton = [titleTextAttributesNav mutableCopy];
    UIFont *barButtonTextFont = [theme barButtonFont];
    if (barButtonTextFont) {
        titleTextAttributesBarButton[UITextAttributeFont] = barButtonTextFont;
    }
    [barButtonItemAppearance setTitleTextAttributes:titleTextAttributesBarButton forState:UIControlStateNormal];
    [searchBarAppearance setScopeBarButtonTitleTextAttributes:titleTextAttributesBarButton forState:UIControlStateNormal];
    
    NSMutableDictionary *titleTextAttributes = [[NSMutableDictionary alloc] init];
    UIColor *mainColor = [theme mainColor];
    if (mainColor) {
        titleTextAttributes[UITextAttributeTextColor] = mainColor;
    }
    
    UIFont *segmentFont = [theme segmentFont];
    if (segmentFont) {
        titleTextAttributes[UITextAttributeFont] = segmentFont;
    }
    UIColor *secondColor = [theme secondColor];
    if (secondColor) {
        titleTextAttributes[UITextAttributeTextColor] = secondColor;
    }
    UIColor *shadowColor = [theme shadowColor];
    if (shadowColor) {
        titleTextAttributes[UITextAttributeTextShadowColor] = shadowColor;
        CGSize shadowOffset = [theme shadowOffset];
        titleTextAttributes[UITextAttributeTextShadowOffset] = [NSValue valueWithCGSize:shadowOffset];
    }
    [segmentedAppearance setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    
    NSMutableDictionary *titleTextAttributesH = [[NSMutableDictionary alloc] init];
    UIColor *highlightShadowColor = [theme highlightShadowColor];
    if (highlightShadowColor) {
        titleTextAttributesH[UITextAttributeTextShadowColor] = highlightShadowColor;
        CGSize shadowOffset = [theme shadowOffset];
        titleTextAttributesH[UITextAttributeTextShadowOffset] = [NSValue valueWithCGSize:shadowOffset];
    }

    UIColor *highlightColor = [theme highlightColor];
    if (highlightColor) {
        titleTextAttributesH[UITextAttributeTextColor] = highlightColor;
        CGSize shadowOffset = [theme shadowOffset];
        titleTextAttributesH[UITextAttributeTextShadowOffset] = [NSValue valueWithCGSize:shadowOffset];
    }    
    [barButtonItemAppearance setTitleTextAttributes:titleTextAttributesH forState:UIControlStateHighlighted];
    [segmentedAppearance setTitleTextAttributes:titleTextAttributesH forState:UIControlStateHighlighted];
    [searchBarAppearance setScopeBarButtonTitleTextAttributes:titleTextAttributesH forState:UIControlStateHighlighted];
    
    UILabel *headerLabelAppearance = [UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil];
    UIColor *accentTintColor = [theme accentTintColor];
    if (accentTintColor) {
        [sliderAppearance setMaximumTrackTintColor:accentTintColor];
        [progressAppearance setTrackTintColor:accentTintColor];
        UIBarButtonItem *toolbarBarButtonItemAppearance = [UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil];
        [toolbarBarButtonItemAppearance setTintColor:accentTintColor];
    }
    
    UIColor *selectedTabbarItemTintColor = [theme selectedTabbarItemTintColor];
    if (selectedTabbarItemTintColor) {
        [tabBarAppearance setSelectedImageTintColor:selectedTabbarItemTintColor];
    }
    
    UIColor *baseTintColor = [theme baseTintColor];
    if (baseTintColor) {
        [navigationBarAppearance setTintColor:baseTintColor];
        [barButtonItemAppearance setTintColor:baseTintColor];
        [segmentedAppearance setTintColor:baseTintColor];
        [tabBarAppearance setTintColor:baseTintColor];
        [toolbarAppearance setTintColor:baseTintColor];
        [searchBarAppearance setTintColor:baseTintColor];
        [sliderAppearance setThumbTintColor:baseTintColor];
        [sliderAppearance setMinimumTrackTintColor:baseTintColor];
        [progressAppearance setProgressTintColor:baseTintColor];
        //[stepperAppearance setTintColor:baseTintColor];

    } else if (mainColor) {

    }
}

+ (void)customizeView:(UIView *)view
{
    id <ADVTheme> theme = [self sharedTheme];
    UIImage *backgroundImage = [theme viewBackgroundForSize:view.bounds.size];
    UIColor *backgroundColor = [theme backgroundColor];
    if (backgroundImage) {
        CGFloat padding = backgroundImage.size.height - view.bounds.size.height;
        CGFloat topPadding = padding;
        
        ADVNavigationType navigationType = [[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"];
        if (navigationType == ADVNavigationTypeTab) {
            topPadding *= 7 > [AppDelegate OSVersion] ? 0.59 : 0;
        }
        
        UIImage *finalImage = [backgroundImage crop:CGRectMake(0, topPadding, backgroundImage.size.width, backgroundImage.size.height - padding)];
        [view setBackgroundColor:[UIColor colorWithPatternImage:finalImage]];
    } else if (backgroundColor) {
        [view setBackgroundColor:backgroundColor];
    }
}

+ (void)customizePatternView:(UIView *)view
{
    id <ADVTheme> theme = [self sharedTheme];
    UIImage *backgroundImage = [theme viewBackgroundPattern];
    if (backgroundImage) {
        [view setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
    } 
}

+ (void)customizeTimelineView:(UIView *)view
{
    id <ADVTheme> theme = [self sharedTheme];
    UIImage *backgroundImage = [theme viewBackgroundTimeline];
    if (backgroundImage) {
        [view setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
    }
}


+ (void)customizeTableView:(UITableView *)tableView
{
    id <ADVTheme> theme = [self sharedTheme];
    UIImage *backgroundImage = [theme tableBackgroundForSize:tableView.bounds.size];
    UIColor *backgroundColor = [theme backgroundColor];
    if (backgroundImage) {
        CGFloat padding = backgroundImage.size.height - tableView.bounds.size.height;
        CGFloat topPadding = padding;
        
        ADVNavigationType navigationType = [[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"];
        if (navigationType == ADVNavigationTypeTab) {
            topPadding *= 7 > [AppDelegate OSVersion] ? 0.59 : 0;
        }
        
        UIImage *finalImage = [backgroundImage crop:CGRectMake(0, topPadding, backgroundImage.size.width, backgroundImage.size.height - padding)];
        UIImageView *background = [[UIImageView alloc] initWithImage:finalImage];
        [tableView setBackgroundView:background];
    } else if (backgroundColor) {
        [tableView setBackgroundView:nil];
        [tableView setBackgroundColor:backgroundColor];
    }
}

+ (void)customizeTabBarItem:(UITabBarItem *)item forTab:(SSThemeTab)tab
{
    id <ADVTheme> theme = [self sharedTheme];
    UIImage *image = [theme imageForTab:tab];
    if (image) {
        // If we have a regular image, set that
        [item setImage:image];
    } else {
        // Otherwise, set the finished images
        UIImage *selectedImage = [theme finishedImageForTab:tab selected:YES];
        UIImage *unselectedImage = [theme finishedImageForTab:tab selected:NO];
        [item setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
    }
}

+ (void)customizeNavigationBar:(UINavigationBar *)navigationBar {
    id<ADVTheme> theme = [ADVThemeManager sharedTheme];
    
    [navigationBar setBackgroundImage:[theme navigationBackgroundForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setBackgroundImage:[theme navigationBackgroundForBarMetrics:UIBarMetricsLandscapePhone] forBarMetrics:UIBarMetricsLandscapePhone];
}

+ (void)customizeMainLabel:(UILabel *)label {
    label.textColor = [[ADVThemeManager sharedTheme] mainColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
}

+ (void)customizeSecondaryLabel:(UILabel *)label {
    label.textColor = [[ADVThemeManager sharedTheme] secondColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
}

@end
