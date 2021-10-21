//
//  SplashViewController.m
//  iOS_AutoTest
//
//  Created by TGCenter on 2019/10/16.
//  Copyright © 2019 TGCenter. All rights reserved.
//

#import "SplashViewController.h"
@import TaurusXAds;
#import "Masonry.h"
#import "macro.h"
#import "UIView+Toast.h"

@interface SplashViewController () <TXADSplashAdDelegate>
@property (nonatomic, strong) TXADSplashAd *splashAd;
@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kTopBarSafeHeight);
        make.bottom.equalTo(self.view.mas_top).offset(kTopBarSafeHeight+20);
    }];
    
    UILabel *titleLab =  [[UILabel alloc]init];
    titleLab.text = self.titleStr;
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [header addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(header);
        make.width.equalTo(@(250));
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [header addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(closePage) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"back" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header).offset(-20);
        make.centerY.equalTo(header);
        make.width.equalTo(@(50));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(header.mas_bottom).offset(1);
        make.height.equalTo(@1);
    }];
    
    UIButton *splashLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [splashLoadBtn setTitle:@"load" forState:UIControlStateNormal];
    [splashLoadBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0]  forState:UIControlStateNormal];
    [splashLoadBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [splashLoadBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [splashLoadBtn addTarget:self action:@selector(loadSplash) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:splashLoadBtn];
    
    [splashLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(200));
        make.height.equalTo(@(30));
    }];
}

- (void)closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadSplash {
    if (!useAdLoader) {
        if (self.splashAd == nil) {
            self.splashAd = [[TXADSplashAd alloc] initWithAdUnitId:self.adUnitID
                                                          uiWindow:[[UIApplication sharedApplication].windows lastObject]];
            self.splashAd.delegate = self;
        }
        [self.splashAd loadAd];
    } else {
        TXADSplashAd *ad = [TXADAdLoader getSplashAd:self.adUnitID uiWindow:[[UIApplication sharedApplication].windows lastObject]];
        ad.delegate = self;
        [TXADAdLoader loadSplashAd:self.adUnitID uiWindow:[[UIApplication sharedApplication].windows lastObject]];
    }
}

#pragma mark - TXADSplashAdDelegate
- (void)txAdSplash:(TXADSplashAd *)splashAd didReceiveAd:(TXADILineItem *)lineItem {
    NSLog(@"txAdSplash:didReceiveAd");
}

- (void)txAdSplash:(TXADSplashAd *)SplashAd didFailToReceiveAdWithError:(TXADAdError *)adError{
    NSLog(@"txAdSplash:didFailToReceiveAdWithError, error: %@", [adError getMessage]);
    [self.view makeToast:@"load failed"
                duration:3.0
                position:CSToastPositionCenter];
}

- (void)txAdSplash:(TXADSplashAd *)splashAd willPresentScreen:(TXADILineItem *)lineItem {
    NSLog(@"txAdSplash:willPresentScreen");
}

- (void)txAdSplash:(TXADSplashAd *)splashAd willLeaveApplication:(TXADILineItem *)lineItem {
    NSLog(@"txAdSplash:willLeaveApplication");
}

- (void)txAdSplash:(TXADSplashAd *)splashAd didClickSkip:(TXADILineItem *)lineItem {
    NSLog(@"txAdSplash:didClickSkip");
}

- (void)txAdSplash:(TXADSplashAd *)splashAd didDismissScreen:(TXADILineItem *)lineItem {
    NSLog(@"txAdSplash:didDismissScreen");
}

@end
