//
//  UserCouponsTableViewCell.h
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/12/1.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCouponsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cpnsNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *cpnsPrefixLabel;
@property (strong, nonatomic) IBOutlet UILabel *pmtDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@end
