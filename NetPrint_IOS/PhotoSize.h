//
//  PhotoSize.h
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/6/26.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PhotoSize : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photosizeid;
@property (nonatomic, retain) NSString * mixpixelwidth;
@property (nonatomic, retain) NSString * minpixelheight;
@property (nonatomic, retain) NSString * factwidth;
@property (nonatomic, retain) NSString * factheight;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * order;

@end
