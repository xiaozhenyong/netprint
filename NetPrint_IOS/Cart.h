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
//本机购物车的ID
@property (nonatomic, retain) NSString * cartId;
//商品ID
@property (nonatomic, retain) NSString * goodsId;
//照片总数
@property (nonatomic, retain) NSString * num;
//照片及其数量
@property (nonatomic, retain) NSData * detail;
//商品总额
@property (nonatomic, retain) NSString * price;
//商品名称
@property (nonatomic, retain) NSString * goodsName;

@end
