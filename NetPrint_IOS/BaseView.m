//
//  BaseView.m
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/10/28.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

+ (UIAlertView *)alertViewNoDelegateWithTitle:(NSString *)title msg:(NSString *)msg cancel:(NSString *)cancel other:(NSString *)other{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:cancel otherButtonTitles:other, nil];
    return alertView;
}

+ (UIAlertView *)alertViewHasDelegateWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel other:(NSString *)other delegate:(id)delegate{

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:other, nil];
    
    return alertView;
}


@end
