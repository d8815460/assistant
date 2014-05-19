//
//  AddPhoneNumberViewController.m
//  assistant
//
//  Created by ALEX on 2014/5/19.
//  Copyright (c) 2014年 miiitech. All rights reserved.
//

#import "AddPhoneNumberViewController.h"

@interface AddPhoneNumberViewController ()

@end

@implementation AddPhoneNumberViewController
@synthesize phoneNumberField;

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

- (IBAction)addPhoneNumberButtonPressed:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //隨機亂碼
    int ValueCode = arc4random() % 999999;
    if (ValueCode < 100000) {
        ValueCode = arc4random() % 999999;
    }
    NSNumber *valueCodeNumber = [NSNumber numberWithInt:ValueCode];
    NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [[PFUser currentUser] objectId]];
    
    //儲存用戶名稱
    [userDefaults setValue:self.phoneNumberField.text forKey:kCMUserNameString];
    [userDefaults setValue:privateChannelName forKey:kPAPUserPrivateChannelKey];
    [userDefaults setValue:valueCodeNumber forKey:@"phoneCode"];
    [userDefaults synchronize];
    [[PFUser currentUser] setObject:self.phoneNumberField.text forKey:kPAPUserDisplayNameKey];
    [[PFUser currentUser] setObject:self.phoneNumberField.text forKey:@"phone"];
    [[PFUser currentUser] setObject:privateChannelName forKey:kPAPUserPrivateChannelKey];
    [[PFUser currentUser] setObject:valueCodeNumber forKey:@"phoneCode"];
    
    
    PFACL *ACL = [PFACL ACL];
    [ACL setPublicReadAccess:YES];
    [PFUser currentUser].ACL = ACL;
    
    
    //執行雲端代碼
    NSString *number = @"number";
    NSString *phoneCode = @"phoneCode";
    
    int intNumble;
    intNumble = [self.phoneNumberField.text intValue];
    NSString *userPhoneNumber = [NSString stringWithFormat:@"+886%i", intNumble];
    
    //上傳至會員資料
    [[PFUser currentUser] saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //雲端代碼
            [PFCloud callFunctionInBackground:@"inviteWithTwilio" withParameters:@{number:userPhoneNumber, phoneCode:valueCodeNumber} block:^(id object, NSError *error) {
                if (!error) {
                    NSLog(@"簡訊已經送出");
                }
            }];
        }
    }];
}
@end
