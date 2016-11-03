//
//  ServerController.m
//  PushLocalNotificationServer
//
//  Created by Suzuki Hideharu on 2016/11/04.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import "ServerController.h"


#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/types.h>


#define PORT_NUMBER ("5000")

static ServerController *defaultServerController = nil; //static:このファイルのみアクセス可

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
        
    }
    return self;
}

#pragma mark ServerControllerDelegate

//接続状態の書き換えメソッド
-(void)fncRewriteConnectionStatus:(NSString *)a_StrRewrite{
    
    //デリゲートのオブジェクトに通信状態の書き換えメソッドを実行させる
    self.m_StrConnectionStatus = a_StrRewrite;
    if ([self.m_delegate respondsToSelector:@selector(fncRewriteConnectionStatus:)]){
        [self.m_delegate fncRewriteConnectionStatus:self.m_StrConnectionStatus];
    }
}

#pragma mark Socket Method

//サーバーソケットの接続待ち受け準備
//戻り値:エラーコード 0:エラーなし -1:エラー
-(int)fncReadyServerSocket{
    
    char nbuf[NI_MAXHOST], sbuf[NI_MAXSERV]; //NI_MAXHOST:1025 NI_MAXSERV:32 <netdb.h>で定義
    struct addrinfo hints, *res0;            //アドレス構造体のヒント
    int soc, opt, errcode;                   //ソケット ソケットオプション エラーコード
    socklen_t opt_len; //socklen_t:
    
    //ヒントのアドレス構造体作成
    memset(&hints, 0, sizeof(hints)); //0クリア
    hints.ai_family   = AF_INET;      //インターネットアドレスファミリー
    hints.ai_socktype = SOCK_STREAM;  //ストリーム型
    hints.ai_flags    = AI_PASSIVE;   //サーバーソケットを表す
    
    //ヒントのアドレス構造体からsockaddr構造体を得る
    if( (errcode = getaddrinfo(NULL, PORT_NUMBER, &hints, &res0)) != 0 ){ //getaddrinfo():ヒントからsockaddr構造体を得る
        fprintf(stderr, "getaddrinfo():%s\n", gai_strerror(errcode)); //gai_strerror():エラーコードを文章に変換
        return -1;
    }
    
    if( (errcode = getnameinfo(res0->ai_addr, res0->ai_addrlen, nbuf, sizeof(nbuf), sbuf, sizeof(sbuf),
                               NI_NUMERICHOST | NI_NUMERICSERV)) != 0 ){ //getnameinfo(): getaddrinfo()の逆、sockaddr構造体を1組のホスト名とサービス文字列に変換 NI_NUMERICHOST: NI_NUMERICSERV:
        freeaddrinfo(res0);
        fprintf(stderr, "getnameinfo():%s\n", gai_strerror(errcode));
        return -1;
    }
    
    //確認用
    fprintf(stderr, "nbuf:%s sbuf:%s\n", nbuf, sbuf);
    
    //ソケット生成
    if( (soc = socket(res0->ai_family, res0->ai_socktype, res0->ai_protocol)) == -1 ){
        perror("socket"); //perror():
        freeaddrinfo(res0);
        return -1;
    }
    
    //ソケットオプション(再利用フラグ)設定
    opt = 1;
    opt_len = sizeof(opt);
    if( setsockopt(soc, SOL_SOCKET, SO_REUSEADDR, &opt, opt_len) == -1 ){
        perror("setsockopt");
        close(soc);
        freeaddrinfo(res0);
        return -1;
    }
    
    //ソケットにアドレス指定
    if( bind(soc, res0->ai_addr, res0->ai_addrlen) == -1 ){
        perror("bind");
        close(soc);
        freeaddrinfo(res0);
        return -1;
    }
    
    //アクセスバックログの指定
    if( listen(soc, SOMAXCONN) == -1 ){ //SOMAXCONN:
        perror("listen");
        close(soc);
        freeaddrinfo(res0);
        return -1;
    }
    
    freeaddrinfo(res0);
    
    [self fncRewriteConnectionStatus:@"接続可能"]; //接続可能状態
    self.m_waittingSocket = soc;
    
    return 0;
}


//サーバーソケットの接続ループ
//引数1:接続するソケットディスクリプタ
-(void)fncAcceptLoop:(int)soc{
    
    char hbuf[NI_MAXHOST], sbuf[NI_MAXSERV]; //NI_MAXHOST:1025 NI_MAXSERV:32 <netdb.h>で定義
    struct sockaddr_storage from; //sockaddr_storage構造体:
    int acc;
    socklen_t len; //socklen_t:
    
    while(1){
        
        len = (socklen_t)sizeof(from);
        
        //接続待ち
        if( (acc = accept(soc, (struct sockaddr *)&from, &len)) == -1 ){ //accept():入出力用ソケットディスクリプタを返す
            if(errno != EINTR){
                perror("accept");
            }
            
        }else{
            
            //接続開始 - 本当のサーバーは別プロセスまたは別スレッドで送受信を行うがここではメインスレッドで行う
            getnameinfo((struct sockaddr *)&from, len, hbuf, sizeof(hbuf), sbuf, sizeof(sbuf), NI_NUMERICHOST | NI_NUMERICSERV);
            fprintf(stderr, "accept:%s:%s\n", hbuf, sbuf);
            
            //送受信ループ
            send_recv_loop(acc);
            
            //入出力用ソケットディスクリプタクローズ
            close(acc);
            acc = 0;
            
            //本当のサーバーは常にループだがここでは抜ける
            break;
        }
    }
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
        
        //ここではブレーク
        break;
        
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

















