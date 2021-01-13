//
//  InterstitialViewController.m
//  iOS_AutoTest
//
//  Created by TGCenter on 2019/10/16.
//  Copyright © 2019 TGCenter. All rights reserved.
//

#import "InterstitialViewController.h"
@import TaurusXAds;
#import "Masonry.h"
#import "macro.h"
#import "UIView+Toast.h"

@interface InterstitialViewController () <TXADInterstitialAdDelegate>
@property (nonatomic, strong) TXADInterstitialAd *interstitalAd;
@property (nonatomic, strong) UIButton *showIntBtn;
@end

@implementation InterstitialViewController

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
       
    
    UIButton *testloadIntBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:testloadIntBtn];
    [testloadIntBtn setTitle:@"load" forState:UIControlStateNormal];
    [testloadIntBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0]  forState:UIControlStateNormal];
    [testloadIntBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [testloadIntBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [testloadIntBtn addTarget:self action:@selector(loadInteristial) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *testshowIntBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:testshowIntBtn];
    [testshowIntBtn setTitle:@"show" forState:UIControlStateNormal];
    [testshowIntBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0]  forState:UIControlStateNormal];
    [testshowIntBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
     [testshowIntBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [testshowIntBtn addTarget:self action:@selector(showInterstitial) forControlEvents:UIControlEventTouchUpInside];
    testshowIntBtn.enabled = NO;
    self.showIntBtn = testshowIntBtn;
    
    [testloadIntBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(30);
        make.width.equalTo(@(100));
        make.height.equalTo(@(20));
    }];
    
    [testshowIntBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-30);
        make.width.equalTo(@(100));
        make.height.equalTo(@(20));
    }];
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loadInteristial {
    if (!useAdLoader) {
        if (self.interstitalAd == nil) {
            self.interstitalAd = [[TXADInterstitialAd alloc] initWithAdUnitId:self.adUnitID];
            self.interstitalAd.delegate = self;
        }
        [self.interstitalAd loadAd];
    } else {
        TXADInterstitialAd *ad = [TXADAdLoader getInterstitialAd:self.adUnitID];
        ad.delegate = self;
        [TXADAdLoader loadInterstitialAd:self.adUnitID];
    }
}

- (void)showInterstitial {
    if (!useAdLoader) {
        if (self.interstitalAd.isReady) {
            [self.interstitalAd showFromViewController:self];
        }
    } else {
        if ([TXADAdLoader isInterstitialAdReady:self.adUnitID]) {
            [TXADAdLoader showInterstitialAd:self.adUnitID viewController:self];
        }
    }
}

#pragma mark - TXADInterstitialAdDelegate
- (void)txAdInterstitial:(TXADInterstitialAd *)interstitialAd
            didReceiveAd:(TXADILineItem *)lineItem {
    NSLog(@"txAdInterstitial:didReceiveAd");
    self.showIntBtn.enabled = YES;
}

- (void)txAdInterstitial:(TXADInterstitialAd *)interstitialAd
didFailToReceiveAdWithError:(TXADAdError *)adError{
    NSLog(@"txAdInterstitial:didFailToReceiveAdWithError, error: %@", [adError getMessage]);
    [self.view makeToast:@"load failed"
                duration:3.0
                position:CSToastPositionCenter];
}

- (void)txAdInterstitial:(TXADInterstitialAd *)interstitialAd
       willPresentScreen:(TXADILineItem *)lineItem {
    NSLog(@"txAdInterstitial:willPresentScreen");
}

- (void)txAdInterstitial:(TXADInterstitialAd *)interstitialAd
    willLeaveApplication:(TXADILineItem *)lineItem {
    NSLog(@"txAdInterstitial:willLeaveApplication");
}

- (void)txAdInterstitial:(TXADInterstitialAd *)interstitialAd
        didDismissScreen:(TXADILineItem *)lineItem {
    NSLog(@"txAdInterstitial:didDismissScreen");
    self.showIntBtn.enabled = NO;
}

- (void)txAdInterstitial:(TXADInterstitialAd *)interstitialAd
              videoStart:(TXADILineItem *)lineItem {
    NSLog(@"txAdInterstitial:videoStart");
}

- (void)txAdInterstitial:(TXADInterstitialAd *)interstitialAd
           videoComplete:(TXADILineItem *)lineItem {
    NSLog(@"txAdInterstitial:videoComplete");
}

@end
