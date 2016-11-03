//
//  ViewController.m
//  PushLocalNotificationServer
//
//  Created by Suzuki Hideharu on 2016/11/03.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //サーバーコントローラー初期化 & デリゲート設定
    self.m_ServerController = [ServerController defaultServerController];
    [self.m_ServerController setM_delegate:self];
    
    //サーバーコントローラー接続準備
    int errorCode = [self.m_ServerController fncReadyServerSocket];
    if( errorCode == -1 ){
        [self.m_LblConnectionStatus setText:@"接続準備に失敗"];
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.m_ServerController fncAcceptLoop:self.m_ServerController.m_waittingSocket];
}

#pragma mark ServerControllerDelegate

//接続状態の書き換え
-(void)fncRewriteConnectionStatus:(NSString *)a_String{
    [self.m_LblConnectionStatus setText:a_String];
}

//通知の種類のセグメントコントローラーを選択
-(IBAction)fncTapScNotification:(id)sender{

}

//通知の送信ボタン
-(IBAction)fncTapBtnSendNotification:(id)sender{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
