//
//  PhotoTexture.h
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/6/26.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PhotoTexture : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phototextureid;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * sort;

@end
