
#import "NewLoginViewController.h"
#import "WXApi.h"
#import <AFNetworking/AFNetworking.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <AuthenticationServices/AuthenticationServices.h>
@import RichOXBase;


/* Title Message */
static NSString* const kConnectErrorTitle = @"连接服务器失败";
static NSString* const kWXAuthDenyTitle = @"授权失败";
static NSString* const kWXLoginErrorTitle = @"登录失败";
static NSString* const kTitleLabelText = @"RichOX Demo";
/* Font */
static const CGFloat kTitleLabelFontSize = 18.0f;
static const CGFloat kWXLoginButtonFontSize = 16.0f;
/* Size */

static const int inset = 10;

static const int kLogoImageWidth = 75;
static const int kLogoImageHeight = 52;
static const int kTitleLabelWidth = 150;
static const int kTitleLabelHeight = 44;
static const int kWXLoginButtonWidth = 280;
static const int kWXLoginButtonHeight = 44;
static const int kWXLogoImageWidth = 25;
static const int kWXLogoImageHeight = 20;

@interface NewLoginViewController ()<WXApiDelegate, GIDSignInDelegate,GIDSignInUIDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *wxLogoImageView;
@property (nonatomic, strong) UIButton *wxLoginButton;
@property (nonatomic, strong) UIImageView *googleLogoImageView;
@property (nonatomic, strong) UIButton *googleLoginButton;
@property (nonatomic, strong) UIImageView *fbLogoImageView;
@property (nonatomic, strong) UIButton *fbLoginButton;
@property (nonatomic, strong) UIImageView *appleLogoImageView;
@property (nonatomic, strong) UIButton *appleLoginButton;
@property (nonatomic, strong) UIButton *wxBackButton;
@property (nonatomic, strong) UIButton *debugButton;

@end

@implementation NewLoginViewController {
    NSString *_code;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.hidesBackButton = YES;
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.wxLoginButton];
    [self.view addSubview:self.wxLogoImageView];
    [self.view addSubview:self.googleLoginButton];
    [self.view addSubview:self.googleLogoImageView];
    [self.view addSubview:self.fbLoginButton];
    [self.view addSubview:self.fbLogoImageView];
    [self.view addSubview:self.appleLoginButton];
    [self.view addSubview:self.appleLogoImageView];
    [self.view addSubview:self.wxBackButton];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxLogin:) name:@"wxLogin" object:nil];
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.backgroundView.frame = self.view.frame;

    CGFloat logoImageCenterY = [UIScreen mainScreen].bounds.size.height / 6;
    self.logoImageView.frame = CGRectMake(0, 0, kLogoImageWidth, kLogoImageHeight);
    self.logoImageView.center = CGPointMake(self.view.center.x, logoImageCenterY);
    
    CGFloat titleLabelCenterY = logoImageCenterY + kLogoImageHeight/2 + inset*2;
    self.titleLabel.frame = CGRectMake(0, 0, kTitleLabelWidth, kTitleLabelHeight);
    self.titleLabel.center = CGPointMake(self.view.center.x, titleLabelCenterY);
    
    CGFloat loginButtonCenterY = titleLabelCenterY + 50;
    self.wxLoginButton.frame = CGRectMake(0, 0, kWXLoginButtonWidth, kWXLoginButtonHeight);
    self.wxLoginButton.center = CGPointMake(self.view.center.x, loginButtonCenterY);
    
    CGFloat wxLogoImageCenterX = self.view.center.x - inset * 6;
    self.wxLogoImageView.frame = CGRectMake(0, 0, kWXLogoImageWidth, kWXLogoImageHeight);
    self.wxLogoImageView.center = CGPointMake(wxLogoImageCenterX, loginButtonCenterY);
    
    
    self.googleLoginButton.frame = CGRectMake(0, 0, kWXLoginButtonWidth, kWXLoginButtonHeight);
    self.googleLoginButton.center = CGPointMake(self.view.center.x, loginButtonCenterY+kWXLoginButtonHeight+20);

    self.googleLogoImageView.frame = CGRectMake(0, 0, kWXLogoImageWidth, kWXLogoImageHeight);
    self.googleLogoImageView.center = CGPointMake(wxLogoImageCenterX, loginButtonCenterY+kWXLoginButtonHeight+20);
    
    self.fbLoginButton.frame = CGRectMake(0, 0, kWXLoginButtonWidth, kWXLoginButtonHeight);
    self.fbLoginButton.center = CGPointMake(self.view.center.x, loginButtonCenterY+2*(kWXLoginButtonHeight+20));

    self.fbLogoImageView.frame = CGRectMake(0, 0, kWXLogoImageWidth, kWXLogoImageHeight);
    self.fbLogoImageView.center = CGPointMake(wxLogoImageCenterX, loginButtonCenterY+2*(kWXLoginButtonHeight+20));
    
    self.appleLoginButton.frame = CGRectMake(0, 0, kWXLoginButtonWidth, kWXLoginButtonHeight);
    self.appleLoginButton.center = CGPointMake(self.view.center.x, loginButtonCenterY+3*(kWXLoginButtonHeight+20));

    self.appleLogoImageView.frame = CGRectMake(0, 0, kWXLogoImageWidth, kWXLogoImageHeight);
    self.appleLogoImageView.center = CGPointMake(wxLogoImageCenterX, loginButtonCenterY+3*(kWXLoginButtonHeight+20));
    
    CGFloat backButtonCenterY = loginButtonCenterY+4*(kWXLoginButtonHeight+20);
    self.wxBackButton.frame = CGRectMake(0, 0, kWXLoginButtonWidth, kWXLoginButtonHeight);
    self.wxBackButton.center = CGPointMake(self.view.center.x, backButtonCenterY);
}


