//
//  AppDelegate.h
//  DyanmicDemo
//
//  Created by 中国孔 on 2019/3/12.
//  Copyright © 2019 孔令辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

