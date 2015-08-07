//
//  Goods.h
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/7/6.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Goods : NSManagedObject

@property (nonatomic, retain) NSString * gid;
@property (nonatomic, retain) NSString * marketprice;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photosizeid;
@property (nonatomic, retain) NSString * phototextureid;
@property (nonatomic, retain) NSString * photowrapid;

@end