#pragma mark - User Actions
- (void)wxlogin {
    //判断微信是否安装
    if([WXApi isWXAppInstalled]){
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendAuthReq:req viewController:self delegate:self completion:^(BOOL success) {
            
        }];
    }else{
        [self setupAlertController];
    }
}

- (void)setupAlertController{
     UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfim = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [vc addAction:actionConfim];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setupComfirmController: (NSString *)content{
     UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfim = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [vc addAction:actionConfim];
    [self presentViewController:vc animated:YES completion:nil];
}



- (void)wxLogin:(NSNotification*)noti{
    //获取到code
    SendAuthResp *resp = noti.object;
    NSLog(@"%@",resp.code);
    _code = resp.code;
    
    [self bindSocialAccount:RICHOX_BASE_BINDTYPE_WECHAT openId:wxappId token:_code];
    
    //[self getUserInfo];
    
}

- (void)googlelogin {
    [[GIDSignIn sharedInstance] signIn];
}

/**
 GIDSignInUIDelegate
 
 */
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    if (error) {
        [self setupComfirmController:@"网络异常，请稍后重试"];
        return;
    }

    // 登录
//    [self doLoginWithURL:@"userinfo/login_google" Params:@{@"access_token":user.authentication.idToken, @"bean":@([MMCoinManager shareInstance].allCoins * 10)}];
    [self bindSocialAccount:RICHOX_BASE_BINDTYPE_GOOGLE openId: user.userID token:user.authentication.idToken];
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController{
    
}

// If implemented, this method will be invoked when sign in needs to dismiss a view controller.
// Typically, this should be implemented by calling |dismissViewController| on the passed
// view controller.
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController{
    
}


- (void)fblogin {
    if ([FBSDKAccessToken currentAccessToken])  {
        [self bindSocialAccount:RICHOX_BASE_BINDTYPE_FACEBOOK openId:[FBSDKAccessToken currentAccessToken].userID token:[FBSDKAccessToken currentAccessToken].tokenString];
        // Objective-C // // 展开 6a 中的代码示例。将 Facebook 登录功能添加到代码中 // 将下列代码添加到 viewDidLoad 方法中：loginButton.readPermissions = @[@"public_profile", @"email"];
    }else {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithPermissions:@[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Process error");
            [self setupComfirmController:@"网络异常，请稍后重试"];
            
        } else if (result.isCancelled) {
            NSLog(@"Cancelled-----");
            
        } else {
            NSLog(@"Logged in-----");
            [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile * _Nullable profile, NSError * _Nullable error) {
                if (profile) {
                    // 登录
//                    [self doLoginWithURL:@"userinfo/login_fb" Params:@{@"user_id":profile.userID, @"access_token":[FBSDKAccessToken currentAccessToken].tokenString, @"bean" : @([MMCoinManager shareInstance].allCoins * 10)}];
                    [self bindSocialAccount:RICHOX_BASE_BINDTYPE_FACEBOOK openId:profile.userID token:[FBSDKAccessToken currentAccessToken].tokenString];
                }else {
                    [self setupComfirmController:@"网络异常，请稍后重试"];
                }
            }];
        }
    }];
    }
}

- (void)applelogin {
   if (@available(iOS 13.0, *)) {
       ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
       ASAuthorizationAppleIDRequest *request = [provider createRequest];
       request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
       ASAuthorizationController *vc = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
       vc.delegate = self;
       vc.presentationContextProvider = self;
       [vc performRequests];
   } else {
       // Fallback on earlier versions
   }
    
}

