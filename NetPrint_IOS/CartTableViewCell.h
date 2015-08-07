//
//  CartTableViewCell.h
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/7/7.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteCartButton;


@end
