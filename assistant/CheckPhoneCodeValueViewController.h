//
//  CheckPhoneCodeValueViewController.h
//  assistant
//
//  Created by ALEX on 2014/5/19.
//  Copyright (c) 2014年 miiitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckPhoneCodeValueViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *PhoneCodeField;

- (IBAction)checkPhoneCode:(id)sender;
@end
