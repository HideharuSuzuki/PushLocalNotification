//
//  ClientController.m
//  PushLocalNotificationClient
//
//  Created by Suzuki Hideharu on 2016/11/05.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import "ClientController.h"

#include <netdb.h>

@implementation ClientController

static ClientController *defaultCustomerController = nil;

char sendDataBuff[1024 * 1024]; //送信データのバッファ 1MB

//シングルトン
+(ClientController *)defaultCustomerController{
    
    if (!defaultCustomerController) {
        defaultCustomerController = [[super allocWithZone:NULL] init];//初回のみallocation処理
    }
    return defaultCustomerController;
}

-(id)init
{
    if (defaultCustomerController) {
        return defaultCustomerController;
    }
    self = [super init];
    if (self) {
        
        //変数初期化処理
        self.m_ioSocket = -1;
    }
    return self;
}

//クライアント機能初期化
-(void)fncInitClientFunction{
    
    self.m_ioSocket = -1;
    
}

//サーバーと接続
//返り値:サーバーとの接続ソケット -1:接続失敗
-(int)fncConnectionToServer{
    
    //変数宣言・初期化
    int  ioSocket;
    char nbuf[NI_MAXHOST], sbuf[NI_MAXSERV]; //ノード名バッファ サービス名バッファNI_MAXHOST:ホスト名文字列の最大長 NI_MAXSERV:サービス名文字列の最大長
    char *hostName   = "Suzuki Hideharu の iPad1"; //サーバーのホスト名
    char *portNumber = "5000";//サーバーのポート番号
    struct addrinfo hints, *res0;//サーバーのアドレス構造体
    int errorCode;
    
    //サーバーのアドレス構造体のヒントを作成
    memset(&hints, 0, sizeof(hints)); //ゼロクリア
    hints.ai_family   = AF_INET;      //インターネットアドレスファミリー
    hints.ai_socktype = SOCK_STREAM;
    
    //名前解決(ノード名とサービス名を含むaddrinfo構造体からアドレス情報を含むaddrinfo構造体に変換)
    if( (errorCode = getaddrinfo(hostName, portNumber, &hints, &res0)) != 0 ){
        fprintf(stderr, "getaddrinfo():%s\n", gai_strerror(errorCode));
        return -1;
    }
    
    //アドレス情報を含むaddrinfo構造体からノード名とサービス名を含むaddrinfo構造体に変換
    if( (errorCode = getnameinfo(res0->ai_addr, res0->ai_addrlen, nbuf, sizeof(nbuf), sbuf, sizeof(sbuf),
                                 NI_NUMERICHOST | NI_NUMERICSERV)) != 0 ){
        
        freeaddrinfo(res0);
        fprintf(stderr, "getnameinfo():%s\n", gai_strerror(errorCode));
        return -1;
    }
    
    //ソケット生成
    if( (ioSocket = socket(res0->ai_family, res0->ai_socktype, res0->ai_protocol)) == -1 ){
        perror("ソケット作成失敗");
        freeaddrinfo(res0);
        return -1;
    }
    
    //サーバー接続
    if(connect(ioSocket, res0->ai_addr, res0->ai_addrlen) == -1){
        perror("コネクト失敗");
        close(ioSocket);
        freeaddrinfo(res0);
        return -1;
    }

    freeaddrinfo(res0); //addrinfo構造体解放
    self.m_ioSocket = ioSocket;
    
    return ioSocket;
}

//クライアント機能終了処理
-(void)fncFinishClientFunction{
    close(self.m_ioSocket);
    self.m_ioSocket = -1;
}

@end


















