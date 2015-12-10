//
//  AppDelegate.h
//  NetPrint_IOS
//
//  Created by xiaozhenyong on 15/6/18.
//  Copyright (c) 2015年 世纪开元. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic,readonly) NSManagedObjectContext *managedObjectContext;

@property (strong,nonatomic,readonly) NSManagedObjectModel *managedObjectModel;

@property (strong,nonatomic,readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void) saveContext;

- (NSURL *)applicationDocumentsDirectory;

@end

