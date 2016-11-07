//
//  ClientController.h クライアント機能クラス
//  PushLocalNotificationClient
//
//  Created by Suzuki Hideharu on 2016/11/05.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientController : NSObject

@property (nonatomic) int m_nConnectionState; //サーバーとの接続状態 Define.hで定義
@property (nonatomic) int m_ioStreamSocket; //(入出力用)ソケットディスクリプタ -1:使用不可

+(ClientController *)defaultClientController; //シングルトンで初期化

//ソケット通信メソッド
-(void)fncInitClientFunction;//クライアント機能初期化処理
-(void)fncConnectionToServer;//サーバーと接続
-(void)fncReceiveFromServer;//サーバーからデータを受信
-(void)fncSendToServer:(NSString *)string;  //サーバーにデータを送信
-(void)fncFinishClientFunction; //クライアント機能終了処理

@end
