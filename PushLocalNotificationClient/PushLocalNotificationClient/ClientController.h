//
//  ClientController.h クライアント機能クラス
//  PushLocalNotificationClient
//
//  Created by Suzuki Hideharu on 2016/11/05.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientController : NSObject

@property (nonatomic) int m_ioSocket; //(入出力用)ソケットディスクリプタ -1:使用不可

+(ClientController *)defaultCustomerController; //シングルトン

//ソケット通信メソッド
-(void)fncInitClientFunction;//クライアント機能初期化処理
-(int)fncConnectionToServer;//サーバーと接続
-(void)fncSendData;  //データの送信
-(int)fncReceiveData;//データの受信
-(void)fncFinishClientFunction; //クライアント機能終了処理

@end
