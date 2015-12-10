//
//  PhoneRetrievePasswordViewController.h
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/12/3.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneRetrievePasswordViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *cPasswordTextField;
- (IBAction)setNewPasswordButton:(id)sender;

- (IBAction)back:(id)sender;
@end
