//
//  UserOrdersTableViewCell.h
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/9/11.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserOrdersTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *billIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *payStateLabel;
@property (strong, nonatomic) IBOutlet UIButton *payOrderBtn;
@property (strong, nonatomic) IBOutlet UIButton *orderDetailBtn;

@end
