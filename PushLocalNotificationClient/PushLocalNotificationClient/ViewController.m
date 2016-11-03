//
//  ViewController.m
//  PushLocalNotificationClient
//
//  Created by Suzuki Hideharu on 2016/11/03.
//  Copyright © 2016年 Suzuki.Works. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mDeviceTokenFlg = NO;
    self.mBtnSendDeviceToken.userInteractionEnabled = NO;
    self.mBtnSendDeviceToken.alpha = 0.1;
}

//デバイストークン取得
-(IBAction)fncTapGetDeviceToken:(id)sender{
    
    NSData   *dataDeviceToken = [(AppDelegate*)[[UIApplication sharedApplication] delegate] deviceToken];
    
    if(dataDeviceToken == FALSE){ //デバイストークンがなければリターン
        return;
    }
    
    NSString *strDeviceToken  = dataDeviceToken.description;
    self.mDeviceTokenFlg = YES;
    
    //デバイストークンをラベルにセット・送信ボタン有効
    self.mLblDeviceTokenLabel.text = strDeviceToken;
    self.mBtnSendDeviceToken.userInteractionEnabled = YES;
    self.mBtnSendDeviceToken.alpha = 1;
}

//デバイストークン送信
-(IBAction)fncTapSendDeviceToken:(id)sender{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
