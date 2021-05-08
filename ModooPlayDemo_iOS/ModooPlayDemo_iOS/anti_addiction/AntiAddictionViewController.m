//
//  AntiAddictionViewController.m
//  ModooPlayDemo_iOS
//
//  Created by hang.wang on 2021/2/4.
//  Copyright © 2021 ModooPlay. All rights reserved.
//

#import "AntiAddictionViewController.h"
#import "UIView+Toast.h"
@import AntiAddiction;
#import "RealNameView.h"

#define DEBUG 1 // 是否 Debug 模式，显示 toast

/**
 1、确保 Xcode 工程的 Build Settings 的 Always Embed Swift Standard Libraries 为 Yes，即 始终引入 Swift 标准库，避免 App 启动时报错 无法找到 Swift 标准库之类。
 如果未设置，低于 iOS 13 版本的 iPhone 启动 App 时会因缺少 Swift 标准库而闪退。
 
 2、添加依赖库 libc++.tbd。
 */
@interface AntiAddictionViewController () <AntiAddictionRealNameDelegate, AntiAddictionTimeLimitDelegate, AntiAddictionEventDelegate>

@property (weak, nonatomic) IBOutlet UIButton *realNameBtn;

@property (weak, nonatomic) IBOutlet UIButton *realNamePageBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeLimitBtn;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic, strong) RealNameView *popView;

@end

@implementation AntiAddictionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [AntiAddictionSdk setAutoShowTimeLimitPage:YES];
    
    [AntiAddictionEventManager registerDelegate:self];
}

- (IBAction)back:(id)sender {
    [AntiAddictionEventManager unRegisterDelegate:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doRealName:(id)sender {
    [AntiAddictionSdk realName:self];
}

- (IBAction)openRealNameDialog:(id)sender {
    if (self.popView == nil) {
        self.popView = [[RealNameView alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 40, 250)];
        self.popView.center = self.view.center;
        [self.view addSubview:self.popView];
        
        __weak typeof(self) weakSelf = self;
        __block AntiAddictionViewController *strongBlock = self;
        
        [self.popView setClickCallBack:^(NSString *name, NSString *idNumber) {
            if (name == nil || [name length] < 2 || idNumber == nil || [idNumber length] != 18) {
                [weakSelf logAndToast:@"real name input error " message:@"real name input error "];
            } else {
                [AntiAddictionSdk realName:99 name:name idNumber:idNumber delegate:strongBlock];
                weakSelf.popView.hidden = YES;
            }
        }];
        
        [self.popView setCloseCallBack:^{
            weakSelf.popView.hidden = YES;
        }];
    } else {
        self.popView.hidden = NO;
    }
    
}

- (IBAction)timeLimitPop:(id)sender {
    [AntiAddictionSdk setAutoShowTimeLimitPage:NO];
    [AntiAddictionSdk registerTimeLimitDelegate:self];
}

- (IBAction)getUserInfo:(id)sender {
    AntiAddictionUser *user = [AntiAddictionSdk getUser];
    
    NSString *info = @"游客";
    if ([user isTourist]) {
        info = @"游客";
    } else if ([user isChild]) {
        info = @"未成年人";
    } else if ([user isAdult]) {
        info = @"成年人";
    }
    
    NSString *resultStr;
    if (user.realNameResult != nil) {
        AntiAddictionRealNameResult *result = user.realNameResult;
        
        if ([result isSuccess]) {
            resultStr = @"实名认证成功";
        } else if ([result isFail]) {
            resultStr = @"实名认证失败";
        } else if ([result isProcessing]) {
            resultStr = @"实名认证中...";
        } else {
            resultStr = @"初始状态";
        }
    }
    
    int age = [user getAge];
    
    NSString *message = [NSString stringWithFormat:@"%@ 认证状态: %@ 年龄：%d", info, resultStr, age];
    
    [self logAndToast:@"user info" message:message];
}

- (IBAction)logOut:(id)sender {
    [AntiAddictionSdk logOut];
}

# pragma mark - AntiAddictionRealNameDelegate
- (void)onFinish:(AntiAddictionUser *)user {
    AntiAddictionRealNameResult *result = user.realNameResult;
    NSString *resultStr;
    if ([result isSuccess]) {
        resultStr = @"实名认证成功";
    } else if ([result isFail]) {
        resultStr = @"实名认证失败";
    } else if ([result isProcessing]) {
        resultStr = @"实名认证中...";
    } else {
        resultStr = @"初始状态";
    }
    
    [self logAndToast:@"real name result" message:resultStr];
    
    
}

# pragma mark - AntiAddictionTimeLimitDelegate
- (void)onTimeLimit:(AntiAddictionTimeLimit *)timeLimit {
    [self logAndToast:@"time limit info" message:[timeLimit description]];
    
}

- (void)logAndToast:(NSString *)toast message:(NSString *)message {
    if (DEBUG) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.view makeToast:[NSString stringWithFormat:@"%@: %@", toast, message]
                    duration:2.0
                    position:CSToastPositionCenter];
        });
    }
    NSLog(@"%@", [NSString stringWithFormat:@"AntiAddictionViewController onAntiAddictionResult: %@, %@", toast, message]);
}

#pragma mark <AntiAddictionEventDelegate>
- (void)onRealName:(AntiAddictionRealNameEvent *)event {
    NSLog(@"####### event is %@ #######", [event description]);
}

- (void)onTimeLimt:(AntiAddictionTimeLimitEvent *)event {
    NSLog(@"+++++++ event is %@ ++++++", [event description]);
}

@end