//- (void)alipayAuth {
//    [RichOXUser getAlipayAuthInfo: ^(NSString *authInfo) {
//        [[AlipaySDK defaultService] auth_V2WithInfo:authInfo
//                    fromScheme:@"appScheme"
//                    callback:^(NSDictionary *resultDic) {
//                    NSLog(@"result = %@",resultDic);
//                    // 解析 auth code
//                    NSString *result = resultDic[@"result"];
//                    NSString *authCode = nil;
//                    if (result.length>0) {
//                        NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//                        for (NSString *subResult in resultArr) {
//                            if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                                authCode = [subResult substringFromIndex:10];
//                                break;
//                            }
//                        }
//                    }
//                    NSLog(@"授权结果 authCode = %@", authCode?:@"");
//            [self bindSocialAccount:RICHOX_BASE_BINDTYPE_ALIPAY openId:@"alipay" token:authCode];
//        }];
//    } failure: ^(NSError *error) {
//        
//    }];
//}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0))
{
    return self.view.window;
}

#pragma mark - ASAuthorizationControllerDelegate
/// Apple登录授权出错
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    NSLog(@"Apple登录_错误信息: %@", error.localizedDescription);
    
    NSInteger code = error.code;
    if (code == ASAuthorizationErrorUnknown) { // 授权请求未知错误
        NSLog(@"Apple登录_授权请求未知错误");
    } else if (code == ASAuthorizationErrorCanceled) { // 授权请求取消了
        NSLog(@"Apple登录_授权请求取消了");
    } else if (code == ASAuthorizationErrorInvalidResponse) { // 授权请求响应无效
        NSLog(@"Apple登录_授权请求响应无效");
    } else if (code == ASAuthorizationErrorNotHandled) { // 授权请求未能处理
        NSLog(@"Apple登录_授权请求未能处理");
    } else if (code == ASAuthorizationErrorFailed) { // 授权请求失败
        NSLog(@"Apple登录_授权请求失败");
    }
}


- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0))
{
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        
        NSString *state = credential.state;
        NSString *userID = credential.user;
        NSPersonNameComponents *fullName = credential.fullName;
        NSString *email = credential.email;
        NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding]; // refresh token
        NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding]; // access token
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
       
        NSLog(@"state: %@", state);
        NSLog(@"userID: %@", userID);
        NSLog(@"fullName: %@", fullName);
        NSLog(@"email: %@", email);
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken: %@     长度:%ld", identityToken,(long)identityToken.length);
        NSLog(@"realUserStatus: %@", @(realUserStatus));
        
        [self bindSocialAccount:RICHOX_BASE_BINDTYPE_APPLE openId:userID token:identityToken];
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用的是: 现有密码凭证
        //ASPasswordCredential *credential = (ASPasswordCredential *)authorization.credential;
        //NSString *user = credential.user; // 密码凭证对象的用户标识(用户的唯一标识)
        //NSString *password = credential.password;
        //[self bindSocialAccount:FISSIONSDK_BINDTYPE_GOOGLE openId:user token:identityToken];
    }
}


#pragma mark - Lazy Initializer
- (UIImageView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wxLoginBackground"]];
    }
    return _backgroundView;
}

- (UIImageView *)logoImageView {
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppLogo"]];
    }
    return _logoImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = kTitleLabelText;
        _titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIButton *)wxLoginButton {
    if (_wxLoginButton == nil) {
        _wxLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _wxLoginButton.backgroundColor = [UIColor colorWithRed:0.04
        green:0.73
         blue:0.03
        alpha:1.00];
        _wxLoginButton.layer.cornerRadius = 4.0f;
        [_wxLoginButton setTitle:@"        微信绑定" forState:UIControlStateNormal];
        [_wxLoginButton addTarget:self
                           action:@selector(wxlogin)
                 forControlEvents:UIControlEventTouchUpInside];
        _wxLoginButton.titleLabel.font = [UIFont systemFontOfSize:kWXLoginButtonFontSize];
    }
    return _wxLoginButton;
}

- (UIImageView *)wxLogoImageView {
    if (_wxLogoImageView == nil) {
        _wxLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wxLogo"]];
        _wxLogoImageView.contentMode =  UIViewContentModeCenter;
    }
    return _wxLogoImageView;
}

- (UIButton *)googleLoginButton {
    if (_googleLoginButton == nil) {
        _googleLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _googleLoginButton.backgroundColor = [UIColor colorWithRed:1.00
        green:0.35
         blue:0.41
        alpha:1.00];
        _googleLoginButton.layer.cornerRadius = 4.0f;
        [_googleLoginButton setTitle:@"        Google绑定" forState:UIControlStateNormal];
        [_googleLoginButton addTarget:self
                           action:@selector(googlelogin)
                 forControlEvents:UIControlEventTouchUpInside];
        _googleLoginButton.titleLabel.font = [UIFont systemFontOfSize:kWXLoginButtonFontSize];
    }
    return _googleLoginButton;
}

