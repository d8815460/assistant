//
//  TasksViewController.m
//  assistant
//
//  Created by ALEX on 2014/5/19.
//  Copyright (c) 2014年 miiitech. All rights reserved.
//

#import "TasksViewController.h"
#import "AyiWellcomeViewController.h"


@interface TasksViewController ()

@end

@implementation TasksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.helloLabel.text = @"why";
    
    if (![PFUser currentUser]) {
        NSLog(@"尚未登入");
        /*Step 0 : 彈跳登入畫面，讓用戶登入。 */
        // Customize the Log In View Controller
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
        AyiWellcomeViewController *welcomeVC = (AyiWellcomeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"welcome"];
        
        
        // Present Log In View Controller
        [self presentViewController:welcomeVC animated:YES completion:^{
            NSLog(@"Present Welcome View Controller");
        }];
        
    }else{
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
