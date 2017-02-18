//
//  AppDelegate.m
//  ZFContacts
//
//  Created by Zhao Fei on 16/8/25.
//  Copyright © 2016年 ZhaoFei. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactsViewController.h"

static NSString *item_1_type = @"item_1_type";
static NSString *item_2_type = @"item_2_type";
static NSString *item_3_type = @"item_3_type";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ContactsViewController alloc] init]];
    
    // 3D Touch
    UIApplicationShortcutIcon *icon_1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeContact];
    UIApplicationShortcutItem *item_1 = [[UIApplicationShortcutItem alloc] initWithType: item_1_type localizedTitle:@"Contacts" localizedSubtitle:nil icon:icon_1 userInfo:nil];
    
    UIApplicationShortcutIcon *icon_2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    UIApplicationShortcutItem *item_2 = [[UIApplicationShortcutItem alloc] initWithType: item_2_type localizedTitle:@"Add contact" localizedSubtitle:nil icon:icon_2 userInfo:nil];
    
    UIApplicationShortcutIcon *icon_3 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutItem *item_3 = [[UIApplicationShortcutItem alloc] initWithType: item_3_type localizedTitle:@"Search" localizedSubtitle:nil icon:icon_3 userInfo:nil];

    
    application.shortcutItems = @[item_1, item_2, item_3];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    NSLog(@"%@", nav);
    
    ContactsViewController *contactsVC = (ContactsViewController *)nav.topViewController;
    NSLog(@"%@", contactsVC);
    
    NSString *itemType = shortcutItem.type;
    if ([itemType isEqualToString: item_1_type]) {
        NSLog(@"click item_1");
    } else if ([itemType isEqualToString: item_2_type]) {
        NSLog(@"click item_2");
    } else if ([itemType isEqualToString: item_3_type]) { // 搜索联系人
        [contactsVC.searchBar becomeFirstResponder];
    }
}

@end
