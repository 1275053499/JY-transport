//
//  WaitingHeardView.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/5.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "WaitingHeardView.h"

@implementation WaitingHeardView

- (instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self commonInitView];
    }
    return self;
    
}

- (void)commonInitView{
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.userInteractionEnabled = NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_dengdaichujia"] forState:(UIControlStateNormal)];
    
    [self addSubview:btn];
    _btnTwo = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_btnTwo setBackgroundImage:[UIImage imageNamed:@"icon_querenjiage_huise"] forState:(UIControlStateNormal)];
    [_btnTwo setBackgroundImage:[UIImage imageNamed:@"icon_querenjiage_lanse"] forState:(UIControlStateSelected)];
    [self addSubview:_btnTwo];
    _btnTwo.userInteractionEnabled = NO;

    _btnThree = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_btnThree setBackgroundImage:[UIImage imageNamed:@"icon_querendingdan_huise"] forState:(UIControlStateNormal)];
    [_btnThree setBackgroundImage:[UIImage imageNamed:@"icon_querendingdan_lanse"] forState:(UIControlStateSelected)];
    [self addSubview:_btnThree];
    _btnThree.userInteractionEnabled = NO;

    
     _lineLeftView = [[UIView alloc] init];
    _lineLeftView.backgroundColor = BGBlue;
    [self addSubview:_lineLeftView];

    
    _lineRightView = [[UIView alloc] init];
    _lineRightView.backgroundColor = BGBlue;
    [self addSubview:_lineRightView];

    

    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.text = @"等待出价";
    labelOne.font =  [UIFont fontWithName:Default_APP_Font_Regu size:14];
    labelOne.textColor = BGBlue;
    [self addSubview:labelOne];


    _labelTwo = [[UILabel alloc] init];
    _labelTwo.text = @"确认价格";
    _labelTwo.font =  [UIFont fontWithName:Default_APP_Font_Regu size:14];
    [self addSubview:_labelTwo];
    
    _labelThree = [[UILabel alloc] init];
    _labelThree.text = @"确认订单";
    _labelThree.font =  [UIFont fontWithName:Default_APP_Font_Regu size:14];
    [self addSubview:_labelThree];


    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).mas_offset(23);
        make.top.mas_equalTo(self.mas_top).mas_offset(33);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
        
    }];
    
    [_btnTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
        make.centerY.mas_equalTo(btn.mas_centerY);
        make.centerX.mas_equalTo(0);
        
    }];
    
    
     [_lineLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.mas_equalTo(2);
        make.centerY.mas_equalTo(btn.mas_centerY);
        make.left.mas_equalTo(btn.mas_right);
        make.right.mas_equalTo(_btnTwo.mas_left);

        
    }];

    [_btnThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-23);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
        make.centerY.mas_equalTo(btn.mas_centerY);

        
    }];

    [_lineRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.centerY.mas_equalTo(btn.mas_centerY);
        make.left.mas_equalTo(_btnTwo.mas_right);
        make.right.mas_equalTo(_btnThree.mas_left);
        
        
    }];

    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(btn.mas_bottom).mas_offset(8);
        make.centerX.mas_equalTo(btn.mas_centerX);

    }];
    
    [_labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_btnTwo.mas_bottom).mas_offset(8);
        make.centerX.mas_equalTo(_btnTwo.mas_centerX);
        
    }];
    
    [_labelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_btnThree.mas_bottom).mas_offset(8);
        make.centerX.mas_equalTo(_btnThree.mas_centerX);
        
    }];
    
    
    
    
}
@end
