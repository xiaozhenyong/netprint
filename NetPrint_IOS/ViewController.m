//
//  ViewController.m
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/6/18.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BeginPrintViewController.h"
#import "CartViewController.h"
#import "UserIndexViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize appDelegate = _appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self requestPhonePhotosDetail];
}

- (NSString *)createVindor{
    return [[[UIDevice currentDevice]identifierForVendor]UUIDString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)photoPrint:(id)sender {
    [self gotoPrint:@"0"];
}

- (IBAction)gotoCartPage:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CartViewController *cart = [storyboard instantiateViewControllerWithIdentifier:@"cartViewController"];
     cart.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:cart animated:YES completion:nil];
}

- (IBAction)testGotoRegister:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserIndexViewController *userIndex = [storyboard instantiateViewControllerWithIdentifier:@"userIndexViewController"];
    userIndex.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:userIndex animated:YES completion:nil];
}

//证件照
- (IBAction)paperPrint:(id)sender {
    [self gotoPrint:@"1"];
}

//拍立得
- (IBAction)polaroidPrint:(id)sender {
    [self gotoPrint:@"2"];
}

- (void)requestPhonePhotosDetail{
    
    NSString *version = @"";
    NSString *path = [self objectInfoPath];
    
    BOOL plistHas = [[NSFileManager defaultManager]fileExistsAtPath:path];
    
    if (plistHas) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        version = [dic valueForKey:@"version"];
    }else{
        version = @"0";
        [self initObjectInfoDataWithPath:path];
    }
    
    NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:version,@"versionNumber", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:PHONE_PHOTOS_DETAIL parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = responseObject;
        if (!resultDic) {
            NSLog(@"fail");
        }else{
            
            
            NSString *newVersion = [resultDic objectForKey:@"versionnumber"];
            
            [self editObjectInfoWithVersion:newVersion];
            
            NSMutableArray *photoSize= [resultDic objectForKey:@"phonephotosize"];
            
            NSMutableArray *photoTexture = [resultDic objectForKey:@"phonephototexture"];
            NSMutableArray *goods = [resultDic objectForKey:@"goods"];

            [self deleteData:@"Goods"];
            [self insertDataForGoods:goods];

            [self deleteData:@"PhotoSize"];
            [self insertDataForPhotoSize:photoSize];

            [self deleteData:@"PhotoTexture"];
            [self insertDataForPhotoTexture:photoTexture];


        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"version request  is  error  %@",error);
    }];
    
    /*异步POST请求
     NSString *baseUrl = [[NSString alloc] initWithFormat:PHONE_PHOTOS_DETAIL];
     NSURL *url = [NSURL URLWithString:[baseUrl URLEncodedString]];
     NSString *post = [NSString stringWithFormat:@"versionNumber=%@",version];
     NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
     
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     [request setHTTPMethod:@"POST"];
     [request setHTTPBody:postData];
     
     NSOperationQueue *queue = [[NSOperationQueue alloc]init];
     [NSURLConnection sendAsynchronousRequest:request
     queue:queue
     completionHandler:
     ^(NSURLResponse *response, NSData *d,NSError *er){
         NSError *error;
         if (d) {
             id jsonValue = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers error:&error];
             if (!jsonValue || er) {
                 NSLog(@"fail");
             }else{
                 NSString *newVersion = [jsonValue objectForKey:@"versionnumber"];
     
                 [self editObjectInfoWithVersion:newVersion];
     
                 NSMutableArray *photoSize= [jsonValue objectForKey:@"phonephotosize"];
                 NSMutableArray *photoTexture = [jsonValue objectForKey:@"phonephototexture"];
                 NSMutableArray *goods = [jsonValue objectForKey:@"goods"];
                 dispatch_queue_t queue = dispatch_queue_create("com.sjky.xzy", DISPATCH_QUEUE_CONCURRENT);
     
                 dispatch_async(queue, ^{
                     NSLog(@"goods ------insert");
                     [self insertDataForGoods:goods];
                 });
     
                 dispatch_async(queue, ^{
                     NSLog(@"ps-----insert");
                     [self insertDataForPhotoSize:photoSize];
                 });
     
                 dispatch_async(queue, ^{
                     NSLog(@"pt-----insert");
                     [self insertDataForPhotoTexture:photoTexture];
                 });
     
             }
         }else{
             NSLog(@"the  data is  new");
         }

     //[self showData:d];
     }];
   */
    
    /*
    NSError *error;
    NSString *url = [[NSString alloc]initWithFormat:PHONE_PHOTOS_DETAIL,version];
    NSURL *_url = [NSURL URLWithString:[url URLEncodedString]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:_url];
    [request setHTTPMethod:@"GET"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    */
}

