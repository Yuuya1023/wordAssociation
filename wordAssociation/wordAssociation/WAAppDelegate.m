//
//  WAAppDelegate.m
//  wordAssociation
//
//  Created by 南部 祐耶 on 2013/03/12.
//  Copyright (c) 2013年 Yuya Nambu. All rights reserved.
//

#import "WAAppDelegate.h"

#import "HomeViewController.h"
#import "SBJson.h"

@implementation WAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //SBJson
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"word" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:path] encoding:NSUTF8StringEncoding];
//    NSArray *jsonArray = [jsonString JSONValue];
    
    SBJsonParser* sbjsonparser =[[SBJsonParser alloc]init];
    NSError* error;
    error = nil;
    NSDictionary* dic = [sbjsonparser objectWithString:jsonString
                                                 error:&error];

    
//    NSLog(@"json %@",jsonArray);
    [USER_DEFAULT setObject:dic forKey:@"json"];
    [USER_DEFAULT synchronize];
    
    //ユーザーデフォルトに初期値を設定
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults setObject:@"1" forKey:NOWSTAGE_KEY];
    [defaults setObject:@"0" forKey:COINS_KEY];
    [defaults setObject:@"0" forKey:HASH_STRING_KEY];
    [USER_DEFAULT registerDefaults:defaults];
    [USER_DEFAULT synchronize];


    HomeViewController *masterViewController = [[HomeViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
//        [self.navigationController.navigationBar setAlpha:0.0];
//        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Title_Bar"] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setHidden:YES];
    }
    // iOS 4.3用
    else {
//        UIImageView *navBGImageView = [[UIImageView alloc] initWithImage:navBGImage];
//        navBGImageView.frame = self.navigationController.navigationBar.bounds;
//        navBGImageView.autoresizingMask =
//		UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        navBGImageView.layer.zPosition = -FLT_MAX;
//        [self.navigationController.navigationBar insertSubview:navBGImageView atIndex:0];
//        [navBGImageView release];
    }
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
