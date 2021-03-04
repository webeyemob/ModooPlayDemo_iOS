//
//  MainViewController.m
//  ModooPlayDemo_iOS
//
//  Created by TGCenter on 2021/1/13.
//  Copyright © 2021 TGCenter. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+Toast.h"
#import "CustomPrivacyDialog.h"
#import "NetworkTestViewController.h"
#import "AntiAddictionViewController.h"
@import PrivacyPolicy;
@import TGCenter;
@import TGCWeChat;
#import "WXApi.h"

@interface MainViewController () <TGCWeChatLoginDelegate>
@property (strong, nonatomic) IBOutlet UIButton *adTest;
@property (strong, nonatomic) IBOutlet UIButton *userAgreement;
@property (strong, nonatomic) IBOutlet UIButton *privacyPolicy;
@property (strong, nonatomic) IBOutlet UIButton *clearCache;
@property (strong, nonatomic) IBOutlet UIButton *antiAddiction;
@property (strong, nonatomic) IBOutlet UIButton *weChatLogin;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 检查用户是否同意了《用户协议和隐私政策》，如果同意则直接初始化，否则需要弹窗征得用户同意
    if ([TGCenterSdk.sharedInstance isUserAgreePolicy]) {
        // 用户已同意，初始化
        [self initModooPlay];
    } else {
        // 用户未同意
        // 展示默认的对话框
        [self showDefaultPolicyDialog];
        // 或者：展示 App 根据产品风格自定义的对话框
        // [self showCustomPolicyDialog];
    }
    
    if (![WXApi isWXAppInstalled]) {
        self.weChatLogin.hidden = YES;
    }
}

/**
* 初始化 ModooPlay，必须在用户同意《用户协议和隐私政策》之后才可以调用。
* init 方法内部初始化 Umeng、AppsFlyer、RangersAppLog、TaurusX，
* 如果应用之前有初始化上述 SDK 的逻辑，请先移除，统一由 ModooPlay 初始化。
*/
- (void)initModooPlay {
    TGCInitConfig *initConfig = [[TGCInitConfig alloc] init];
    initConfig.debugMode = YES;
    initConfig.appId = @"9dc8fab8-32d5-4d6f-b224-8f0a9b55547f";
    initConfig.appleAppID = @"appleAppID";
    initConfig.umengAppKey = @"umeng_AppKey";
    initConfig.appsFlyerDevKey = @"appsFlyer_devKey";
    initConfig.rangersAppLogAppId = @"rangersAppLog_appId";
    initConfig.rangersAppLogAppName = @"rangersAppLog_appName";
    initConfig.weChatAppId = @"weChat_appId";
    initConfig.weChatUniversalLink = @"weChat_universalLink";

    [TGCenterSdk.sharedInstance initWithConfig:initConfig];
}

// 展示默认的《用户协议和隐私政策》对话框
- (void)showDefaultPolicyDialog {
    PrivacyPolicyHelper *helper = [[PrivacyPolicyHelper alloc] init];
    [helper showDialogWithAgreeBlock:^{
        [self dealDialogAgreeResult:YES];
    } andDisagreeBlock:^{
        [self dealDialogAgreeResult:NO];
    } inParentView:self.view];
}

// App 也可以自定义《用户协议和隐私政策》对话框
- (void)showCustomPolicyDialog {
    __block CustomPrivacyDialog *dialog = [[CustomPrivacyDialog alloc] initWithAgreeBlock:^{
        [self dealDialogAgreeResult:YES];
    } andDisagreeBlock:^{
        [self dealDialogAgreeResult:NO];
    }];
    [dialog showInParentView:self.view];
}

/**
 * 处理用户点击对话框按钮的结果。
 * 用户同意，初始化；用户不同意，进行提示。
 */
- (void)dealDialogAgreeResult:(BOOL)agree {
    if (agree) {
        [self initModooPlay];
    } else {
        [self.view makeToast:@"您需要阅读并同意后才可以使用本应用"
                    duration:2.0
                    position:CSToastPositionCenter];
    }
}

- (IBAction)testAds:(id)sender {
    NetworkTestViewController *vc = [[NetworkTestViewController alloc] init];
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
}

// 跳转到用户协议
- (IBAction)showUserAgreement:(id)sender {
    PrivacyPolicyHelper *helper = [[PrivacyPolicyHelper alloc] init];
    [helper jumpToUserAgreement];
}

// 跳转到隐私政策
- (IBAction)showPrivacyPolicy:(id)sender {
    PrivacyPolicyHelper *helper = [[PrivacyPolicyHelper alloc] init];
    [helper jumpToPrivacyPolicy];
}

// 清除 SDK 的所有数据，包括《用户协议与隐私政策》的授权状态、用户信息等
- (IBAction)clearCache:(id)sender {
    [TGCenterSdk.sharedInstance clearCache];
}

// 游戏防沉迷
- (IBAction)antiAddiction:(id)sender {
    AntiAddictionViewController *vc = [[AntiAddictionViewController alloc] init];
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
}

// 微信登录
- (IBAction)weChatLogin:(id)sender {
    // 设置微信登录回调
    TGCWeChatHelper.sharedInstance.loginDelegate = self;
    [TGCWeChatHelper.sharedInstance login:self];
}

#pragma mark - TGCWeChatLoginDelegate
- (void)tgcWeChatLogin_Success:(NSString *)code {
    // 登录成功
    [self.view makeToast:[NSString stringWithFormat:@"微信登录：成功，code: %@", code]
                duration:2.0
                position:CSToastPositionCenter];
}

- (void)tgcWeChatLogin_Fail:(NSString *)msg {
    // 登录失败
    [self.view makeToast:[NSString stringWithFormat:@"微信登录：失败，msg: %@", msg]
                duration:2.0
                position:CSToastPositionCenter];
}

- (void)tgcWeChatLogin_Cancel:(NSString *)msg {
    // 取消登录
    [self.view makeToast:[NSString stringWithFormat:@"微信登录：取消，msg: %@", msg]
                duration:2.0
                position:CSToastPositionCenter];
}
#pragma mark - TGCWeChatLoginDelegate

@end
