//
//  RegisterViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/8.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import "DefineData.h"
#import "NSString+URLEncoding.h"
#import "NSNumber+Message.h"

@interface RegisterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *mailTextField;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *contersignTextField;

- (IBAction)registerButton:(id)sender;
@end
