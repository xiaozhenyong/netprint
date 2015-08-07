//
//  RadioButton.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/6/24.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "RadioButton.h"

@implementation RadioButton

- (UIButton *)createButton:(CGFloat)x originY:(CGFloat)y sizeWidth:(CGFloat)w sizeHeight:(CGFloat)h index:(NSInteger)index{
    
    UIButton *radioBut = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectMake(x, y, w,h);
    [radioBut setFrame:rect];
    [radioBut setTag:index];
    
    [radioBut setImage:[UIImage imageNamed:@"RadioButton.png"] forState:UIControlStateNormal];

    [radioBut addTarget:self action:@selector(radioButtonSelect) forControlEvents:UIControlEventTouchUpInside];
    
    return radioBut;
}

- (void)radioButtonSelect{
    NSLog(@"select ");
//        [self setImage:[UIImage imageNamed:@"RadioButtonSelected.png"] forState:UIControlStateNormal];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}


@end
