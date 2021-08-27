//
//  RichOXShareViewController.m
//  MoodooPlayDemo
//
//  Created by moodoo on 2021/1/18.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "RichOXShareViewController.h"
#import "macro.h"
#import "Masonry.h"
@import RichOXShare;
#import "UIView+Toast.h"
@import RichOXFissionSdk;
@import RichOXBase;

//#define WEBPAGE @"http://test-rox-static.ufile.ucloud.com.cn/test_share/index.html"
#define WEBPAGE @"http://share.msgcarry.cn/share/openinstall_majiang.html"
//#define WEBPAGE @"https://app-lpljir.openinstall.io/page/lpljir/js-test/ios/3273384184743159982"

@interface RichOXShareViewController ()

@property (nonatomic, strong) UITextField *hostText;
@property (nonatomic, strong) UITextField *pathText;
@property (nonatomic, strong) UITextField *paramText;

@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) UILabel *shareUrlLab;

@property (nonatomic, strong) UIView *QRView;
@property (nonatomic, strong) UIView *QRDataView;
@property (nonatomic, strong) UIView *popView;

@end

@implementation RichOXShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    titleLab.text = @"分享测试";
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
    
    UILabel *shareHostlab = [[UILabel alloc] init];
    shareHostlab.text = @"分享Host: ";
    [self.view addSubview:shareHostlab];
    
    [shareHostlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(100));
        make.height.equalTo(@(30));
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.text = WEBPAGE;
    [self.view addSubview:textField];
    textField.borderStyle = UITextBorderStyleRoundedRect;

    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareHostlab);
        make.left.equalTo(shareHostlab.mas_right).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(30));
    }];
    
    self.hostText = textField;
    
