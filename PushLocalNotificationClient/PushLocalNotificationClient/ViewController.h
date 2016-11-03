//
//  ViewController.h
//  PushLocalNotificationClient
//
//  Created by Suzuki Hideharu on 2016/11/03.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (nonatomic) BOOL mDeviceTokenFlg;//デバイストークンフラグ YES:デバイストークンがセットされている NO:セットされていない

@property (strong,nonatomic) IBOutlet UILabel    *mLblStatusLabel;
@property (strong,nonatomic) IBOutlet UILabel    *mLblDeviceTokenLabel;

@property (strong,nonatomic) IBOutlet UIButton   *mBtnSendDeviceToken;

@property (strong,nonatomic) IBOutlet UITextView *mTxtPushNotification; //プッシュ通知用テキストビュー
@property (strong,nonatomic) IBOutlet UITextView *mTxtSilentNotification; //サイレント通知用テキストビュー
@property (strong,nonatomic) IBOutlet UITextView *mTxtLocalNotification; //ローカル通知用テキストビュー

-(IBAction)fncTapGetDeviceToken:(id)sender;
-(IBAction)fncTapSendDeviceToken:(id)sender;

@end

