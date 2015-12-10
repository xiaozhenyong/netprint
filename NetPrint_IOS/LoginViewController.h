//
//  LoginViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/9.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *user;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)registPage:(id)sender;
- (IBAction)loginButton:(id)sender;

@end