//    UILabel *pathlab = [[UILabel alloc] init];
//    pathlab.text = @"分享Path: ";
//    [self.view addSubview:pathlab];
//
//    [pathlab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(shareHostlab.mas_bottom).offset(20);
//        make.left.equalTo(self.view).offset(20);
//        make.width.equalTo(@(100));
//        make.height.equalTo(@(30));
//    }];
//
//    UITextField *pathTextField = [[UITextField alloc]init];
//    pathTextField.text = @"share";
//    [self.view addSubview:pathTextField];
//    pathTextField.borderStyle = UITextBorderStyleRoundedRect;
//
//    [pathTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(pathlab);
//        make.left.equalTo(pathlab.mas_right).offset(20);
//        make.right.equalTo(self.view).offset(-20);
//        make.height.equalTo(@(30));
//    }];
//
//    self.pathText = pathTextField;
    
    UILabel *paramLab = [[UILabel alloc] init];
    paramLab.text = @"自定义参数: ";
    [self.view addSubview:paramLab];
    
    [paramLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareHostlab.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(100));
        make.height.equalTo(@(30));
    }];
    
    UITextField *paramTextField = [[UITextField alloc]init];
    [self.view addSubview:paramTextField];
    paramTextField.borderStyle = UITextBorderStyleRoundedRect;

    [paramTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paramLab);
        make.left.equalTo(paramLab.mas_right).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(30));
    }];
    
    self.paramText = paramTextField;
    
    UIButton *shareUrlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:shareUrlBtn];
    [shareUrlBtn setTitle:@"获取分享链接" forState:UIControlStateNormal];
    [shareUrlBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [shareUrlBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [shareUrlBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [shareUrlBtn addTarget:self action:@selector(getShareLink) forControlEvents:UIControlEventTouchUpInside];
    
    [shareUrlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paramTextField.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(150));
        make.height.equalTo(@(30));
    }];
    
    UILabel *shareUrlLab = [[UILabel alloc] init];
    shareUrlLab.numberOfLines = -1;
    [shareUrlLab setFont:[UIFont systemFontOfSize:12]];
    self.shareUrlLab = shareUrlLab;
    [self.view addSubview:shareUrlLab];
    [shareUrlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareUrlBtn.mas_bottom).offset(20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(70));
    }];
    
    UIButton *QRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:QRBtn];
    [QRBtn setTitle:@"获取分享二维码" forState:UIControlStateNormal];
    [QRBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [QRBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [QRBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [QRBtn addTarget:self action:@selector(getShareQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    [QRBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareUrlBtn);
        make.right.equalTo(self.view).offset(-20);
        make.width.equalTo(@(150));
        make.height.equalTo(@(30));
    }];
    
    UIView *QRView = [[UIView alloc] init];
    self.QRView = QRView;
    [self.view addSubview:QRView];
    [QRView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
    }];
    
    UIView *QRDataView = [[UIView alloc] init];
    self.QRDataView = QRDataView;
    [self.view addSubview:QRDataView];
    [QRDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QRView);
        make.right.equalTo(self.view).offset(-20);
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
    }];
    
    UIButton *popShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:popShareBtn];
    [popShareBtn setTitle:@"弹出分享菜单" forState:UIControlStateNormal];
    popShareBtn.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0];
    [popShareBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [popShareBtn addTarget:self action:@selector(popShareView) forControlEvents:UIControlEventTouchUpInside];
    
    [popShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QRView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(150));
        make.height.equalTo(@(30));
    }];
    
    CGFloat width = (ScreenWidth - 100)/4;
    
    UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wxBtn.tag = 1;
    [self.view addSubview:wxBtn];
    [wxBtn setTitle:@"WX" forState:UIControlStateNormal];
    wxBtn.layer.cornerRadius = 15;
    wxBtn.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:181.0/255.0 blue:95.0/255.0 alpha:1.0];
    [wxBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [wxBtn addTarget:self action:@selector(shareTo:) forControlEvents:UIControlEventTouchUpInside];
    [wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.top.equalTo(popShareBtn.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(width));
        make.height.equalTo(@(30));
    }];
    
    
    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqBtn.tag = 2;
    [self.view addSubview:qqBtn];
    [qqBtn setTitle:@"QQ" forState:UIControlStateNormal];
    qqBtn.layer.cornerRadius = 15;
    qqBtn.backgroundColor = [UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0];
    [qqBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(shareTo:) forControlEvents:UIControlEventTouchUpInside];
    
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wxBtn);
        make.left.equalTo(wxBtn.mas_right).offset(20);
        make.width.equalTo(@(width));
        make.height.equalTo(@(30));
    }];
    
    UIButton *wbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wbBtn.tag = 3;
    [self.view addSubview:wbBtn];
    [wbBtn setTitle:@"WB" forState:UIControlStateNormal];
    wbBtn.layer.cornerRadius = 15;
    wbBtn.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:85.0/255.0 blue:49.0/255.0 alpha:1.0];
    [wbBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [wbBtn addTarget:self action:@selector(shareTo:) forControlEvents:UIControlEventTouchUpInside];
    
    [wbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qqBtn);
        make.left.equalTo(qqBtn.mas_right).offset(20);
        make.width.equalTo(@(width));
        make.height.equalTo(@(30));
    }];
    
    UIButton *dyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dyBtn.tag = 4;
    [self.view addSubview:dyBtn];
    [dyBtn setTitle:@"DY" forState:UIControlStateNormal];
    dyBtn.layer.cornerRadius = 15;
    dyBtn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:152.0/255.0 blue:0.0/255.0 alpha:1.0];
    [dyBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [dyBtn addTarget:self action:@selector(shareTo:) forControlEvents:UIControlEventTouchUpInside];
    
    [dyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qqBtn);
        make.left.equalTo(wbBtn.mas_right).offset(20);
        make.width.equalTo(@(width));
        make.height.equalTo(@(30));
    }];
    
    
    self.popView = [[UIView alloc] init];
    [self.view addSubview:self.popView];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(300));
        make.bottom.equalTo(self.view);
    }];
    
    self.popView.hidden = YES;
    NSLog(@"SDK info: %@", [RichOXFission getAdapterSdkVersionInfo]);
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getShareLink {
    NSString *userId = [RichOXBaseManager userId];
    if (userId == nil || self.hostText.text == nil || [self.hostText.text isEqualToString:@""]) {
        [self.view makeToast:@"请先注册用户" duration:0.5 position:CSToastPositionCenter];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:userId forKey:@"inviter_id"];
    if (self.paramText.text != nil && ![self.paramText.text isEqualToString:@""]) {
        NSData *jsonData = [self.paramText.text dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *param = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
        [params addEntriesFromDictionary:param];
    }
    
    //如果使用Firebase裂变还可以添加这些参数
    [params setValue:@(YES) forKey:RICHOX_FISSION_CONFIG_NEEDPREVIEW_IN_PARAM_KEY];
    [params setValue:@"kuailai" forKey:RICHOX_FISSION_CONFIG_SOCIALMETATAG_TITLE_IN_PARAM_KEY];
    [params setValue:@"testtest" forKey:RICHOX_FISSION_CONFIG_SOCIALMETATAG_DESCRIPTIONTEXT_IN_PARAM_KEY];
    [params setValue:@"http://image.png" forKey:RICHOX_FISSION_CONFIG_SOCIALMETATAG_IMAGEURL_IN_PARAM_KEY];
    
    [RichOXFission genShareURL:self.hostText.text params:params success:^(NSString *url) {
        NSLog(@"******** genShareURL *********测试成功, share link is: %@",url);
        self.shareUrl = url;
        self.shareUrlLab.text = url;

    } fail: ^(NSError *err) {
        NSLog(@"******** genShareURL *********测试失败，%zd, %@",err.code, err.localizedDescription);
        [self.view makeToast:[NSString stringWithFormat:@"genShareURL测试失败，%zd, %@",err.code, err.localizedDescription] duration:0.5 position:CSToastPositionCenter];
    }];
}

- (void)getShareQRCode {
    UIView *qrView = [RichOXFission getQRCodeView:CGRectMake(0, 0, 100, 100) linkUrl:self.shareUrl];
    
    [self.QRView addSubview:qrView];
    
    
    NSData *qrData = [RichOXFission getQRCodeData:CGRectMake(0, 0, 100, 100) linkUrl:self.shareUrl];
    UIImage *image = [UIImage imageWithData: qrData];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100, 100)];
    [imageView setImage:image];
    
    [self.QRDataView addSubview:imageView];
}


