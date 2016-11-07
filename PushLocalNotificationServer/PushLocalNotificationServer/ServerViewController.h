//
//  ServerViewController.h
//  PushLocalNotificationServer
//
//  Created by Suzuki Hideharu on 2016/11/03.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerController.h"

@interface ServerViewController : UIViewController

@property (nonatomic) BOOL m_ConnectionFlg;   //クライアントとの接続フラグ YES: クライアントと接続 NO:クライアントと未接続
@property (nonatomic) BOOL m_DeviceTokenFlg;  //デバイストークンフラグ YES:デバイストークンがセットされている NO:セットされていない
@property (nonatomic) BOOL m_ReachAvilityFlg; //リーチアビリティフラグ YES:ネットに繋がっている NO:繋がっていない
@property (nonatomic) BOOL m_NotificationFlg; //通知実行フラグ YES:通知を実行可 NO:通知を実行不可
@property (nonatomic) BOOL m_SelectDateFlg;   //日付選択フラグ YES:日付が選択されている NO:選択されていない
@property (nonatomic) BOOL m_SelectTimeFlg;   //時間選択フラグ YES:時間が選択されている NO:選択されていない

@property (nonatomic) int  m_nIndexDatePicer; //操作中の日時ピッカーのインデックス 0:未選択 1:日付 2:時間

@property (strong,nonatomic) ServerController  *m_ServerController; //サーバーコントローラー

@property (strong,nonatomic) IBOutlet UIButton   *m_BtnServerFunction; //サーバー機能実行ボタン
@property (strong,nonatomic) IBOutlet UILabel    *m_LblConnectionStatus; //接続ステータス情報ラベル
@property (strong,nonatomic) IBOutlet UILabel    *m_LblDeviceToken; //デバイストークン情報ラベル
@property (strong,nonatomic) IBOutlet UILabel    *m_LblReachAvility; //リーチアビリティ情報ラベル
@property (strong,nonatomic) IBOutlet UILabel    *m_LblNotification; //通知情報ラベル
@property (strong,nonatomic) IBOutlet UIView     *m_UvCoverNotificationArea; //通知情報設定領域のカバーのビュー
@property (strong,nonatomic) IBOutlet UISegmentedControl *m_ScNotificationType; //通知の種類セグメントコントロール
@property (strong,nonatomic) IBOutlet UIView     *m_UvDateTimeBackground; //ローカル通知実行時間の背景ビュー
@property (strong,nonatomic) IBOutlet UIButton   *m_BtnSelectDate; //日付を選択ボタン
@property (strong,nonatomic) IBOutlet UIButton   *m_BtnSelectTime; //時間を選択ボタン
@property (strong,nonatomic) IBOutlet UITextView *m_TxtContentNotification; //通知内容テキストビュー
@property (strong,nonatomic) IBOutlet UIButton   *m_BtnSendNotification; //通知の送信ボタン
@property (strong,nonatomic) IBOutlet UITextView *m_TxtHistoryNotification; //通知内容テキストビュー
@property (strong,nonatomic) IBOutlet UIView     *m_UvDatePickerBackground; //日時ピッカーの背景ビュー
@property (strong,nonatomic) IBOutlet UIButton   *m_BtnCloseDatePicker; //閉じるボタン
@property (strong,nonatomic) IBOutlet UIButton   *m_BtnClearDatePicker; //クリアボタン
@property (strong,nonatomic) IBOutlet UIButton   *m_BtnSelectDatePicker; //選択ボタン
@property (strong,nonatomic) IBOutlet UIDatePicker *m_DpLocalNotification; //ローカル通知のデートピッカー


-(void)fncRewriteConnectionStatus; //クライアントとの接続状態の書き換え

@end

