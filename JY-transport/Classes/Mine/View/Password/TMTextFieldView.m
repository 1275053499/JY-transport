//
//  TMTextFieldView.m
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/30.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "TMTextFieldView.h"



//#define Square_Width 45
#define Square_number 6
#define SquareY 0

@interface TMTextFieldView ()<UITextFieldDelegate>

@property (nonatomic,strong)UIView *bgView;

@end

@implementation TMTextFieldView
static NSString  * const MONEYNUMBERS = @"0123456789";


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _Square_Width = 45;
        [self stepUI:frame];
    }
    return self;

}
- (void)stepUI:(CGRect)frame{
    
    _bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.Square_Width * Square_number, self.Square_Width)];
    
    _bgView.layer.borderWidth = 0.5;
    _bgView.layer.borderColor = RGB(153, 153, 153).CGColor;
    _bgView.backgroundColor = self.backgroundColor;
    [self addSubview:_bgView];
    
    UITextField * pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, SquareY, 10, 10)];
    pwdTextField.delegate = self;
    pwdTextField.secureTextEntry = YES;
    
    self.pwdTextField = pwdTextField;
    [self.pwdTextField addTarget:self action:@selector(textChanged:) forControlEvents:(UIControlEventEditingChanged)];
    pwdTextField.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
    pwdTextField.tintColor = pwdTextField.backgroundColor;
    [pwdTextField setTextColor:pwdTextField.backgroundColor];
    pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    pwdTextField.tag = 1000;
    [_bgView addSubview:pwdTextField];
  
    [self creatTextfields];
}
-(void)setSquare_Width:(CGFloat)Square_Width{
    
    _Square_Width = Square_Width;
    
}
- (void)layoutSubviews{
    
    _bgView.frame = CGRectMake(0, 0,self.Square_Width * Square_number, self.Square_Width);
    _pwdTextField.frame = CGRectMake(0, SquareY, 10, 10);
    
    float initialX = (_bgView.frame.size.width - self.Square_Width * Square_number) / 2;
    
    for (int i = 0; i < Square_number; i++)
    {
        UITextField *pwsField = [self viewWithTag:100 + i];
        pwsField.frame =  CGRectMake(initialX + i * self.Square_Width , SquareY, self.Square_Width, self.Square_Width);
    }
    
    
    for (int i = 1; i < Square_number; i++) {
        UIView *lineView = [self viewWithTag:200 + i];
        
        lineView.frame = CGRectMake(initialX + i * self.Square_Width, SquareY, 1, self.Square_Width);
        
    }
}
- (void)creatTextfields{
    
    float initialX = (_bgView.frame.size.width - self.Square_Width * Square_number) / 2;
    
    for (int i = 0; i < Square_number; i++) {
        UITextField *pwsField = [[UITextField alloc]initWithFrame:CGRectMake(initialX + i * self.Square_Width , SquareY, self.Square_Width, self.Square_Width)];
        pwsField.textAlignment = 1;
        pwsField.tag = i + 100;
        pwsField.font = [UIFont systemFontOfSize:25];
        pwsField.keyboardType = UIKeyboardTypeNumberPad;
//        pwsField.layer.borderWidth = 0.5;
//        pwsField.layer.borderColor = RGB(153, 153, 153).CGColor;
        pwsField.secureTextEntry = YES;
        pwsField.userInteractionEnabled = NO;
        [_bgView addSubview:pwsField];
    }
    for (int i = 1; i < Square_number; i++) {
        UIView *lineView = [[UITextField alloc]initWithFrame:CGRectMake(initialX + i * self.Square_Width, SquareY, 0.5, self.Square_Width)];
        lineView.tag = i + 200;
        lineView.backgroundColor =  RGB(197, 197, 197);
        [_bgView addSubview:lineView];
    }
    
}

- (void)textChanged:(UITextField *)text{
    
    self.pwdPassword = text.text;
    if ([self.delegate respondsToSelector:@selector(passWordDidChange:)]) {
        [self.delegate passWordDidChange:self];
    }
    if (text.text.length < 7) {
        [self distributionPws];
    }
    if (self.pwdPassword.length == Square_number) {
        if ([self.delegate respondsToSelector:@selector(passWordCompleteInput:)]) {
            [self.delegate passWordCompleteInput:self];
        }
    }
    
}
- (void)distributionPws{
    
    for (int i = 0; i < Square_number; i++) {
        if (i <  self.pwdPassword.length) {
            UITextField *pwsField = (UITextField *)[self viewWithTag:100 + i];
            pwsField.text = @"1";//随便输个几占位
        }else{
            UITextField *pwsField = (UITextField *)[self viewWithTag:100 + i];
            pwsField.text = @"";
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *passWordRegex = @"^[0-9]*$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if (![passWordPredicate evaluateWithObject:string]) {
        return NO;
    }else{
        
        if (textField.text.length >= Square_number ) {
            return NO;
        }else{
            return YES;
        }
    }
    
}

/**
 *  删除文本
 */
- (void)deleteAllPassWord{
    
    if (_pwdPassword.length >= 6) {
        
        _pwdPassword = @"";
        self.pwdTextField.text = @"";
        
        [self distributionPws];
    }
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.pwdTextField becomeFirstResponder];
}


@end

