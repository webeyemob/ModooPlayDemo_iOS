//
//  FeedListViewController.m
//  iOS_AutoTest
//
//  Created by TGCenter on 2019/10/16.
//  Copyright © 2019 TGCenter. All rights reserved.
//

#import "FeedListViewController.h"
@import TaurusXAds;
#import "Masonry.h"
#import "macro.h"
#import "UIView+Toast.h"

@interface FeedListViewController () <TXADFeedListDelegate>
@property (nonatomic, strong) TXADFeedList *feedListAd;
@property (nonatomic, strong) TXADNativeAdLayout *nativeLayout;
@property (nonatomic) int currentIndex;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray<TXADFeed *> *feedArray;
@property (nonatomic, strong) UIView *adContainer;
@end

@implementation FeedListViewController

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
       
    
    UIButton *loadNativeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:loadNativeBtn];
    [loadNativeBtn setTitle:@"load" forState:UIControlStateNormal];
    [loadNativeBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0]  forState:UIControlStateNormal];
    [loadNativeBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [loadNativeBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [loadNativeBtn addTarget:self action:@selector(loadFeedList) forControlEvents:UIControlEventTouchUpInside];
    
    [loadNativeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(200));
        make.height.equalTo(@(20));
    }];
    
    self.nativeLayout = [TXADNativeAdLayout getLargeLayout1WithWidth:ScreenWidth-10];
    
    UIView *adView = [[UIView alloc] init];
    // 展示广告
    [adView setBackgroundColor:[UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1]];
    [self.view addSubview:adView];
    adView.layer.borderColor = [UIColor colorWithRed:36.0/255.0 green:189.0/255.0 blue:155.0/255.0 alpha:1].CGColor;
    adView.layer.cornerRadius = 10;
    adView.layer.borderWidth = 2;
    
    self.adContainer = adView;
    
    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loadNativeBtn.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-10);
    }];
}

- (void)closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadFeedList {
    if (!useAdLoader) {
        if (self.feedListAd == nil) {
            self.feedListAd = [[TXADFeedList alloc] initWithAdUnitId:self.adUnitID];
            self.feedListAd.delegate = self;
            [self.feedListAd setCount:3];
        }
        [self.feedListAd setExpressAdSize:CGSizeMake(360, 240)];
        [self.feedListAd setMuted:NO];
        [self.feedListAd loadAd];
    } else {
        TXADFeedList *ad = [TXADAdLoader getFeedListAd:self.adUnitID];
        ad.delegate = self;
        [TXADAdLoader loadFeedListAd:self.adUnitID count:3];
    }
}

- (void)showFeed {
    if (self.currentIndex < self.feedArray.count) {
        TXADFeed *feed = self.feedArray[self.currentIndex];
        UIView *adView = [feed getAdView:self.nativeLayout];
        
        for (UIView *subView in self.adContainer.subviews) {
            [subView removeFromSuperview];
        }
        [self.adContainer addSubview:adView];
        
        adView.center = self.adContainer.center;
        
        self.currentIndex++;
        
        if (self.currentIndex < self.feedArray.count) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                          target:self
                                                        selector:@selector(showFeed)
                                                        userInfo:nil
                                                         repeats:NO];
        }
    }
}

#pragma mark - TXADFeedListDelegate
- (void)txAdFeedList:(TXADFeedList *)feedList
        didReceiveAd:(TXADILineItem *)lineItem {
    if (!useAdLoader) {
        self.feedArray = [self.feedListAd getFeedArray];
    } else {
        self.feedArray = [TXADAdLoader getFeedListAds:self.adUnitID];
    }
    NSLog(@"txAdFeedList:DidReceiveAd, count: %d", self.feedArray.count);
    
    self.currentIndex = 0;
    if (self.timer != nil) {
        [self.timer invalidate];
    }
    [self showFeed];
}

- (void)txAdFeedList:(TXADFeedList *)feedList
didFailToReceiveAdWithError:(TXADAdError *)adError {
    NSLog(@"TXADFeedList txAdFeedList:didFailToReceiveAdWithError, error: %@", [adError getMessage]);
    [self.view makeToast:@"load failed"
                duration:3.0
                position:CSToastPositionCenter];
}

- (void)txAdFeedList:(TXADFeedList *)feedList
   willPresentScreen:(TXADILineItem *)lineItem
                feed:(TXADFeed *)feed {
    NSLog(@"txAdFeedList:willPresentScreen:feed");
}

- (void)txAdFeedList:(TXADFeedList *)feedList
willLeaveApplication:(TXADILineItem *)lineItem
                feed:(TXADFeed *)feed {
    NSLog(@"txAdFeedList:willLeaveApplication:feed");
}

- (void)txAdFeedList:(TXADFeedList *)feedList
    didDismissScreen:(TXADILineItem *)lineItem
                feed:(TXADFeed *)feed {
    NSLog(@"txAdFeedList:didDismissScreen:feed");
}

@end
