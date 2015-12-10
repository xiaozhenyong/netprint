//
//  BaseView.h
//  NetPrint_IOS
//
//  Created by sjkysjky on 15/10/28.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

+ (UIAlertView *)alertViewNoDelegateWithTitle:(NSString *)title msg:(NSString *)msg cancel:(NSString *)cancel other:(NSString *)other;

+ (UIAlertView *)alertViewHasDelegateWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel other:(NSString *)other delegate:(id)delegate;


@end