- (UIImageView *)googleLogoImageView {
    if (_googleLogoImageView == nil) {
        _googleLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"googleLogo"]];
        _googleLogoImageView.contentMode =  UIViewContentModeCenter;
    }
    return _googleLogoImageView;
}

- (UIButton *)fbLoginButton {
    if (_fbLoginButton == nil) {
        _fbLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fbLoginButton.backgroundColor = [UIColor colorWithRed:0.29
        green:0.56
         blue:1.00
        alpha:1.00];
        _fbLoginButton.layer.cornerRadius = 4.0f;
        [_fbLoginButton setTitle:@"        Facebook绑定" forState:UIControlStateNormal];
        [_fbLoginButton addTarget:self
                           action:@selector(fblogin)
                 forControlEvents:UIControlEventTouchUpInside];
        _fbLoginButton.titleLabel.font = [UIFont systemFontOfSize:kWXLoginButtonFontSize];
    }
    return _fbLoginButton;
}

- (UIImageView *)fbLogoImageView {
    if (_fbLogoImageView == nil) {
        _fbLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_fb_icon"]];
        _fbLogoImageView.contentMode =  UIViewContentModeCenter;
    }
    return _fbLogoImageView;
}

- (UIButton *)appleLoginButton {
    if (_appleLoginButton == nil) {
        _appleLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _appleLoginButton.backgroundColor = [UIColor colorWithRed:1.00
        green:0.80
         blue:0.00
        alpha:1.00];
        _appleLoginButton.layer.cornerRadius = 4.0f;
        [_appleLoginButton setTitle:@"        Apple绑定" forState:UIControlStateNormal];
        [_appleLoginButton addTarget:self
                           action:@selector(applelogin)
                 forControlEvents:UIControlEventTouchUpInside];
        _appleLoginButton.titleLabel.font = [UIFont systemFontOfSize:kWXLoginButtonFontSize];
    }
    return _appleLoginButton;
}

- (UIImageView *)appleLogoImageView {
    if (_appleLogoImageView == nil) {
        _appleLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appleLogo"]];
        _appleLogoImageView.contentMode =  UIViewContentModeCenter;
    }
    return _appleLogoImageView;
}

- (UIButton *)wxBackButton {
    if (_wxBackButton == nil) {
        _wxBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _wxBackButton.backgroundColor = [UIColor lightGrayColor];
        _wxBackButton.layer.cornerRadius = 4.0f;
        [_wxBackButton setTitle:@"返回" forState:UIControlStateNormal];
        [_wxBackButton addTarget:self
                           action:@selector(back)
                 forControlEvents:UIControlEventTouchUpInside];
        _wxBackButton.titleLabel.font = [UIFont systemFontOfSize:kWXLoginButtonFontSize];
    }
    return _wxBackButton;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)bindSocialAccount:(RICHOX_BASE_BINDTYPE) bindType openId: (NSString *)openId  token: (NSString *) token {
    NSString *userId = [RichOXBaseManager userId];
    if (userId != nil && ![userId isEqualToString:@""]) {
        [RichOXUserManager bindUser:openId bindType:bindType bindCode:token success:^(RichOXUserObject *userData) {
                NSLog(@"*******bindUser测试成功: bindtype is %ld, bind result is %@", bindType, [userData description]);
        }  failure:^(NSError *error) {
            NSLog(@"*******bindUser测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
        }];
    } else {
        switch (bindType) {
            case RICHOX_BASE_BINDTYPE_APPLE:
                [RichOXUserManager registerByApple:openId appleToken:token success:^(RichOXUserObject * _Nonnull userData) {
                    NSLog(@"*******registerByApple测试成功: bindtype is %ld, bind result is %@", bindType, [userData description]);
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"*******registerByApple测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
                }];
                break;
                
            case RICHOX_BASE_BINDTYPE_GOOGLE:
                [RichOXUserManager registerByGoogle:token success:^(RichOXUserObject * _Nonnull userData) {
                    NSLog(@"*******registerByGoogle测试成功: bindtype is %ld, bind result is %@", bindType, [userData description]);
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"*******registerByGoogle测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
                }];
                break;
                
            case RICHOX_BASE_BINDTYPE_FACEBOOK:
                [RichOXUserManager registerByFacebook:openId accessToken:token success:^(RichOXUserObject * _Nonnull userData) {
                    NSLog(@"*******registerByFacebook测试成功: bindtype is %ld, bind result is %@", bindType, [userData description]);
                } failure:^(NSError * _Nonnull error) {
                    NSLog(@"*******registerByFacebook测试失败: errorCode: %ld, message:%@", error.code, error.localizedDescription);
                }];
                break;
                
            default:
                break;
        }
    }
}



@end