- (void)initObjectInfoDataWithPath:(NSString *)path{
    [[NSFileManager defaultManager]createFileAtPath:path contents:nil attributes:nil];
    NSMutableDictionary *plistInitData = [[NSMutableDictionary alloc]init];
    [plistInitData setValue:@"0" forKey:@"version"];
    [plistInitData setValue:@"0" forKey:@"username"];
    [plistInitData setValue:@"0" forKey:@"password"];
    [plistInitData setValue:@"0" forKey:@"userid"];
    BOOL success = [plistInitData writeToFile:path atomically:YES];
    if (success) {
        NSLog(@"create objectinfo success");
    }else{
        NSLog(@"create objectinfo fail")    ;
    }
    
}

- (NSString *)objectInfoPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    
    NSString *objectInfoPath = [docPath stringByAppendingPathComponent:@"objectInfo.plist"];
    
    return objectInfoPath;
}

- (void)editObjectInfoWithVersion:(NSString *)version{
    NSString *path = [self objectInfoPath];
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc]initWithContentsOfFile:path]mutableCopy];
    [dic setObject:version forKey:@"version"];
    BOOL w = [dic writeToFile:path atomically:YES];
    if (w) {
        NSLog(@"write version success");
    }else{
        NSLog(@"write version fail");
    }
}
/*
 插入操作改为线程安全
 */
- (void) insertDataForPhotoSize:(NSMutableArray *)photoSizeArray{
    
//    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
 //   context.parentContext = _appDelegate.managedObjectContext;
 //   [context performBlock:^{
        
        if (photoSizeArray) {
            for (NSDictionary *dic in photoSizeArray) {
                PhotoSize *ps = (PhotoSize *)[NSEntityDescription insertNewObjectForEntityForName:@"PhotoSize" inManagedObjectContext:_appDelegate.managedObjectContext];
                
                [ps setName:[dic objectForKey:@"name"]];
                [ps setPhotosizeid:[self nsNumberToNSString:[dic objectForKey:@"photosizeid"]]];
                [ps setMixpixelwidth:[self nsNumberToNSString:[dic objectForKey:@"mixpixelwidth"]]];
                [ps setMinpixelheight:[self nsNumberToNSString:[dic objectForKey:@"minpixelheight"]]];
                
                NSLog(@"mph----%@--->%@",[dic objectForKey:@"name"],[self nsNumberToNSString:[dic objectForKey:@"minpixelheight"]]);
                
                [ps setFactwidth:[self nsNumberToNSString:[dic objectForKey:@"factwidth"]]];
                [ps setFactheight:[self nsNumberToNSString:[dic objectForKey:@"factheight"]]];
                [ps setType:[self nsNumberToNSString:[dic objectForKey:@"type"]]];
                [ps setOrder:[self nsNumberToNSString:[dic objectForKey:@"order"]]];
                
 //               [context performBlock:^{
                     NSError *error = nil;
                    BOOL isSuccess = [_appDelegate.managedObjectContext save:&error];
                    if (!isSuccess) {
                        NSLog(@"Error photosize is %@",error);
                    }
 //               }];
            }
            
        }else{
            NSLog(@"photosize is NULL");
        }

 //   }];
    }

