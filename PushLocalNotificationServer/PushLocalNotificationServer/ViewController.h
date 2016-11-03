//
//  ViewController.h
//  PushLocalNotificationServer
//
//  Created by Suzuki Hideharu on 2016/11/03.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerController.h"

@interface ViewController : UIViewController<ServerControllerDelegate>

@property (strong,nonatomic) ServerController  *m_ServerController; //サーバーコントローラー

@property (strong,nonatomic) IBOutlet UILabel *m_LblConnectionStatus; //接続状態ラベル
@property (strong,nonatomic) IBOutlet UILabel *m_LblDeviceToken; //デバイストークン情報ラベル

@property (strong,nonatomic) IBOutlet UISegmentedControl *m_ScNotification; //通知の種類セグメントコントロール
@property (strong,nonatomic) IBOutlet UITextView *m_TxtNotification; //通知内容テキストビュー
@property (strong,nonatomic) IBOutlet UIButton   *m_BtnSendNotification; //通知の送信ボタン

-(IBAction)fncTapScNotification:(id)sender;
-(IBAction)fncTapBtnSendNotification:(id)sender;

@end

