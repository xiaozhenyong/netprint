//
//  UserMoneyViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/9.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "AFNetworking.h"
#import "DefineData.h"
#import "Order.h"
#import "DataSigner.h"
#import "BaseView.h"


@interface UserMoneyViewController : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userMoneyLabel;

- (IBAction)backPage:(id)sender;

- (IBAction)topUpButton:(id)sender;

/*
@property (readwrite,nonatomic)NSInteger uId;
@property (strong,nonatomic)NSString *userId;
@property (readwrite,nonatomic)float uMoney;
@property (strong,nonatomic)NSString *memberAvatar;
*/
@property (strong,nonatomic)NSArray *mUserInfo;

@end