- (void) insertDataForPhotoTexture:(NSMutableArray *)photoTextureArray{
    
//    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//    context.parentContext = _appDelegate.managedObjectContext;
 //   [context performBlock:^{
        if (photoTextureArray) {
            for (NSDictionary *dic in photoTextureArray) {
                PhotoTexture *pt = (PhotoTexture *)[NSEntityDescription insertNewObjectForEntityForName:@"PhotoTexture" inManagedObjectContext:_appDelegate.managedObjectContext];
                [pt setName:[dic objectForKey:@"name"]];
                [pt setPhototextureid:[self nsNumberToNSString:[dic objectForKey:@"phototextureid"]]];
                [pt setType:[self nsNumberToNSString:[dic objectForKey:@"type"]]];
                [pt setSort:[self nsNumberToNSString:[dic objectForKey:@"sort"]]];
                
 //               [context performBlock:^{
                    NSError *error = nil;
                    BOOL isSuccess = [_appDelegate.managedObjectContext save:&error];
                    if (!isSuccess) {
                        NSLog(@"Error phototexture is %@",error);
                    }
//                }];
            }
        }else{
            NSLog(@"photoTextrue is NULL");
        }

//    }];
    
    }

- (void) insertDataForGoods:(NSMutableArray *)goodsArray{
    
    
 //   NSManagedObjectContext *context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
 //   context.parentContext = _appDelegate.managedObjectContext;
 //   [context performBlock:^{
        if (goodsArray) {
            for (NSDictionary *dic in goodsArray) {
                Goods *g = (Goods *)[NSEntityDescription insertNewObjectForEntityForName:@"Goods" inManagedObjectContext:_appDelegate.managedObjectContext];
                
                [g setGid:[NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]]];
                [g setName:[dic valueForKey:@"name"]];
                
                [g setMarketprice:[NSString stringWithFormat:@"%@",[dic valueForKey:@"marketprice"]]];
                
                
                [g setPhotosizeid:[NSString stringWithFormat:@"%@",[dic valueForKey:@"photosizeid"]]];
                
                [g setPhototextureid:[NSString stringWithFormat:@"%@",[dic valueForKey:@"phototextureid"]]];
                
                [g setPhotowrapid:[NSString stringWithFormat:@"%@",[dic valueForKey:@"photowrapid"]]];
//                [context performBlock:^{
                    NSError *error = nil;
                    BOOL isSuccess = [_appDelegate.managedObjectContext save:&error];
                    if (!isSuccess) {
                        NSLog(@"Error goods is %@",error);
                    }
//                }];
            }
        }else{
            NSLog(@"goods is NULL");
        }

//    }
//];
    
    }

- (NSString *)nsNumberToNSString:(NSNumber *)number{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    return [formatter stringFromNumber:number];
}

/*
 删除操作
 */
- (void)deleteData:(NSString *)tableName{
    
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *table = [NSEntityDescription entityForName:tableName inManagedObjectContext:_appDelegate.managedObjectContext];
    [request setEntity:table];
    
    NSMutableArray *array = [[_appDelegate.managedObjectContext  executeFetchRequest:request error:&error]mutableCopy];
    if (!array) {
        NSLog(@"Error delete table is %@",error);
    }else{
        if ([@"Goods" isEqualToString:tableName]) {
            for (Goods *good in array) {
                [_appDelegate.managedObjectContext deleteObject:good];
            }
        }else if ([@"PhotoSize" isEqualToString:tableName]){
            for (PhotoSize *ps in array) {
                [_appDelegate.managedObjectContext deleteObject:ps];
            }
        }else{
            for (PhotoTexture *pt in array) {
                [_appDelegate.managedObjectContext deleteObject:pt];
            }
        }
        if ([_appDelegate.managedObjectContext save:&error]) {
            NSLog(@"353----Error : %@",error);
        }
    }
}


//页面跳转
- (void)gotoPrint:(NSString *)flag{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BeginPrintViewController *beginPrint = [storyBoard instantiateViewControllerWithIdentifier:@"beginPrintViewController"];
    beginPrint.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    beginPrint.bFlag = flag;
    
    beginPrint.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:beginPrint animated:YES completion:^{NSLog(@"");}];
 }

@end
