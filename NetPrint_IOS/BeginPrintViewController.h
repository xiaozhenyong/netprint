//
//  BeginPrintViewController.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/6/23.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefineData.h"
#import "NSString+URLEncoding.h"
#import "NSNumber+Message.h"
#import "AppDelegate.h"
#import "Goods.h"
#import "PhotoSize.h"
#import "PhotoTexture.h"
#import "Goods.h"

@interface BeginPrintViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *photoSize;
@property (strong, nonatomic) IBOutlet UIView *photoTexture;
@property (weak, nonatomic) IBOutlet UISwitch *open;

- (IBAction)back:(id)sender;
- (IBAction)beginPrint:(id)sender;
- (IBAction)selectPhoto:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *switchValueLable;
@property (strong, nonatomic) IBOutlet UILabel *photoSizeId;
@property (strong, nonatomic) IBOutlet UILabel *photoTexttureId;

@property (nonatomic,strong) NSData *postDatas;

@property (strong,nonatomic)AppDelegate *appDelegate;

@property (nonatomic,readwrite)BOOL swithValue;
@property (nonatomic,readwrite)NSInteger psCount;
@property (nonatomic,readwrite)NSInteger ptCount;
@property (nonatomic,readwrite)NSString *bFlag;

@property (nonatomic,strong)NSMutableArray *psArray;
@property (nonatomic,strong)NSMutableArray *ptArray;

@property (nonatomic,copy)NSMutableArray *assets;


- (void) startRequest;

@end
