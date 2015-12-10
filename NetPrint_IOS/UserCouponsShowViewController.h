//
//  UserCouponsShowViewController.h
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/11/30.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCouponsShowViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *couponsTableView;
- (IBAction)back:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *couponsCountLabel;
@property (strong, nonatomic)NSArray *userCouponsArray;
@end
