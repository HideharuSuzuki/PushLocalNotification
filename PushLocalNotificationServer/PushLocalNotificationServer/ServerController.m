//
//  ServerController.m
//  PushLocalNotificationServer
//
//  Created by Suzuki Hideharu on 2016/11/04.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ServerViewController.h"

#import "Define.h"
#import "ServerController.h"

#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/types.h>


static ServerController *defaultServerController = nil; //static:このファイルのみアクセス可

char receiveBuff[1024 * 1024]; //受信バッファ 1MB

@implementation ServerController

//シングルトン
+(ServerController *)defaultServerController{
    
    if (!defaultServerController) {
        defaultServerController = [[super allocWithZone:NULL] init];//初回のみallocation処理
    }
    
    return defaultServerController;
}

-(id)init
{
    if (defaultServerController) {
        return defaultServerController;
    }
    self = [super init];
    if (self) {
        
        //初期化処理
        self.m_nConnectionState = -1;
        self.m_waittingSocket = -1;
        self.m_ioStreamSocket = -1;
    }
    return self;
}

#pragma mark Socket Method

//サーバー機能初期化処理
-(void)fncInitServerFunction{
    self.m_nConnectionState = -1;
    self.m_waittingSocket = -1;
    self.m_ioStreamSocket = -1;
}

//サーバーソケットの接続待ち受け準備
-(void)fncStartServerFunction{
    
    //アドレス構造体作成(サーバー側)
    struct sockaddr_in name;
    name.sin_family = PF_INET; //アドレスファミリー
    name.sin_port = (in_port_t)htons(PORT_NUMBER); //ポート番号
    name.sin_addr.s_addr = htonl(INADDR_ANY);

    //ソケット生成
    if( (self.m_waittingSocket = socket(PF_INET, SOCK_STREAM, 0)) == -1 ){
        perror("socket"); //perror():
        self.m_nConnectionState = kFAILED_SOCKET;
        return;
    }
    
    //ソケットオプション設定(再利用フラグ)
    int option = 1;
    if( setsockopt(self.m_waittingSocket, SOL_SOCKET, SO_REUSEADDR, (char *)&option, sizeof(option)) == -1 ){
        perror("setsockopt");
        close(self.m_waittingSocket);
        self.m_nConnectionState = kFAILED_SOCKET_OPTION;
        return;
    }
    
    //バインド
    if( bind(self.m_waittingSocket, (struct sockaddr *)&name, sizeof(name)) == -1 ){
        perror("bind");
        close(self.m_waittingSocket);
        self.m_nConnectionState = kFAILED_BIND;
        return;
    }
    
    //アクセスバックログの指定(接続待ちのキュー)
    if( listen(self.m_waittingSocket, SOMAXCONN) == -1 ){ //SOMAXCONN:
        perror("listen");
        close(self.m_waittingSocket);
        self.m_nConnectionState = kFAILED_SET_QUEUE;
        return;
    }
    
    self.m_nConnectionState = kCAN_CONNET; //クライアントと接続可
}

//サーバーソケットの接続待ち受けループ - TODO:ノンブロッキング化
-(void)fncWattingAccept{
    
    if(self.m_nConnectionState == kCAN_CONNET){
        
        struct sockaddr_storage client_addr;
        unsigned int address_size = sizeof(client_addr);

        while(1){
            
            if( ( self.m_ioStreamSocket = accept(self.m_waittingSocket, (struct sockaddr *)&client_addr, &address_size) ) != -1 ){
                
                NSLog(@"accept");
                
                //接続開始
                self.m_nConnectionState = kWHILE_CONNECT;
                break;
                
                
            }else{

                NSLog(@"accept failed:%d",errno);
                //ここではリターンしない
            }
        }//end while
    }
}

//クライアントからデータの受信
-(void)fncRecvFromClient{
    
    ssize_t recvData;
//    char *ptr;
    if( (recvData = recv(self.m_ioStreamSocket, receiveBuff, sizeof(receiveBuff), 0)) == -1 ){
        perror("recv");
        //break;
    }
//    while(1){
//        
//
//        
//        //クライアント側の切断
//        if( recvData == 0 ){
//            perror("recv:EOF");
//            break;
//        }
//        
////        //ヌル文字を最後に追加、文字列化
////        receiveBuff[recvData] = '\0';
////        if( (ptr = strpbrk(receiveBuff, "\r\n")) != NULL ){ //strpbrk():
////            *ptr = '\0';
////        }
//        
//    }
    self.m_StrDeviceToken = [NSString stringWithCString:receiveBuff encoding:NSUTF8StringEncoding];
    
}

//クライアントにデータの送信
-(void)fncSendToClient{

}


//クライアントとのデータの送受信ループ
//引数1:入出力用ソケットディスクリプタ
void send_recv_loop(int acc){
    
    char buf[512]; //受信用バッファ
    char *ptr;     //
    ssize_t len;   //受信サイズ ssize_t:
    
    while(1){
        
        //データ受信
        if( (len = recv(acc, buf, sizeof(buf), 0)) == -1 ){
            perror("recv");
            break;
        }
        
        if( len == 0 ){
            fprintf(stderr, "recv:EOF\n");
            break;
        }
        
        //ヌル文字を最後に追加、文字列化
        buf[len] = '\0';
        if( (ptr = strpbrk(buf, "\r\n")) != NULL ){ //strpbrk():
            *ptr = '\0';
        }
        
        fprintf(stderr, "[client]%s\n", buf);
        
        //応答文字列作成
        mystrlcat(buf, ":OK\r\n", sizeof(buf));
        len = (ssize_t)strlen(buf);
        
        //送信
        if( (len = send(acc, buf, (size_t)len, 0)) == -1 ){
            perror("send");
            break;
        }
                
    }//end while
    
}

//サイズ指定文字列連結 (strlcat()と同等の機能だがLinuxでは使えないため自作)
//引数1:  2:  3:
//戻り値:
size_t mystrlcat(char *dst, const char *src, size_t size){
    
    const char *ps;    //ps:
    char  *pd, *pde;   //pd: pde:
    size_t dlen, lest; //dlen: lest:
    
    //pd = pde, lest = size    : 初期化
    //*pd != '\0' && lest != 0 : 継続条件
    //pd++, lest--             : 終了処理
    for (pd = dst, lest = size; *pd != '\0' && lest != 0; pd++, lest--); //この書き方やばい...
    
    dlen = pd - dst;
    
    if( size - dlen == 0 ){
        return (dlen + strlen(src));
    }
    
    pde = dst + size - 1;
    
    for( ps = src; *ps != '\0' && lest != 0; pd++, ps++ ){
        *pd = *ps;
    }
    
    for(; pd < pde; pd++){
        *pd = '\0';
    }
    
    while(*ps++);
    
    return (dlen + (ps - src - 1));
}

@end

















