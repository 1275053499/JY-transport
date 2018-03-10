//
//  WaitingForLoadView.m
//  JY-transport
//
//  Created by 闫振 on 2018/2/1.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "WaitingForLoadView.h"

@interface WaitingForLoadView ()
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIView *maskView;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,assign)NSInteger num;
@property (nonatomic,strong)NSTimer *timer;

@end
@implementation WaitingForLoadView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _num = 10;
        [self initializeUi];
        
    }
    return self;
    
}

- (void)initializeUi{
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self addSubview:_bottomView];
    
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    maskView.layer.cornerRadius = 5;
    maskView.layer.masksToBounds = YES;
    _maskView = maskView;
    [_bottomView addSubview:maskView];
    UILabel *contenLabel = [[UILabel alloc] init];
    contenLabel.numberOfLines = 2;
    contenLabel.textAlignment = NSTextAlignmentCenter;
    contenLabel.text = @"您的装货时间只有30分钟\n超时将会收取额外的费用";
    contenLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    contenLabel.textColor = [UIColor whiteColor];
    [_maskView addSubview:contenLabel];
    _contentLabel = contenLabel;
    
    UIButton *closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [closeBtn setImage:[UIImage imageNamed:@"close_load"] forState:(UIControlStateNormal)];
    _closeBtn = closeBtn;
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_bottomView addSubview:closeBtn];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    _timeLabel = timeLabel;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.text = @"10s";
    _timeLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:17];
    _timeLabel.textColor = [UIColor whiteColor];
    [_maskView addSubview:_timeLabel];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setContentStr) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}
- (void)layoutSubviews{
    _bottomView.frame = CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height);
    
    _maskView.frame = CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height - 60);
    
    _contentLabel.frame =CGRectMake(0,20, _maskView.frame.size.width, 50);
    
    _closeBtn.frame = CGRectMake((self.frame.size.width - 30)/2, _maskView.frame.origin.y + _maskView.frame.size.height + 30, 30, 30);
    
    _timeLabel.frame = CGRectMake((self.maskView.frame.size.width - 100)/2, _contentLabel.origin.y + _contentLabel.size.height +15, 100, 25);
    
}
- (void)setContentStr{

    if (_num <= 0) {
        [_timer invalidate];
        _timer = nil;
        [self closeBtnClick];
        return;
    }
    
    _num --;
    NSString *contentStr = [NSString stringWithFormat:@"%lds",_num];
    self.timeLabel.text = contentStr;
}
- (void)closeBtnClick{
    
    [self removeFromSuperview];
}
@end
