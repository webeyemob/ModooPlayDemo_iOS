//
//  AntiAddictionViewController.m
//  ModooPlayDemo_iOS
//
//  Created by hang.wang on 2021/2/4.
//  Copyright © 2021 ModooPlay. All rights reserved.
//

#import "AntiAddictionViewController.h"
#import "UIView+Toast.h"
@import AntiAddictionKit;

#define DEBUG 1 // 是否 Debug 模式，显示 toast

/**
 1、确保 Xcode 工程的 Build Settings 的 Always Embed Swift Standard Libraries 为 Yes，即 始终引入 Swift 标准库，避免 App 启动时报错 无法找到 Swift 标准库之类。
 如果未设置，低于 iOS 13 版本的 iPhone 启动 App 时会因缺少 Swift 标准库而闪退。
 
 2、添加依赖库 libc++.tbd。
 */
@interface AntiAddictionViewController () <AntiAddictionCallback>
@property (strong, nonatomic) IBOutlet UIButton *back;
@property (strong, nonatomic) IBOutlet UIButton *login;
@property (strong, nonatomic) IBOutlet UIButton *logout;
@property (strong, nonatomic) IBOutlet UIButton *pay;
@property (strong, nonatomic) IBOutlet UIButton *chat;
@property (strong, nonatomic) IBOutlet UIButton *openRealName;
@end

static BOOL hasUserLogin = NO;

@implementation AntiAddictionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 功能开关配置（采用默认值可跳过）
    [self setFunctionConfig];
    // 功能参数配置（采用默认值可跳过）
    [self setCommonConfig];
    // 初始化
    [self initAntiAddiction];
    
    [self switchUI:hasUserLogin];
}

// 功能开关配置（采用默认值可跳过）
// 请根据实际的需求设置（默认全部开启）
- (void)setFunctionConfig {
    // 是否使用 SDK 实名认证功能（默认开启）
    AntiAddictionKit.configuration.useSdkRealName = YES;
    // 是否使用 SDK 付费限制（默认开启）
    AntiAddictionKit.configuration.useSdkPaymentLimit = YES;
    // 是否使用 SDK 在线时长限制（默认开启）
    AntiAddictionKit.configuration.useSdkOnlineTimeLimit = YES;
    
    // 是否显示切换账号按钮（默认开启）
    // 单机游戏无账号系统可设置为 NO 隐藏该按钮
    AntiAddictionKit.configuration.showSwitchAccountButton = YES;
}

// 功能参数配置（采用默认值可跳过）
// 请根据实际的需求调整参数
- (void)setCommonConfig {
    // 游戏时长限制配置（单位秒）
    // 未成年人非节假日游戏限制时长（默认 90 分钟）
    AntiAddictionKit.configuration.minorCommonDayTotalTime = 90 * 60;
    // 未成年人节假日游戏限制时长（默认 180 分钟）
    AntiAddictionKit.configuration.minorHolidayTotalTime = 180 * 60;
    // 游客用户（未实名）节假日游戏限制时长（默认 60 分钟）
    AntiAddictionKit.configuration.guestTotalTime = 60 * 60;
    // 第一次提醒用户时的剩余时长（默认 15 分钟）
    AntiAddictionKit.configuration.firstAlertTipRemainTime = 15 * 60;
    // 开始倒计时提醒用户时的剩余时长（默认 1 分钟）
    AntiAddictionKit.configuration.countdownAlertTipRemainTime = 1 * 60;
    
    // 宵禁配置（单位小时，24 小时制）
    // 未成年人防沉迷宵禁开始时间（默认晚上 10 点）
    AntiAddictionKit.configuration.curfewHourStart = 22;
    // 未成年人防沉迷宵禁结束时间（默认早上 8 点）
    AntiAddictionKit.configuration.curfewHourEnd = 8;
    
    // 支付限制金额配置（单位分）
    // 8-15 岁单笔付费额度限制（默认 50 元）
    AntiAddictionKit.configuration.singlePaymentAmountLimitJunior = 50 * 100;
    // 8-15 岁每月总付费额度限制（默认 200 元）
    AntiAddictionKit.configuration.mouthTotalPaymentAmountLimitJunior = 200 * 100;
    // 16-17 岁单笔付费额度限制（默认 100 元）
    AntiAddictionKit.configuration.singlePaymentAmountLimitSenior = 100 * 100;
    // 16-17岁每月总付费额度限制（默认 400 元）
    AntiAddictionKit.configuration.mouthTotalPaymentAmountLimitSenior = 400 * 100;
}

// 初始化 AntiAddiction
- (void)initAntiAddiction {
    [AntiAddictionKit init:self];
}

