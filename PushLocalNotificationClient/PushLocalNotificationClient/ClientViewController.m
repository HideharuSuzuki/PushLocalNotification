//
//  ViewController.m
//  PushLocalNotificationClient
//
//  Created by Suzuki Hideharu on 2016/11/03.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import "Define.h"
#import "AppDelegate.h"
#import "ClientViewController.h"
#import "ClientController.h"


@interface ClientViewController ()

@end

@implementation ClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //変数初期化
    self.m_ClientController = [ClientController defaultClientController];
    self.m_DeviceTokenFlg = NO;
    self.m_ConnectionFlg  = NO;
    self.m_BtnSendDeviceToken.userInteractionEnabled = NO;
    self.m_BtnSendDeviceToken.alpha = 0.1;
}

//デバイストークン取得
-(IBAction)fncTapBtnGetDeviceToken:(id)sender{
    
    NSData   *dataDeviceToken = [(AppDelegate*)[[UIApplication sharedApplication] delegate] deviceToken];
    
    if( dataDeviceToken != nil ){
        
        //デバイストークンをラベルにセット
        self.m_DeviceTokenFlg = YES;
        self.m_LblDeviceTokenInfo.text = dataDeviceToken.description;
        
        //デバイストークンの送信ボタンの有効化チェック
        if( (self.m_DeviceTokenFlg == YES) && (self.m_ConnectionFlg == YES) ){
            self.m_BtnSendDeviceToken.userInteractionEnabled = YES;
            self.m_BtnSendDeviceToken.alpha = 1;
        }
    }
}

//サーバーと接続
-(IBAction)fncTapBtnConnectionToServer:(id)sender{
    
    [self.m_ClientController fncInitClientFunction];
    [self.m_ClientController fncConnectionToServer];
    [self fncRewriteConnectionStatus];
    
    if(self.m_ClientController.m_nConnectionState == kWHILE_CONNECT){
        self.m_ConnectionFlg = YES;
    }
    
    //デバイストークンの送信ボタンの有効化チェック
    if( (self.m_DeviceTokenFlg == YES) && (self.m_ConnectionFlg == YES) ){
        self.m_BtnSendDeviceToken.userInteractionEnabled = YES;
        self.m_BtnSendDeviceToken.alpha = 1;
    }
}

//デバイストークン送信
-(IBAction)fncTapBtnSendDeviceToken:(id)sender{
    
    //デバイストークンとサーバーとの接続があれば、デバイストークンを送信
    if( (self.m_DeviceTokenFlg == YES) && (self.m_ConnectionFlg == YES) ){
        
        NSData   *dataDeviceToken = [(AppDelegate*)[[UIApplication sharedApplication] delegate] deviceToken];
        [self.m_ClientController fncSendToServer:dataDeviceToken.description];
    }
}

#pragma mark Rewrite Method

//クライアントとの接続状態の書き換え
-(void)fncRewriteConnectionStatus{
    
    switch (self.m_ClientController.m_nConnectionState) {
        case kCANT_CONNET:{
            self.m_LblConnectionStatus.text = @"サーバーと接続不可";
        }break;
        case kFAILED_SOCKET:{
            self.m_LblConnectionStatus.text = @"ソケット作成失敗";
        }break;
        case kFAILED_CONNECT:{
            self.m_LblConnectionStatus.text = @"サーバーと接続失敗";
        }break;
        case kCAN_CONNET:{
            self.m_LblConnectionStatus.text = @"サーバーと接続可";
        }break;
        case kWHILE_CONNECT:{
            self.m_LblConnectionStatus.text = @"サーバーと接続中";
        }break;
        case kBREAK_CONNECTION:{
            self.m_LblConnectionStatus.text = @"サーバーと接続が切れました";
        }break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
