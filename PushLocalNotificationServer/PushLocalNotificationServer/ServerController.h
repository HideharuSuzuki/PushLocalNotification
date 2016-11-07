//
//  ServerController.h
//  PushLocalNotificationServer
//
//  Created by Suzuki Hideharu on 2016/11/04.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerController : NSObject

@property (strong,nonatomic) NSString *m_StrDeviceToken; //デバイストークン

@property (nonatomic) int m_nConnectionState; //クライアントとの接続状態 Define.hで定義
@property (nonatomic) int m_waittingSocket;   //(接続待ち用)ソケットディスクリプタ
@property (nonatomic) int m_ioStreamSocket;   //(入出力用)ソケットディスクリプタ

+(ServerController *)defaultServerController; //シングルトンで初期化

//ソケット通信メソッド
-(void)fncInitServerFunction;  //サーバー機能初期化処理
-(void)fncStartServerFunction; //サーバー機能実行(ソケットの接続待ち受け準備)
-(void)fncWattingAccept; //サーバーソケットの接続待ち受けループ(サブスレッド)
-(void)fncRecvFromClient; //クライアントからデータを受信
-(void)fncSendToClient;   //クライアントにデータを送信
-(void)fncFinishServerFunction; //サーバー機能終了処理


@end
