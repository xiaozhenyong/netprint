//
//  RadioButton.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/6/24.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButton : UIButton

- (UIButton *)createButton:(CGFloat )x originY:(CGFloat )y sizeWidth:(CGFloat )w sizeHeight:(CGFloat )h index:(NSInteger)index;
//- (void)radioButtonSelect;
@end
