//
//  ReportAppEventViewController.m
//  ModooPlayDemo
//
//  Created by moodoo on 2021/4/30.
//  Copyright © 2021 Moodoo Play. All rights reserved.
//

#import "ReportAppEventViewController.h"
@import RichOXBase;
#import "Masonry.h"
#import "macro.h"
#import "UIView+Toast.h"
@import RichOXToolBox;

@interface ReportAppEventViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UITextField *valueText;
@property (nonatomic, strong) UITextField *countText;

@end

@implementation ReportAppEventViewController

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
    titleLab.text = @"应用内事件";
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
    
    UILabel *eventNamelab = [[UILabel alloc] init];
    eventNamelab.text = @"事件名称: ";
    [self.view addSubview:eventNamelab];
        
    [eventNamelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(100));
        make.height.equalTo(@(30));
    }];
        
    UITextField *textField = [[UITextField alloc]init];
    [self.view addSubview:textField];
    textField.borderStyle = UITextBorderStyleRoundedRect;

    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(eventNamelab);
        make.left.equalTo(eventNamelab.mas_right).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(30));
    }];
        
    self.nameText = textField;
                
    UILabel *paramLab = [[UILabel alloc] init];
    paramLab.text = @"事件值: ";
    [self.view addSubview:paramLab];
        
    [paramLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(eventNamelab.mas_bottom).offset(20);
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
        
    self.valueText = paramTextField;
    
    UILabel *countLab = [[UILabel alloc] init];
    countLab.text = @"事件次数: ";
    [self.view addSubview:countLab];
        
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paramLab.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.width.equalTo(@(100));
        make.height.equalTo(@(30));
    }];
        
    UITextField *countField = [[UITextField alloc]init];
    [self.view addSubview:countField];
    countField.borderStyle = UITextBorderStyleRoundedRect;
    countField.delegate = self;
    [countField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countLab);
        make.left.equalTo(countLab.mas_right).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(30));
    }];
        
    self.countText = countField;
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:sendBtn];
    [sendBtn setTitle:@"发送事件" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [sendBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [sendBtn addTarget:self action:@selector(sendEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countField.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(150));
        make.height.equalTo(@(30));
    }];
    
    UIButton *getEventValueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:getEventValueBtn];
    [getEventValueBtn setTitle:@"获取事件值" forState:UIControlStateNormal];
    [getEventValueBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [getEventValueBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [getEventValueBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [getEventValueBtn addTarget:self action:@selector(getEventValue) forControlEvents:UIControlEventTouchUpInside];
    
    [getEventValueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sendBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(150));
        make.height.equalTo(@(30));
    }];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:saveBtn];
    [saveBtn setTitle:@"存储用户私有数据" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [saveBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [saveBtn addTarget:self action:@selector(savePrivacyData) forControlEvents:UIControlEventTouchUpInside];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getEventValueBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(150));
        make.height.equalTo(@(30));
    }];
    
    UIButton *queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:queryBtn];
    [queryBtn setTitle:@"获取单个事件值" forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [queryBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [queryBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [queryBtn addTarget:self action:@selector(queryPrivacyData) forControlEvents:UIControlEventTouchUpInside];
    
    [queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(150));
        make.height.equalTo(@(30));
    }];
    
    UIButton *queryKeysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:queryKeysBtn];
    [queryKeysBtn setTitle:@"获取多个事件值" forState:UIControlStateNormal];
    [queryKeysBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:147.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [queryKeysBtn setTitleColor:[UIColor colorWithRed:135.0/255.0 green:216.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [queryKeysBtn setTitleColor:[UIColor lightGrayColor]  forState:UIControlStateDisabled];
    [queryKeysBtn addTarget:self action:@selector(queryPrivacyDatas) forControlEvents:UIControlEventTouchUpInside];
    
    [queryKeysBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(queryBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(150));
        make.height.equalTo(@(30));
    }];
}

- (void) closePage {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.countText){
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11) return NO;//限制长度
        return YES;
    }else{
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if ( proposedNewLength > 20) return NO;//限制长度
        return YES;
    }
}

- (void)sendEvent {
    if (self.nameText.text == nil || [self.nameText.text isEqualToString:@""]) {
        return;
    }
    
    if (self.valueText.text != nil && ![self.valueText.text isEqualToString:@""]) {
        [RichOXBaseManager reportAppEvent:self.nameText.text eventValue:self.valueText.text];
    } else {
        if (self.countText.text != nil && ![self.countText.text isEqualToString:@""]) {
            int count = [self.countText.text intValue];
            
            for (int i=0; i< count; i++) {
                [RichOXBaseManager reportAppEvent:self.nameText.text eventValue:nil];
            }
        } else {
            [RichOXBaseManager reportAppEvent:self.nameText.text eventValue:nil];
        }
    }
    
}

- (void)getEventValue {
    if (self.nameText.text == nil || [self.nameText.text isEqualToString:@""]) {
        return;
    }
    
    [RichOXBaseManager getAppEventValue:self.nameText.text block:^(NSString *eventName, NSString *eventValue){
        NSLog(@"eventName:%@, eventValue:%@", eventName, eventValue);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:[NSString stringWithFormat:@"eventValue is %@",eventValue] duration:5.0 position:CSToastPositionCenter];
        });
    }];
    
}

- (void)savePrivacyData {
    if (self.nameText.text == nil || [self.nameText.text isEqualToString:@""] || self.valueText.text == nil || [self.valueText.text isEqualToString:@""]) {
        return;
    }
    
    [RichOXToolKit saveUserPrivacyKey:self.nameText.text value:self.valueText.text success: ^() {
        NSLog(@"saveUserPrivacyKey success");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"success" duration:5.0 position:CSToastPositionCenter];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"saveUserPrivacyKey: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"failed" duration:5.0 position:CSToastPositionCenter];
        });
    }];
}

- (void)queryPrivacyData {
    if (self.nameText.text == nil || [self.nameText.text isEqualToString:@""]) {
        return;
    }
    
    [RichOXToolKit queryUserPrivacyKey:self.nameText.text success: ^(RichOXUserPrivacyData *userData) {
        NSLog(@"queryUserPrivacyKey success, userData: %@", [userData description]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:[userData description] duration:5.0 position:CSToastPositionCenter];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"queryUserPrivacyKey: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:@"failed" duration:5.0 position:CSToastPositionCenter];
        });
    }];
}

- (void)queryPrivacyDatas {
    if (self.nameText.text == nil || [self.nameText.text isEqualToString:@""]) {
        return;
    }
    
    NSArray *keys = [self.nameText.text componentsSeparatedByString:@";"];

    [RichOXToolKit queryUserPrivacyKeys:keys success: ^(NSArray <RichOXUserPrivacyData *> *userDatas) {
        NSMutableString *result = [NSMutableString new];
        [result appendString:@"["];
        if (userDatas != nil) {
            for (RichOXUserPrivacyData *data in userDatas) {
                [result appendString:[data description]];
                [result appendString:@","];
            }
        }
        [result appendString:@"]"];
        NSLog(@"queryUserPrivacyKey success, userDatas: %@", result);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:result duration:5.0 position:CSToastPositionCenter];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"queryUserPrivacyKey: %@", error);
    }];
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
