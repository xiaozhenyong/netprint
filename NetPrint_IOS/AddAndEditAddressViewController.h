//
//  AddAndEditAddressViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/13.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"
#import "DefineData.h"
#import "NSString+URLEncoding.h"
#import "NSNumber+Message.h"

@interface AddAndEditAddressViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *deliverManTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UITextView *addrDetailTextView;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *telTextField;

- (IBAction)saveAddressButton:(id)sender;
- (IBAction)back:(id)sender;

@property (strong, nonatomic) IBOutlet UIPickerView *selectAreaPickerView;

@property (strong,nonatomic)Address *addr;
@property (strong,nonatomic)NSString *areaValue;
@property (strong,nonatomic)NSArray *addressInfo;
@property (strong,nonatomic)NSDictionary *userDic;
@end
