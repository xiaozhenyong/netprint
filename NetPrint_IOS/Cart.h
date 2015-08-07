//
//  Cart.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/16.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Cart : NSManagedObject

@property (nonatomic, retain) NSString * cartId;
@property (nonatomic, retain) NSString * goodsId;
@property (nonatomic, retain) NSString * num;
@property (nonatomic, retain) NSData * detail;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * goodsName;

@end