- (void)popShareView {
    RichOXShareParam *shareContent = [[RichOXShareParam alloc] init];
    shareContent.text = @"share";
    shareContent.title = @"分享得红包!";
    UIImage *image = [UIImage imageNamed:@"googleLogo"];
    shareContent.images = @[image];
    NSArray *items = @[@(RICHOX_SHARE_PLATFORM_WECHAT_SESSION), @(RICHOX_SHARE_PLATFORM_WECHAT_TIMELINE), @(RICHOX_SHARE_PLATFORM_QQ_FRIEND), @(RICHOX_SHARE_PLATFORM_SINAWEIBO), @(RICHOX_SHARE_PLATFORM_DOUYIN), @(RICHOX_SHARE_PLATFORM_COPY),@(RICHOX_SHARE_PLATFORM_MAIL),@(RICHOX_SHARE_PLATFORM_SMS)];
    [RichOXFission startShare];
    [RichOXShareManager popShareWithView:self.popView items:items shareContent:shareContent success:^(void) {
          NSLog(@"******** popShareWithView *********测试成功");
        [RichOXFission shareSuccess];
    } failure:^(NSError *err) {
          NSLog(@"******** popShareWithView *********测试失败，%zd, %@",err.code, err.localizedDescription);
    }];
}

- (void)shareTo:(UIButton *)btn {
    RichOXShareParam *shareContent = [[RichOXShareParam alloc] init];
    shareContent.text = @"share";
    shareContent.title = @"分享得红包!";
    UIImage *image = [UIImage imageNamed:@"googleLogo"];
    if (image != nil) {
        shareContent.images = @[image];
    }
    [RichOXFission startShare];
    switch (btn.tag) {
        case 1:
            [RichOXShareManager shareTo:RICHOX_SHARE_PLATFORM_WECHAT_SESSION shareContent:shareContent success:^{
                NSLog(@"******** shareToWechat *********测试成功");
                [RichOXFission shareSuccess];
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"******** shareToWechat *********测试失败，%zd, %@",error.code, error.localizedDescription);
            }];
            break;
            
        case 2:
            [RichOXShareManager shareTo:RICHOX_SHARE_PLATFORM_QQ_FRIEND shareContent:shareContent success:^{
                NSLog(@"******** shareToQQ *********测试成功");
                [RichOXFission shareSuccess];
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"******** shareToQQ *********测试失败，%zd, %@",error.code, error.localizedDescription);
            }];
            break;
            
        case 3:
            [RichOXShareManager shareTo:RICHOX_SHARE_PLATFORM_SINAWEIBO shareContent:shareContent success:^{
                NSLog(@"******** shareToWeibo *********测试成功");
                [RichOXFission shareSuccess];
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"******** shareToWeibo *********测试失败，%zd, %@",error.code, error.localizedDescription);
            }];
            break;
            
        case 4:
            [RichOXShareManager shareTo:RICHOX_SHARE_PLATFORM_DOUYIN shareContent:shareContent success:^{
                NSLog(@"******** shareToDouyin *********测试成功");
                [RichOXFission shareSuccess];
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"******** shareToDouyin *********测试失败，%zd, %@",error.code, error.localizedDescription);
            }];
            break;
            
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
