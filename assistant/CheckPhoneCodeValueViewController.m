//
//  CheckPhoneCodeValueViewController.m
//  assistant
//
//  Created by ALEX on 2014/5/19.
//  Copyright (c) 2014年 miiitech. All rights reserved.
//

#import "CheckPhoneCodeValueViewController.h"
#import "AppDelegate.h"

@interface CheckPhoneCodeValueViewController ()

@end

@implementation CheckPhoneCodeValueViewController
@synthesize PhoneCodeField;

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

- (IBAction)checkPhoneCode:(id)sender {
    NSLog(@"USER = %@", [[[PFUser currentUser] objectForKey:@"phoneCode"] stringValue]);
    
    if ([[[[PFUser currentUser] objectForKey:@"phoneCode"] stringValue] isEqualToString:self.PhoneCodeField.text]) {
        NSLog(@"認證通過");
        //轉場至 google Map 畫面
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentGoogleMapController];
    }else{
        NSLog(@"認證不過哦");
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"setToMap"]) {
        
    }
}
@end
