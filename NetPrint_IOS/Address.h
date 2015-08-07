//
//  Address.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/13.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (copy,nonatomic)NSString *country;
@property (copy,nonatomic)NSString *state;
@property (copy,nonatomic)NSString *city;
@property (copy,nonatomic)NSString *district;
@property (copy,nonatomic)NSString *street;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
