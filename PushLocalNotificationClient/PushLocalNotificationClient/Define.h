//
//  Define.h
//  PushLocalNotificationClient
//
//  Created by Suzuki Hideharu on 2016/11/05.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#define IP_ADDRESS  ("172.20.10.4")
#define PORT_NUMBER (5000)

//クライアントとの接続状態
enum CONNECTION_SERVER_STATUS{
    kCANT_CONNET,      //サーバーと接続不可
    kFAILED_SOCKET,    //ソケット作成失敗
    kFAILED_CONNECT,   //サーバーと接続失敗
    kCAN_CONNET,       //サーバーと接続可
    kWHILE_CONNECT,    //サーバーと接続中
    kBREAK_CONNECTION  //サーバーと接続が切れました
};