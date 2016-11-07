//
//  Define.h
//  PushLocalNotificationServer
//
//  Created by Suzuki Hideharu on 2016/11/05.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#define PORT_NUMBER (5000)


//クライアントとの接続状態
enum CONNECTION_CLIENT_STATUS{
    kCANT_CONNET,          //クライアントと接続不可
    kFAILED_SOCKET,        //ソケット作成失敗
    kFAILED_SOCKET_OPTION, //ソケットオプションの設定失敗
    kFAILED_BIND,          //バインド失敗
    kFAILED_SET_QUEUE,     //接続待ちキュー設定の失敗
    kCAN_CONNET,           //クライアントと接続可
    kWHILE_CONNECT,        //クライアントと接続中
    kBREAK_CONNECTION      //クライアントと接続が切れました
};