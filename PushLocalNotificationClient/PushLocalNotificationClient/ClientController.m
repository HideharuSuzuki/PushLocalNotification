//
//  ClientController.m
//  PushLocalNotificationClient
//
//  Created by Suzuki Hideharu on 2016/11/05.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import "Define.h"
#import "ClientController.h"

#import <netdb.h>
#import <arpa/inet.h>

@implementation ClientController

static ClientController *defaultClientController = nil;

char sendDataBuff[1024 * 1024]; //送信データのバッファ 1MB

//シングルトン
+(ClientController *)defaultClientController{
    
    if (!defaultClientController) {
        defaultClientController = [[super allocWithZone:NULL] init];//初回のみallocation処理
    }
    return defaultClientController;
}

-(id)init
{
    if (defaultClientController) {
        return defaultClientController;
    }
    self = [super init];
    if (self) {
        
        //変数初期化処理
        self.m_nConnectionState = kCANT_CONNET;
        self.m_ioStreamSocket   = -1;
    }
    return self;
}

//クライアント機能初期化
-(void)fncInitClientFunction{
    self.m_nConnectionState = kCANT_CONNET;
    self.m_ioStreamSocket   = -1;
}

//サーバーと接続
//返り値:サーバーとの接続ソケット -1:接続失敗
-(void)fncConnectionToServer{
    
    //変数宣言・初期化
    struct sockaddr_in si;
    memset(&si, 0, sizeof(si));
    si.sin_family      = PF_INET;
    si.sin_addr.s_addr = inet_addr(IP_ADDRESS);
    si.sin_port        = htons(PORT_NUMBER);
    
    //ソケット生成
    if( (self.m_ioStreamSocket = socket(PF_INET, SOCK_STREAM, 0)) == -1 ){
        perror("ソケット作成失敗");
        self.m_nConnectionState = kFAILED_SOCKET;
        return;
    }
    
    //サーバー接続
    if( (connect(self.m_ioStreamSocket, (struct sockaddr *)&si, sizeof(si))) == -1 ){
        perror("コネクト失敗");
        close(self.m_ioStreamSocket);
        self.m_nConnectionState = kFAILED_CONNECT;
        return;
    }
    
    self.m_nConnectionState = kWHILE_CONNECT; //サーバーと接続中
}

//サーバーからデータを受信
-(void)fncReceiveFromServer{

}

//サーバーにデータを送信
-(void)fncSendToServer:(NSString *)string{
    
    const char *cString = [string UTF8String];
    memcpy(sendDataBuff, cString, strlen(cString));

    ssize_t result = send(self.m_ioStreamSocket, sendDataBuff, strlen(sendDataBuff), 0);
    if ( result == -1 ){
        fprintf(stderr, "クライアントとの通信エラー:%s\n", strerror(errno));
    }
    close(self.m_ioStreamSocket);
}


//クライアント機能終了処理
-(void)fncFinishClientFunction{
    close(self.m_ioStreamSocket);
    self.m_ioStreamSocket = -1;
}

@end


















