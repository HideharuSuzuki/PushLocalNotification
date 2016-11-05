//
//  ViewController.m
//  PushLocalNotificationClient
//
//  Created by Suzuki Hideharu on 2016/11/03.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

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
    
    self.m_ClientController = [ClientController defaultCustomerController];
    [self.m_ClientController fncInitClientFunction];
    
    if( [self.m_ClientController fncConnectionToServer] == -1 ){
        self.m_LblConnectionStatus.text = @"サーバーと接続失敗";
        return;
    }
    
    self.m_LblConnectionStatus.text = @"サーバーと接続中";
    
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
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
