//
//  Goods.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/7/6.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Goods : NSManagedObject
//biz_goods表的ID
@property (nonatomic, retain) NSString * gid;
//商品价格
@property (nonatomic, retain) NSString * marketprice;
//商品名称
@property (nonatomic, retain) NSString * name;
//照片大小ID
@property (nonatomic, retain) NSString * photosizeid;
//照片材质ID
@property (nonatomic, retain) NSString * phototextureid;
//包装类型ID
@property (nonatomic, retain) NSString * photowrapid;

@end
