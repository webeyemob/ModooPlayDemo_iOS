//
//  RichOXActivityViewController.m
//  MoodooPlay
//
//  Created by moodoo on 2020/6/22.
//  Copyright © 2021 Moodoo. All rights reserved.
//

#import "RichOXActivityViewController.h"
@import RichOX;
#import "UIView+Toast.h"
#import <Masonry/Masonry.h>
#import "macro.h"

@interface RichOXActivityViewController () <ROXFloatSceneDelegate, ROXNativeSceneDelegate, ROXDialogSceneDelegate>

@property (nonatomic, strong) ROXFloatView *entraceView;

@property (nonatomic) BOOL scenecReady;

@property (nonatomic, strong) UIButton *loadNativeBtn;
@property (nonatomic, strong) UIView *floatView;

@property (nonatomic, strong) UIButton *removeNativeBtn;


@property (nonatomic, strong) UITextField *imageText;
@property (nonatomic, strong) UITextField *normalText;
@property (nonatomic, strong) UITextField *dialogText;

@property (nonatomic, strong) ROXNative *native;
@property (nonatomic, strong) UIView *nativeRootView;
@property (nonatomic, strong) UILabel *nativeTitleLab;
@property (nonatomic, strong) UILabel *nativeDescLab;
@property (nonatomic, strong) UIImageView *nativeIconView;
@property (nonatomic, strong) UIImageView *nativeMediaView;
@property (nonatomic, strong) UIButton *nativeCallToActionBtn;

@property (nonatomic, strong) NSString *lastImageFloatId;
@property (nonatomic, strong) NSString *lastNativeFloatId;
@property (nonatomic, strong) NSString *lastDialogId;

@property (nonatomic, strong) ROXDialog *dialog;
@property (nonatomic, strong) UIButton *showBtn;
@property (nonatomic, strong) UIButton *destoryBtn;

@end

