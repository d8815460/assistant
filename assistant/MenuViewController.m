//
//  MenuViewController.m
//  
//
//  Created by Valentin Filip on 09.04.2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "MenuViewController.h"
#import "DataSource.h"
#import "AppDelegate.h"

#import "ADVTheme.h" 


@interface MenuViewController ()

@end



@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"NavigationType"] == ADVNavigationTypeMenu) {
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(0, 0, 40, 30);
        [menuButton setImage:[UIImage imageNamed:@"navigation-btn-menu"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [ADVThemeManager customizeView:self.view];
    [ADVThemeManager customizeNavigationBar:self.navigationController.navigationBar];
}

#pragma mark -
#pragma mark Button actions

- (void)showMenu
{
    if (!_sideMenu) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                                 bundle: nil];
        
        RESideMenuItem *homeItem = [[RESideMenuItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"menu-icon1"] highlightedImage:nil action:^(RESideMenu *menu, RESideMenuItem *item) {
            UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"NearbyNav"];
            
            [menu setRootViewController:navigationController];
        }];
        RESideMenuItem *groupsItem = [[RESideMenuItem alloc] initWithTitle:@"Groups" image:[UIImage imageNamed:@"menu-icon2"] highlightedImage:nil action:^(RESideMenu *menu, RESideMenuItem *item) {
            UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"TasksNav"];
            
            [menu setRootViewController:navigationController];
        }];
        RESideMenuItem *notesItem = [[RESideMenuItem alloc] initWithTitle:@"CallHelp" image:[UIImage imageNamed:@"menu-icon3"] highlightedImage:nil action:^(RESideMenu *menu, RESideMenuItem *item) {
            UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"CallHelpNav"];
            
            [menu setRootViewController:navigationController];
        }];
        RESideMenuItem *historyItem = [[RESideMenuItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"menu-icon4"] highlightedImage:nil action:^(RESideMenu *menu, RESideMenuItem *item) {
            UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProfileNav"];
            
            [menu setRootViewController:navigationController];
        }];
        RESideMenuItem *settingsItem = [[RESideMenuItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"menu-icon5"] highlightedImage:nil action:^(RESideMenu *menu, RESideMenuItem *item) {
            UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsNav"];
            
            [menu setRootViewController:navigationController];
        }];
        
        RESideMenuItem *trashItem = [[RESideMenuItem alloc] initWithTitle:@"Trash" image:[UIImage imageNamed:@"menu-icon6"] highlightedImage:nil action:^(RESideMenu *menu, RESideMenuItem *item) {
            UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OtherNav"];
            
            [menu setRootViewController:navigationController];
        }];
        
        RESideMenuItem *helpItem = [[RESideMenuItem alloc] initWithTitle:@"Help" image:[UIImage imageNamed:@"menu-icon7"] highlightedImage:nil action:^(RESideMenu *menu, RESideMenuItem *item) {
            UINavigationController *navigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"OtherNav"];
            
            [menu setRootViewController:navigationController];
        }];        
        
        _sideMenu = [[RESideMenu alloc] initWithItems:@[homeItem, groupsItem, notesItem, historyItem, settingsItem, trashItem, helpItem]];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
        _sideMenu.hideStatusBarArea = [AppDelegate OSVersion] < 7;
        
    }
    id<ADVTheme> theme = [ADVThemeManager sharedTheme];
    _sideMenu.backgroundImage = [theme viewBackground];
    
    [self.view endEditing:YES];
    
    [_sideMenu show];
}


- (void)viewDidUnload {
    _sideMenu = nil;
    
    [super viewDidUnload];
}


@end
