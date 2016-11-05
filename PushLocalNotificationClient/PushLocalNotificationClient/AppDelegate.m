//
//  AppDelegate.m
//  PushLocalNotificationClient
//
//  Created by Suzuki Hideharu on 2016/11/03.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import "AppDelegate.h"
#import "ClientViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //端末iOSバージョンの取得・保持
    NSString  *strSystemVersion = [UIDevice currentDevice].systemVersion;
    NSArray   *arrSystemVersion = [strSystemVersion componentsSeparatedByString:@"."]; //.で分離
    NSInteger nSystemVersion    = [arrSystemVersion[0] integerValue]; //iOSバージョン整数部分
    
    //iOSバージョン判定と分岐・プッシュ通知のタイプ設定・確認ダイアログ表示(iOS8.9は合っているか要確認)
    if( nSystemVersion <= 7 ){ //iOS7以下 floor:小数点切り捨て
        
        //アラート・警告音・バッジ設定
        [application registerForRemoteNotificationTypes:
            UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
        
    }else if( nSystemVersion <= 8 ){ //iOS8
        
        [application registerForRemoteNotifications];
        
    }else if ( nSystemVersion <= 9 ){ //iOS9
        
        [application registerForRemoteNotifications];
        UIUserNotificationType types = UIUserNotificationTypeBadge| UIUserNotificationTypeSound| UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [application registerUserNotificationSettings:mySettings];

        
    }else{ //iOS10以上
        
        
        
    }
    
    //以上より、初回起動時プッシュ通知の確認ダイアログを表示
    //OK・キャンセル問わず、端末情報と通知タイプ設定をAPNSに登録(のはず)・デバイストークンを生成
    //UIApplicationDelegateメソッドによりデバイストークンを取得できる
    
    return YES;
}

#pragma mark UIApplicationDelegate

//プッシュ通知用DeviceToken取得メソッド
//引数 1:アプリインスタンス 2:デバイストークン
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSLog(@"deviceToken register OK: %@", [deviceToken description]);
    
    self.deviceToken = deviceToken; //デバイストークン保持
}

//プッシュ通知用DeviceToken取得失敗メソッド
//引数 1:アプリインスタンス 2:エラーオブジェクト
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    
    NSLog(@"deviceToken register error: %@", [error description]);
    
    //DeviceToken取得失敗をラベルに反映
    ClientViewController *clientViewController = (ClientViewController *)[[application keyWindow] rootViewController];
    clientViewController.m_LblDeviceTokenInfo.text = @"Failed to register with Apple";
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

@end