@implementation RichOXActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kTopBarSafeHeight);
        make.bottom.equalTo(self.view.mas_top).offset(kTopBarSafeHeight+20);
    }];
    
    UILabel *titleLab =  [[UILabel alloc]init];
    titleLab.text = @"活动测试";
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
    
    
    UILabel *lab1 = [[UILabel alloc] init];
    lab1.text = @"float entry id:";
    [self.view addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(120));
        make.height.equalTo(@(30));
    }];
    
    UITextField *textField1 = [[UITextField alloc]init];
    [self.view addSubview:textField1];
    textField1.borderStyle = UITextBorderStyleRoundedRect;

    [textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(180));
        make.height.equalTo(@(30));
    }];
    self.imageText = textField1;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 5;
    [btn setBackgroundColor:[UIColor colorWithRed:51.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [btn setTitle:@"load" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(loadFloat) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField1.mas_bottom).offset(20);
        make.width.equalTo(@(60));
        make.left.equalTo(self.view).offset(50);
        make.height.equalTo(@(30));
    }];
    
    self.floatView = [[UIView alloc] init];
    self.floatView.layer.borderWidth = 1.5;
    self.floatView.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:self.floatView];
    //self.floatView.hidden = YES;
    
    [_floatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField1);
        make.width.equalTo(@(80));
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(80));
    }];
    
    UIView *line2 = [[UIView alloc] init];
    [line2 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(1));
    }];
    
    UILabel *dialoglab = [[UILabel alloc] init];
    dialoglab.text = @"dialog entry id: ";
    [self.view addSubview:dialoglab];
    
    [dialoglab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(140));
        make.height.equalTo(@(30));
    }];
    
    UITextField *textField3 = [[UITextField alloc]init];
    [self.view addSubview:textField3];
    textField3.borderStyle = UITextBorderStyleRoundedRect;

    [textField3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dialoglab);
        make.left.equalTo(dialoglab.mas_right).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(30));
    }];
    
    self.dialogText = textField3;
    
    
    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:loadBtn];
    [loadBtn setTitle:@"Load" forState:UIControlStateNormal];
    [loadBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [loadBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [loadBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [loadBtn addTarget:self action:@selector(loadDialog) forControlEvents:UIControlEventTouchUpInside];
    
    [loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField3.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.width.equalTo(@(80));
        make.height.equalTo(@(30));
    }];
    
    
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:showBtn];
    [showBtn setTitle:@"Show" forState:UIControlStateNormal];
    [showBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [showBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [showBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [showBtn addTarget:self action:@selector(showDialog) forControlEvents:UIControlEventTouchUpInside];
    showBtn.enabled = NO;
    self.showBtn = showBtn;
    
    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(loadBtn);
        make.width.equalTo(@(80));
        make.height.equalTo(@(30));
    }];
    
    UIButton *destoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:destoryBtn];
    [destoryBtn setTitle:@"Destory" forState:UIControlStateNormal];
    [destoryBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [destoryBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [destoryBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [destoryBtn addTarget:self action:@selector(destoryDialog) forControlEvents:UIControlEventTouchUpInside];
    destoryBtn.enabled = NO;
    self.destoryBtn = destoryBtn;
    
    [destoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.width.equalTo(@(80));
        make.height.equalTo(@(30));
        make.centerY.equalTo(showBtn);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    [line1 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(destoryBtn.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(1));
    }];
    
    UILabel *normallab = [[UILabel alloc] init];
    normallab.text = @"normal entry id: ";
    [self.view addSubview:normallab];
    
    [normallab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(140));
        make.height.equalTo(@(30));
    }];
    
    UITextField *textField2 = [[UITextField alloc]init];
    [self.view addSubview:textField2];
    textField2.borderStyle = UITextBorderStyleRoundedRect;

    [textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(normallab);
        make.left.equalTo(normallab.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(30));
    }];
    
    self.normalText = textField2;
    
    self.loadNativeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.loadNativeBtn];
    [self.loadNativeBtn setBackgroundColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [self.loadNativeBtn setTitle:@"load native" forState:UIControlStateNormal];
    [self.loadNativeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loadNativeBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [self.loadNativeBtn addTarget:self action:@selector(loadNative) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loadNativeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField2.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.width.equalTo(@(120));
        make.height.equalTo(@(40));
    }];
    
    self.removeNativeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.removeNativeBtn];
    [self.removeNativeBtn setBackgroundColor:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0]];
    [self.removeNativeBtn setTitle:@"remove native" forState:UIControlStateNormal];
    [self.removeNativeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.removeNativeBtn addTarget:self action:@selector(removeNative) forControlEvents:UIControlEventTouchUpInside];
    
    self.removeNativeBtn.enabled = NO;
    
    [self.removeNativeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadNativeBtn);
        make.right.equalTo(self.view).offset(-30);
        make.width.equalTo(@(120));
        make.height.equalTo(@(40));
    }];
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createNativeEntranceView {
    UIView *rootView = [[UIView alloc] init];
    rootView.layer.borderColor = [UIColor yellowColor].CGColor;
    rootView.layer.borderWidth = 1;
    [self.view addSubview:rootView];
    
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.removeNativeBtn.mas_bottom).offset(20);
        make.bottom.equalTo(self.view).offset(-kBottomSafeHeight-10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [rootView addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rootView).offset(5);
        make.left.equalTo(rootView).offset(5);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];

    UILabel *title = [[UILabel alloc] init];
    title.numberOfLines = 1;
    [title setTextColor:[UIColor greenColor]];
    [rootView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rootView).offset(5);
        make.left.equalTo(icon.mas_right).offset(10);
        make.height.equalTo(@(20));
    }];

    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, [UIScreen mainScreen].bounds.size.width-50-50-100, 20)];
    [desc setTextColor:[UIColor grayColor]];
    desc.numberOfLines = 1;
    [rootView addSubview:desc];
    
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(2);
        make.left.equalTo(title);
        make.bottom.equalTo(icon);
        make.right.equalTo(title);
    }];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.layer.cornerRadius = 5;
    [rootView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rootView).offset(10);
        make.left.equalTo(title.mas_right).offset(10);
        make.height.equalTo(@(30));
        make.width.equalTo(@(100));
        make.right.equalTo(rootView).offset(-10);
    }];
    
    UIImageView *mediaView = [[UIImageView alloc] init];
    [rootView addSubview:mediaView];
    [mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(10);
        make.left.equalTo(rootView).offset(10);
        make.right.equalTo(rootView).offset(-10);
        make.bottom.equalTo(rootView).offset(-5);
    }];
    
    self.nativeRootView = rootView;
    self.nativeIconView = icon;
    self.nativeTitleLab = title;
    self.nativeDescLab = desc;
    self.nativeCallToActionBtn = btn;
    self.nativeMediaView = mediaView;
//    rootView.hidden = YES;
}


- (void)loadFloat {
    if(![ROXManager richOXInited]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"sdk not inited please click \"start\" button to start it!" duration:3.0 position:CSToastPositionCenter];
        });
        return;
    }
    if (self.entraceView == nil || ![self.lastImageFloatId isEqualToString:self.imageText.text]) {
        if (self.imageText.text != nil && ![self.imageText.text isEqualToString:@""]) {
            self.entraceView = [[ROXFloatView alloc] initWithSceneEntryId:self.imageText.text containerView: self.floatView viewController: self delegate:self];
            self.lastImageFloatId = self.imageText.text;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"please input scence entry id " duration:3.0 position:CSToastPositionCenter];
            });
        }
    }
    if (self.entraceView != nil) {
        [self.entraceView load];
    }
}

