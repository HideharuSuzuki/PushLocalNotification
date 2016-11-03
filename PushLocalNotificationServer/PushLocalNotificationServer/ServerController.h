//
//  ServerController.h
//  PushLocalNotificationServer
//
//  Created by Suzuki Hideharu on 2016/11/04.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServerControllerDelegate <NSObject>

-(void)fncRewriteConnectionStatus:(NSString *)a_String; //接続状態の書き換えメソッド

@end

@interface ServerController : NSObject

@property (strong,nonatomic) NSString     *m_StrConnectionStatus;  //接続状態を表す
@property (nonatomic)        int           m_waittingSocket; //(接続待ち用)ソケットのファイルディスクリプタ
@property (nonatomic)        int           m_ioStreamSocket; //(入出力用)ソケットのファイルディスクリプタ

@property (nonatomic, assign) id<ServerControllerDelegate> m_delegate; //自作デリゲート

+(ServerController *)defaultServerController; //初期化(シングルトン)
-(void)fncRewriteConnectionStatus:(NSString *)a_StrRewrite;  //デリゲートメソッド呼び出し(接続状態の書き換え)



-(int)fncReadyServerSocket; //サーバーソケットの接続待ち受け準備
-(void)fncAcceptLoop:(int)soc; //サーバーソケットの接続ループ
@end
