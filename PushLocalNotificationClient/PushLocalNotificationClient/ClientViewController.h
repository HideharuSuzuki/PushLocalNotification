//
//  ViewController.h
//  PushLocalNotificationClient
//
//  Created by Suzuki Hideharu on 2016/11/03.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClientController;

@interface ClientViewController : UIViewController

@property (strong,nonatomic) ClientController *m_ClientController; //クライアントコントローラー

@property (nonatomic) BOOL m_DeviceTokenFlg; //デバイストークンフラグ YES:デバイストークンがセットされている NO:セットされていない
@property (nonatomic) BOOL m_ConnectionFlg; //サーバーとの接続フラグ YES: サーバーと接続 NO:サーバーと未接続

@property (strong,nonatomic) IBOutlet UILabel    *m_LblConnectionStatus; //接続ステータス情報ラベル
@property (strong,nonatomic) IBOutlet UILabel    *m_LblDeviceTokenInfo;

@property (strong,nonatomic) IBOutlet UIButton   *m_BtnSendDeviceToken;
@property (strong,nonatomic) IBOutlet UIButton   *m_BtnConnectionToServer;

@property (strong,nonatomic) IBOutlet UITextView *m_TxtPushNotification; //プッシュ通知用テキストビュー
@property (strong,nonatomic) IBOutlet UITextView *m_TxtLocalNotification; //ローカル通知用テキストビュー

-(IBAction)fncTapBtnGetDeviceToken:(id)sender; //デバイストークン取得
-(IBAction)fncTapBtnConnectionToServer:(id)sender; //サーバーと接続
-(IBAction)fncTapBtnSendDeviceToken:(id)sender; //デバイストークンをサーバーに送信

-(void)fncRewriteConnectionStatus; //サーバーとの接続状態の書き換え


@end

