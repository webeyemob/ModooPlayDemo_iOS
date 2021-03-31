//
//  RealNameView.m
//
//  Created by tgcenter on 2021/3/23.
//  Copyright © 2021 tgcenter. All rights reserved.
//

#import "RealNameView.h"

@interface RealNameView ()

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *idNumberTextField;

@property (nonatomic, strong) realNameOnClick callback;
@property (nonatomic, strong) closeBtnOnClick closeCallback;

@end

@implementation RealNameView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.bounds.size.width, 30)];
        titleLab.text = @"实名认证";
        titleLab.textAlignment = NSTextAlignmentCenter;
        [titleLab setFont:[UIFont boldSystemFontOfSize:22]];
        [self addSubview:titleLab];
        
        
        UILabel *descLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, self.bounds.size.width-40, 90)];
        descLab.text = @"根据国家相关规定，未实名用户有 1 小时游客体验模式，且在同一设备上，15 天内不得重复体验游客模式。";
        descLab.numberOfLines = 0;
        [descLab setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:descLab];
        
        [self addSubview:self.nameTextField];
        
        [self addSubview:self.idNumberTextField];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 210, self.bounds.size.width/2, 30);
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
       // [btn.titleLabel setTextColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(toRealName) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn1.frame = CGRectMake(self.bounds.size.width/2, 210, self.bounds.size.width/2, 30);
        [btn1 setTitle:@"关闭" forState:UIControlStateNormal];
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:16]];
       // [btn.titleLabel setTextColor:[UIColor whiteColor]];
        [btn1 addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn1];
        
    }
    return self;
}

- (UITextField *)nameTextField {
    if (_nameTextField == nil) {
        _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 135, self.bounds.size.width-30, 30)];
        _nameTextField.placeholder = @"姓名";
        _nameTextField.layer.cornerRadius = 10;
        _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    
    return _nameTextField;
}

- (UITextField *)idNumberTextField {
    if (_idNumberTextField == nil) {
        _idNumberTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 170, self.bounds.size.width-30, 30)];
        _idNumberTextField.placeholder = @"身份证";
        _idNumberTextField.layer.cornerRadius = 10;
        _idNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    
    return _idNumberTextField;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)toRealName {
    if (self.callback) {
        self.callback(_nameTextField.text, _idNumberTextField.text);
    }
}

- (void)setClickCallBack:(realNameOnClick)callback {
    self.callback = callback;
}

- (void)close {
    if (self.closeCallback) {
        self.closeCallback();
    }
}

- (void)setCloseCallBack:(closeBtnOnClick)callback {
    self.closeCallback = callback;
}

@end
