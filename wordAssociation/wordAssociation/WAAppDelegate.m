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
#import "Appirater.h"

@implementation WAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //ユーザーデフォルトに初期値を設定
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults setObject:@"1.0" forKey:APP_VERSION_KEY];
    [defaults setObject:@"1" forKey:NOW_MAINSTAGE_KEY];
    [defaults setObject:@"1" forKey:NOW_SUBSTAGE_KEY];
    [defaults setObject:@"1" forKey:NOW_TOTALSTAGE_KEY];
    [defaults setObject:@"60" forKey:COINS_KEY];
    [USER_DEFAULT registerDefaults:defaults];
    [USER_DEFAULT synchronize];
    
    
    if(![USER_DEFAULT boolForKey:SET_DEFAULT_KEY]){
//        NSLog(@"%@",[USER_DEFAULT stringForKey:SET_DEFAULT_KEY]);
        //SBJson
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path1 = [bundle pathForResource:@"stage1" ofType:@"json"];
        NSString *path2 = [bundle pathForResource:@"stage2" ofType:@"json"];
        NSString *path3 = [bundle pathForResource:@"stage3" ofType:@"json"];
        NSString *path4 = [bundle pathForResource:@"stage4" ofType:@"json"];
        NSString *path5 = [bundle pathForResource:@"stage5" ofType:@"json"];
        NSString *path6 = [bundle pathForResource:@"stage6" ofType:@"json"];

        
        NSDictionary *stage1 = [Utilities jsonParserWithPath:path1];
        NSDictionary *stage2 = [Utilities jsonParserWithPath:path2];
        NSDictionary *stage3 = [Utilities jsonParserWithPath:path3];
        NSDictionary *stage4 = [Utilities jsonParserWithPath:path4];
        NSDictionary *stage5 = [Utilities jsonParserWithPath:path5];
        NSDictionary *stage6 = [Utilities jsonParserWithPath:path6];
        
        //ステージごとのシナリオを一括で作成
        NSMutableArray *scenario = [[NSMutableArray alloc] initWithArray:[Utilities setQuestionIDs:15]];
        NSLog(@"scenario %@",scenario);
    
        [USER_DEFAULT setObject:stage1 forKey:STAGE1_QUESTIONS_KEY];
        [USER_DEFAULT setObject:stage2 forKey:STAGE2_QUESTIONS_KEY];
        [USER_DEFAULT setObject:stage3 forKey:STAGE3_QUESTIONS_KEY];
        [USER_DEFAULT setObject:stage4 forKey:STAGE4_QUESTIONS_KEY];
        [USER_DEFAULT setObject:stage5 forKey:STAGE5_QUESTIONS_KEY];
        [USER_DEFAULT setObject:stage6 forKey:STAGE6_QUESTIONS_KEY];
        
        [USER_DEFAULT setObject:@"6" forKey:MAXSTAGE_KEY];
        [USER_DEFAULT setObject:scenario forKey:SCENARIO_KEY];
        [USER_DEFAULT setBool:YES forKey:SET_DEFAULT_KEY];
        [USER_DEFAULT synchronize];
    }

    HomeViewController *masterViewController = [[HomeViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    [self.navigationController.navigationBar setHidden:YES];

    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    [Appirater setAppId:@"621883285"];
    [Appirater appLaunched:YES];
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
    [Appirater appEnteredForeground:YES];
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