- (void)loadNative {
    if(![ROXManager richOXInited]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"sdk not inited please click \"start\" button to start it!" duration:3.0 position:CSToastPositionCenter];
        });
        return;
    }
    if (self.native == nil || ![self.lastNativeFloatId isEqualToString:self.normalText.text]) {
        if (self.normalText.text != nil && ![self.normalText.text isEqualToString:@""]) {
            self.native = [[ROXNative alloc] initWithSceneEntryId:self.normalText.text viewController:self delegate: self];
            self.lastNativeFloatId = self.normalText.text;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"please input scence entry id " duration:3.0 position:CSToastPositionCenter];
            });
        }
    }
    
    if (self.nativeRootView == nil) {
        [self createNativeEntranceView];
    }
    
    if (self.native != nil) {
        [self.native load];
    }
}

- (void)displayNativeEntrance {
    if (self.scenecReady) {
        ROXNativeData *nativeData = [self.native nativeEntranceData];
        //dispatch_async(dispatch_get_main_queue(), ^{
        if (nativeData != nil) {
            if (nativeData.iconUrl != nil){
                [self.nativeIconView setImage:[UIImage imageWithContentsOfFile:nativeData.iconUrl]];
            }
            self.nativeTitleLab.text = nativeData.title;
            self.nativeDescLab.text = nativeData.desc;
            [self.nativeCallToActionBtn setTitle:nativeData.callToAction forState:UIControlStateNormal];
            if (nativeData.mediaUrl != nil){
                [self.nativeMediaView setImage:[UIImage imageWithContentsOfFile:nativeData.mediaUrl]];
            }
        } else {
            //test
            self.nativeTitleLab.text = @"新人抽抽乐";
            self.nativeDescLab.text = @"越玩越开心";
            [self.nativeCallToActionBtn setTitle:@"马上去玩" forState:UIControlStateNormal];
            [self.nativeIconView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://test-rox-static.ufile.ucloud.com.cn//entrance/1596188077508/chou.png"]]]];
        }
        
        [self.native registerViewForInteraction:self.nativeRootView clickableViews: self.nativeRootView.subviews];
        self.nativeRootView.hidden = NO;
        //});
    }
}

- (void)removeNative {
    self.scenecReady = NO;
    [self.nativeRootView removeFromSuperview];
    self.nativeRootView = nil;
    self.native = nil;
}

- (void)loadDialog {
    if(![ROXManager richOXInited]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"sdk not inited please click \"start\" button to start it!" duration:3.0 position:CSToastPositionCenter];
        });
        return;
    }
    if (self.dialog == nil  || ![self.lastDialogId isEqualToString:self.dialogText.text]) {
        if (self.dialogText.text != nil && ![self.dialogText.text isEqualToString:@""]) {
            self.dialog = [[ROXDialog alloc] initWithSceneEntryId:self.dialogText.text delegate:self];
            self.lastDialogId = self.dialogText.text;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"please input scence entry id " duration:3.0 position:CSToastPositionCenter];
            });
        }
    }
    if (self.dialog != nil) {
        [self.dialog load];
    }
}

- (void)showDialog {
    if ([self.dialog sceneRenderReady]) {
        [self.dialog showFromViewController:self];
    }
}

- (void)destoryDialog {
    self.dialog = nil;
    self.showBtn.enabled = NO;
    self.destoryBtn.enabled = NO;
}

- (void)sceneDidLoaded:(NSObject *)scene {
    if (scene == self.native) {
        self.scenecReady = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
        self.removeNativeBtn.enabled = YES;
        [self displayNativeEntrance];
        });
    } else if (scene == self.entraceView){
        if ([self.entraceView sceneRenderReady]) {
            //self.floatView.hidden = NO;
        }
    } else if (scene == self.dialog){
        self.showBtn.enabled = YES;
        self.destoryBtn.enabled = YES;
    }
}
- (void)scene:(NSObject *)scene didLoadedFailWithError:(ROXError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
    if (scene == self.native) {
        [self.view makeToast:@"load normal failed" duration:3.0 position:CSToastPositionCenter];
    } else if (scene == self.entraceView){
        [self.view makeToast:@"load float failed" duration:3.0 position:CSToastPositionCenter];
    } else if (scene == self.dialog){
        [self.view makeToast:@"load dialog failed" duration:3.0 position:CSToastPositionCenter];
    }});
}

- (void)sceneRendered:(NSObject *)scene {
    
}

- (void)scene:(NSObject *)scene didRenderFailWithError:(ROXError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
    if (scene == self.native) {
        [self.view makeToast:@"render normal failed" duration:3.0 position:CSToastPositionCenter];
    } else if (scene == self.entraceView){
        [self.view makeToast:@"render float failed" duration:3.0 position:CSToastPositionCenter];
    } else if (scene == self.dialog){
        [self.view makeToast:@"render dialog failed" duration:3.0 position:CSToastPositionCenter];
    }});
}

- (void)sceneWillPresentScreen:(NSObject *)scene {
    
}
- (void)sceneDidPresentScreen:(NSObject *)scene {
    
}
- (void)sceneWillDismissScreen:(NSObject *)scene {
    
}
- (void)sceneDidDismissScreen:(NSObject *)scene {
}

- (void)sceneUpdated:(NSObject *)scene {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
