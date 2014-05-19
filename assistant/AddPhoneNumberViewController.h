//
//  AddPhoneNumberViewController.h
//  assistant
//
//  Created by ALEX on 2014/5/19.
//  Copyright (c) 2014年 miiitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPhoneNumberViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *phoneNumberField;

- (IBAction)addPhoneNumberButtonPressed:(id)sender;

@end
