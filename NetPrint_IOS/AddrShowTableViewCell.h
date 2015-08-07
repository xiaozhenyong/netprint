//
//  AddrShowTableViewCell.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/10.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddrShowTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *deliveryManLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *editAddressButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteAddressButton;
@property (strong, nonatomic) IBOutlet UIButton *setAddressButton;


@end
