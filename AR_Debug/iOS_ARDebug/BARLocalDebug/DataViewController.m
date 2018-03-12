//
//  DataViewController.m
//  BARLocalDebug
//
//
//  Created by shangyang1027 on 2017/5/3.
//  Copyright © 2017年 ccytsoft. All rights reserved.
//

#import "DataViewController.h"
#import "BaiduARSDK.h"
#import "BARViewController.h"
#import "BARViewController+Login.h"
#import "BARSDKDelegate.h"
#import "BARConfig.h"
#import "BAR_local.h"

/*
 AR Type 说明
 
    0 --> 2D识图跟踪类型/IMU(旧版)
    5 --> SLAM
    8 --> IMU (新版)
 
 */
#define AR_TYPE 8

@interface DataViewController ()<BARSDKDelegate>
@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BaiduARSDK setBundlePath:@"BaiduAR.bundle"];
    /*设置Delegate*/
    [BaiduARSDK setSDKDelegate:self];
}

- (void)showARView:(int)type arInfo:(id)info {
    BAR_local *local = [[BAR_local alloc]init];
    [local localTest];
    BARViewController *vc = [BaiduARSDK viewController:[local jsonStr:type] arInfo:nil];

    __weak typeof(BARViewController) *weakVc = vc;
    __weak typeof(self) weakSelf = self;
    [vc setClickEventBlock:^(NSString* url) {

        if (weakSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                [weakSelf.navigationController.navigationBar setHidden:NO];
            });
        }
    }];


    [vc setCloseEventBlock:^(void){
        if (weakSelf) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            });
        }
    }];


    [vc setO2oUrlBlock:^(NSString* url){
        NSLog(@"%@", url);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        });
    }];

    [vc setShareBlock:^(NSString* title, NSString* description, BARImageShareObj* thumbImg, BARImageShareObj* shareImg,BARImageShareCompletionHandler completion){
        NSLog(@"%@", title);
        if (completion) {
            completion(0, nil, nil, nil);
        }
    }];


    [vc setShareURLBlock:^(NSString* title, NSString* description, BARImageShareObj* thumbImg, NSString * url,BARImageShareCompletionHandler completion){
        NSLog(@"%@", title);
        NSLog(@"%@", url);
        NSLog(@"%@", title);
    }];

    [self.navigationController pushViewController:vc animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)trackClicked:(id)sender {

    [self showARView:AR_TYPE arInfo:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end