# pragma mark - AntiAddictionCallback
- (void)onAntiAddictionResult:(NSInteger)code :(NSString * _Nonnull)message {
    switch (code) {
        case ANTI_ADDICTION_RESULT_TIME_LIMIT:
            // 时间受限
            // 未成年人或游客游戏时长已达限制，通知游戏
            [self logAndToast:@"Time Limit" message:message];
            break;
        case ANTI_ADDICTION_RESULT_AAK_WINDOW_SHOWN:
            // 额外弹窗显示，包括时间受限等
            // 当用户操作触发额外窗口显示时通知游戏
            [self logAndToast:@"AAK Window Shown" message:message];
            break;
        case ANTI_ADDICTION_RESULT_AAK_WINDOW_DISMISS:
            // 额外弹窗消失，包括时间受限等
            // 额外窗口消失时通知游戏
            [self logAndToast:@"AAK Window Dismiss" message:message];
            break;
            
        case ANTI_ADDICTION_RESULT_LOGIN_SUCCESS:
            // 登录成功
            // 当游戏调用 login 后，直接进入游戏或完成实名认证后触发
            [self logAndToast:@"Login Success" message:message];
            hasUserLogin = YES;
            [self switchUI:YES];
            break;
        case ANTI_ADDICTION_RESULT_SWITCH_ACCOUNT:
            // 登出、切换账号
            // 当用户因防沉迷机制受限时，登录认证失败或选择切换账号时会触发
            [self logAndToast:@"Switch Account" message:message];
            hasUserLogin = NO;
            [self switchUI:NO];
            break;
            
        case ANTI_ADDICTION_RESULT_PAY_NO_LIMIT:
            // 付费不受限
            [self logAndToast:@"Pay No Limit" message:message];
            // 可以执行付费逻辑，单位为分
            [self dealPay:10 * 100];
            break;
        case ANTI_ADDICTION_RESULT_PAY_LIMIT:
            // 付费受限
            // 包括游客未实名或付费额达到限制等
            [self logAndToast:@"Pay Limit" message:message];
            break;
            
        case ANTI_ADDICTION_RESULT_CHAT_NO_LIMIT:
            // 聊天无限制
            // 用户已通过实名，可进行聊天
            [self logAndToast:@"Chat No Limit" message:message];
            break;
        case ANTI_ADDICTION_RESULT_CHAT_LIMIT:
            // 聊天限制
            // 用户未通过实名，不可进行聊天
            [self logAndToast:@"Chat Limit" message:message];
            break;
            
        case ANTI_ADDICTION_RESULT_REAL_NAME_COMPLETED:
            // 实名成功
            // 仅当主动调用 openRealName 时，如果成功会触发
            [self logAndToast:@"Real Name Completed" message:message];
            break;
        case ANTI_ADDICTION_RESULT_REAL_NAME_CANCELLED:
            // 实名失败
            // 仅当主动调用 openRealName 时，如果用户取消会触发
            [self logAndToast:@"Real Name Cancelled" message:message];
            break;
        default:
            break;
    }
}

- (void)logAndToast:(NSString *)toast message:(NSString *)message {
    if (DEBUG) {
        [self.view makeToast:[NSString stringWithFormat:@"%@: %@", toast, message]
                    duration:2.0
                    position:CSToastPositionCenter];
    }
    NSLog(@"%@", [NSString stringWithFormat:@"AntiAddictionViewController onAntiAddictionResult: %@, %@", toast, message]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 登录
- (IBAction)login:(id)sender {
    // userId 类型为字符串，用于表示用户唯一标识，除 null 和 "" 等特殊字符串外无其他限制
    // type 固定为 0
    [AntiAddictionKit login:@"userId" :0];
}

// 登出
- (IBAction)logout:(id)sender {
    // 当用户在游戏内点击登出或退出账号时调用该接口
    [AntiAddictionKit logout];
}

// 付费
- (IBAction)pay:(id)sender {
    // 游戏在收到用户的付费请求后，调用 SDK 的对应接口来判断当前用户的付费行为是否被限制
    // 如果没有实名，会弹出实名认证界面
    // 参数表示付费的金额，单位为分
    [AntiAddictionKit checkPayLimit:10 * 100];
}

// 付费并更新用户状态
- (void)dealPay:(int)num {
    // 执行具体的付费流程
    // ...

    // 当用户完成付费行为时，游戏需要通知 SDK，更新用户状态
    // 参数为本次充值的金额，单位为分
    [AntiAddictionKit paySuccess:num];
}

// 聊天
- (IBAction)chat:(id)sender {
    // 游戏在需要聊天时，调用 SDK 接口判断当前用户是否实名
    // 如果没有实名，会弹出实名认证界面
    [AntiAddictionKit checkChatLimit];
}

// 进入聊天页面
- (void)gotoChatPage {
    // ...
}

// 打开实名认证
- (IBAction)openRealName:(id)sender {
    // 除了付费、聊天、时长限制时，有其他场景需要主动打开实名窗口，则可以通过该接口让用户进行实名，否则不需要调用该接口
    // 如果用户实名过了，调用 openRealName 会直接回调 ANTI_ADDICTION_RESULT_LOGIN_SUCCESS
    [AntiAddictionKit openRealName];
}

- (void)switchUI:(BOOL)hasLogin {
    if (hasLogin) {
        self.login.enabled = NO;
        self.logout.enabled = YES;
        self.pay.enabled = YES;
        self.chat.enabled = YES;
        self.openRealName.enabled = YES;
    } else {
        self.login.enabled = YES;
        self.logout.enabled = NO;
        self.pay.enabled = NO;
        self.chat.enabled = NO;
        self.openRealName.enabled = NO;
    }
}

@end
