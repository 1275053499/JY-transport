//
//  TMPassWordView.m
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/28.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "TMPassWordView.h"

#define Square_number 6
@interface TMPassWordView ()<UITextFieldDelegate>

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,assign)CGRect ViewFrame;
@property (nonatomic,strong)id objVC;
@end

@implementation TMPassWordView
static NSString  * const MONEYNUMBERS = @"0123456789";


- (instancetype)initWithFrame:(CGRect)frame WithDelegate:(id)objVC{
    if (self = [super initWithFrame:frame]) {
        
        _ViewFrame = frame;
        _objVC = objVC;
        [self stepUI];
    }
    return self;
    
}
- (void)stepUI{
    
    _bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, _ViewFrame.size.width, _ViewFrame.size.height)];
    _bgView.backgroundColor = self.backgroundColor;
    [self addSubview:_bgView];
   
    CGFloat passWidth = 45;
    _textFieldView = [[TMTextFieldView alloc] initWithFrame:CGRectMake((ScreenWidth - passWidth *6)/2, 50, passWidth * 6, passWidth)];
    _textFieldView.Square_Width = passWidth;
    _textFieldView.delegate = _objVC;
    [_bgView addSubview:_textFieldView];
    
    
    [self creatlabel];
    
}
- (void)creatlabel{
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    self.titleLabel.frame = CGRectMake(0, 10, _ViewFrame.size.width, 15);
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = _title;
}

- (void)deleteAllPassWords{
    
    [self.textFieldView deleteAllPassWord];
}


@end
