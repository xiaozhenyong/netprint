//
//  RetrievePasswordViewController.h
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/12/1.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RetrievePasswordViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *userPhoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneCodeTextField;
- (IBAction)phoneCodeButton:(id)sender;
- (IBAction)retrievePasswordButton:(id)sender;

@end
