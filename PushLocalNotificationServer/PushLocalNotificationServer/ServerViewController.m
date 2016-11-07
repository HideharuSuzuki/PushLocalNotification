//
//  ServerViewController.m
//  PushLocalNotificationServer
//
//  Created by Suzuki Hideharu on 2016/11/03.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import "Define.h"
#import "ServerViewController.h"

@interface ServerViewController ()

@end

@implementation ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
            
    //変数初期化
    self.m_ConnectionFlg = NO;
    self.m_DeviceTokenFlg = NO;
    self.m_ReachAvilityFlg = NO;
    self.m_NotificationFlg = NO;
    self.m_SelectDateFlg = NO;
    self.m_SelectTimeFlg = NO;
    self.m_ServerController = [ServerController defaultServerController];
    
}

#pragma mark Action Method

- (IBAction)fncTapBtnServerFunction:(id)sender {
    
    //サーバー機能初期化・スタート・接続待ち
    [self.m_ServerController fncInitServerFunction];
    [self.m_ServerController fncStartServerFunction];
    [self fncRewriteConnectionStatus];
    [self.m_ServerController fncWattingAccept];
    [self fncRewriteConnectionStatus];
    
    //受信データ待ち
    [self.m_ServerController fncRecvFromClient];
    
    //デバイストークンセット
    self.m_LblDeviceToken.text = self.m_ServerController.m_StrDeviceToken;
}

- (IBAction)fncChangeScNotificationType:(id)sender {
}
- (IBAction)fncTapBtnSelectDate:(id)sender {
}
- (IBAction)fncTapBtnSelectTime:(id)sender {
}
- (IBAction)fncTapBtnSendNotification:(id)sender {
}
- (IBAction)fncTapBtnCloseDatePicker:(id)sender {
}
- (IBAction)fncTapBtnClearDatePicker:(id)sender {
}
- (IBAction)fncTapBtnSelectDatePicker:(id)sender {
}


#pragma mark Rewrite Method

//クライアントとの接続状態の書き換え
-(void)fncRewriteConnectionStatus{
    
    switch (self.m_ServerController.m_nConnectionState) {
        case kCANT_CONNET:{
            self.m_LblConnectionStatus.text = @"クライアントと接続不可";
        }break;
        case kFAILED_SOCKET:{
            self.m_LblConnectionStatus.text = @"ソケット作成失敗";
        }break;
        case kFAILED_SOCKET_OPTION:{
            self.m_LblConnectionStatus.text = @"ソケットオプションの設定失敗";
        }break;
        case kFAILED_BIND:{
            self.m_LblConnectionStatus.text = @"バインド失敗";
        }break;
        case kFAILED_SET_QUEUE:{
            self.m_LblConnectionStatus.text = @"接続待ちキュー設定の失敗";
        }break;
        case kCAN_CONNET:{
            self.m_LblConnectionStatus.text = @"クライアントと接続可";
            self.m_BtnServerFunction.userInteractionEnabled = NO;
            self.m_BtnServerFunction.alpha = 0.1;
        }break;
        case kWHILE_CONNECT:{
            self.m_LblConnectionStatus.text = @"クライアントと接続中";
            self.m_BtnServerFunction.userInteractionEnabled = NO;
            self.m_BtnServerFunction.alpha = 0.1;
        }break;
        case kBREAK_CONNECTION:{
            self.m_LblConnectionStatus.text = @"クライアントと接続が切れました";
        }break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





















