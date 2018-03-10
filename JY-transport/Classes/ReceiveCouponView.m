//
//  ReceiveCouponView.m
//  JY-transport
//
//  Created by 闫振 on 2018/1/4.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "ReceiveCouponView.h"
@interface ReceiveCouponView()

@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)UIImageView *closeImgView;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UILabel *moneyLabel;

@end

@implementation ReceiveCouponView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
        [self updateFrame];
    }
    return self;
}
- (void)commonInit{
    
    UIButton *bottomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    bottomBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:bottomBtn];
    _bottomBtn = bottomBtn;
    
    _bottomView = [[UIView alloc] init];
    _bottomView.layer.cornerRadius = 10;
    _bottomView.layer.masksToBounds = YES;
    _bottomView.backgroundColor = RGB(247, 111, 84);
    [_bottomBtn addSubview:_bottomView];
    
    _closeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_close"]];
    _closeImgView.userInteractionEnabled = NO;
    [_bottomBtn addSubview:_closeImgView];
    
    _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_gift"]];
    _imgView.userInteractionEnabled = NO;
    [_bottomView addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"恭喜你获得";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    _titleLabel.textColor = [UIColor whiteColor];
    [_bottomView addSubview:_titleLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    
   
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    _moneyLabel.textColor = [UIColor whiteColor];
    [_bottomView addSubview:_moneyLabel];
    
    
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@"30"];
    
    NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:40],NSForegroundColorAttributeName:RGB(255, 232, 106),};
    [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
    
    NSMutableAttributedString * secondPart = [[NSMutableAttributedString alloc] initWithString:@"元找车券"];
    
    NSDictionary * secondAttributes = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:15],NSForegroundColorAttributeName:RGB(255, 232, 106),};
    [secondPart setAttributes:secondAttributes range:NSMakeRange(0,1)];
    
         NSDictionary * thirdAttDic = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:15],NSForegroundColorAttributeName:RGB(255, 255, 255),};
        [secondPart setAttributes:thirdAttDic range:NSMakeRange(1,secondPart.length -1)];
    
    [firstPart appendAttributedString:secondPart];
    _moneyLabel.attributedText = firstPart;
    
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.text = @"可在\"我的优惠券\"中查看";
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:11];
    _contentLabel.textColor = [UIColor whiteColor];
    [_bottomView addSubview:_contentLabel];
    
    _finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _finishBtn.backgroundColor = RGB(255, 237, 34);
    [_finishBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    _finishBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
    [_finishBtn setTitleColor:RGB(51, 51, 51) forState:(UIControlStateNormal)];
    _finishBtn.layer.cornerRadius = 22;
    _finishBtn.layer.masksToBounds = YES;
    [_bottomView addSubview:_finishBtn];
    [_finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
}
- (void)updateFrame{
    
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(280 * HOR_SCALE);
        make.centerX.mas_equalTo(_bottomBtn.centerX);
        make.centerY.mas_equalTo(_bottomBtn.centerY).mas_offset(0);
        make.height.mas_equalTo(335 * HOR_SCALE);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(_bottomView.centerX);
        make.top.equalTo(_bottomView.mas_top).offset(15 * HOR_SCALE);

    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(_bottomView.centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10 * HOR_SCALE);

    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(_bottomView.centerX);
        make.width.height.mas_equalTo(110 * HOR_SCALE);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(15 * HOR_SCALE);

    }];
    
    [self.closeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(_bottomView.centerX);
        make.top.mas_equalTo(self.bottomView.mas_bottom).mas_equalTo(30 * HOR_SCALE);
        
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(_bottomView.centerX);
        make.top.mas_equalTo(self.imgView.mas_bottom).mas_equalTo(30 * HOR_SCALE);
        
    }];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLabel.mas_bottom).mas_equalTo(9 * HOR_SCALE);
        make.height.mas_equalTo(44);
        make.left.equalTo(_bottomView.mas_left).offset(15);
        make.right.equalTo(_bottomView.mas_right).offset(-15);
        
    }];
}

- (void)showCouponView{
    
    UIWindow *wind = [UIApplication sharedApplication].keyWindow;
    [wind addSubview: self];
    
}
- (void)bottomBtnClick:(UIButton *)btn{
    
    [self disMissView];
    
}
- (void)disMissView{
    
    
    [self removeFromSuperview];
    
}
- (void)finishBtnClick:(UIButton *)btn{
      [self disMissView];
}


@end


