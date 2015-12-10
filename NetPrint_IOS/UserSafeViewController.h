//
//  UserSafeViewController.h
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/12/1.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSafeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *nPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmNewPasswordTextField;
- (IBAction)retrievePasswordButton:(id)sender;
- (IBAction)editPasswordButton:(id)sender;
- (IBAction)back:(id)sender;

@end
