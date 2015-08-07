//
//  NSString+URLEncoding.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/6/24.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
@end
