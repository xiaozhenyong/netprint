//
//  ViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/6/18.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//证件照
- (IBAction)paperPrint:(id)sender;

//拍立得
- (IBAction)polaroidPrint:(id)sender;

//页面跳转
- (void) gotoPrint:(NSString *)flag;

- (IBAction)photoPrint:(id)sender;
- (IBAction)gotoCartPage:(id)sender;

- (IBAction)testGotoRegister:(id)sender;

@end

