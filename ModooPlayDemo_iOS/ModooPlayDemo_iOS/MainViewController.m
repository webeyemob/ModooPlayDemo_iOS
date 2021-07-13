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
#import "RichOXViewController.h"
@import PrivacyPolicy;
@import TGCenter;
@import TGCWeChat;
#import "WXApi.h"
//@import TGCUdesk;
@import EmbededSdk;
@import RichOXFission_Moblink;
@import RichOXBase;

@interface MainViewController () <TGCWeChatLoginDelegate, RichOXFissionDelegate>
@property (strong, nonatomic) IBOutlet UIButton *adTest;
@property (strong, nonatomic) IBOutlet UIButton *userAgreement;
@property (strong, nonatomic) IBOutlet UIButton *privacyPolicy;
@property (strong, nonatomic) IBOutlet UIButton *clearCache;
@property (strong, nonatomic) IBOutlet UIButton *antiAddiction;
@property (strong, nonatomic) IBOutlet UIButton *weChatLogin;
@property (strong, nonatomic) IBOutlet UIButton *udesk;

@property (weak, nonatomic) IBOutlet UIButton *richOXBtn;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化隐私 SDK
    [PrivacyPolicyManager init:@"97ed11f7-01f8-493c-ba1a-03b91056ac1a"];
    
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
    
    self.weChatLogin.enabled = [WXApi isWXAppInstalled];
}

/**
* 初始化 ModooPlay，必须在用户同意《用户协议和隐私政策》之后才可以调用。
* init 方法内部初始化 Umeng、AppsFlyer、RangersAppLog、TaurusX、WeChat、Udesk，
* 如果应用之前有初始化上述 SDK 的逻辑，请先移除，统一由 ModooPlay 初始化。
*/
- (void)initModooPlay {
    TGCInitConfig *initConfig = [[TGCInitConfig alloc] init];
    initConfig.debugMode = YES;
    initConfig.appId = @"97ed11f7-01f8-493c-ba1a-03b91056ac1a";
    initConfig.appleAppID = @"appleAppID";
    initConfig.umengAppKey = @"umeng_AppKey";
    initConfig.appsFlyerDevKey = @"appsFlyer_devKey";
    
    initConfig.rangersAppLogAppId = @"rangersAppLog_appId";
    initConfig.rangersAppLogAppName = @"rangersAppLog_appName";
    
    initConfig.weChatAppId = @"weChat_appId";
    initConfig.weChatUniversalLink = @"weChat_universalLink";
    
    initConfig.udeskDomain = @"udesk_domain";
    initConfig.udeskAppKey = @"udesk_appKey";
    initConfig.udeskAppId = @"udesk_appId";

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
        [[RichOXFission shareInstance] start:self];
    } else {
        [self.view makeToast:@"您需要阅读并同意后才可以使用本应用"
                    duration:2.0
                    position:CSToastPositionCenter];
    }
}

#pragma  mark RichOXLinkDelegate
- (void)getInstallParams: (NSDictionary *)params {
    NSString *inviterId = params[@"inviter_id"];
    NSString *msg  = [NSString stringWithFormat:@"get install params: %@", inviterId];
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.view makeToast:msg duration:5.0 position:CSToastPositionCenter];
    });
    
    NSString *userId = [RichOXBaseManager userId];
    if (userId == nil || [userId isEqualToString:@""]) {
        [RichOXUser registerUserId:inviterId initInfo:nil success:^(RichOXUserData * _Nonnull userData) {
            NSLog(@"*******registerUserId测试成功: userData: %@", [userData description]);
            [RichOXFission reportFissionParam:NO];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******registerUserId测试失败: errorCode: %zd, message:%@", error.code, error.localizedDescription);
        }];
    } else {
        [RichOXUser bindInviter:inviterId success:^{
            NSLog(@"*******bindInviter测试成功");
            [RichOXFission reportFissionParam:NO];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"*******bindInviter测试失败: errorCode: %zd, message:%@", error.code, error.localizedDescription);
        }];
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

- (IBAction)richOXTest:(id)sender {
   RichOXViewController *vc = [[RichOXViewController alloc] init];
    vc.modalPresentationStyle = 0;
    [self presentViewController:vc animated:YES completion:nil];
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

// 客服系统
- (IBAction)udesk:(id)sender {
    //[TGCUdeskHelper presentUdeskInViewController:self];
}

@end
