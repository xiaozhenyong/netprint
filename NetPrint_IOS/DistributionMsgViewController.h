//
//  DistributionMsgViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/16.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AddressManageViewController.h"
#import "Cart.h"
#import "DefineData.h"
#import "PayOrderViewController.h"

@interface DistributionMsgViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,NSURLConnectionDataDelegate >
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *deliveryManLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UITextField *distributionMethodLabel;
@property (strong, nonatomic) IBOutlet UITextField *couponLabel;
@property (strong, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *freightLabel;
@property (strong, nonatomic) IBOutlet UILabel *couponPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *dlsPickerView;

- (IBAction)addrManageButton:(id)sender;
- (IBAction)useCouponButton:(id)sender;
- (IBAction)submitOrderButton:(id)sender;
- (IBAction)back:(id)sender;

@property (strong,nonatomic) NSDictionary *mdi;
@property (strong,nonatomic) NSMutableArray *cartArray;

@end
