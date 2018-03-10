//
//  MyiconImageView.m
//  JY-transport
//
//  Created by 闫振 on 2017/12/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "MyiconImageView.h"
#import "UserInfoModel.h"
#import <UIImageView+WebCache.h>

@interface  MyiconImageView()

@end
//@property (nonatomic,strong)UILabel *nameLabel;
//@property (nonatomic,strong)UILabel *phoneLabel;
//@property (nonatomic,strong)UIImageView *imgView;



@implementation MyiconImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        /* 添加子控件的代码*/
        [self creatSubViews];
        
    }
    return self;
}

//- (void)layoutSubviews {
//    // 一定要调用super的方法
//    [super layoutSubviews];
//
//    //确定子控件的frame（这里得到的self的frame/bounds才是准确的）
//
//}

- (void)creatSubViews{
    
    self.imgView = [[UIImageView alloc] init];
    self.imgView.layer.cornerRadius  = 32;
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.borderWidth = 1;
    self.imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.image = [UIImage imageNamed:@"mine_nav_bg"];
    [self addSubview:self.imgView ];
    [self.imgView  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).mas_offset(16);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-27);
        make.width.height.mas_equalTo(64);
        
    }];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"mine_icon_phone"];
    [self addSubview:iconView];
    [iconView  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.imgView.mas_right).mas_offset(18);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-34);
        make.width.height.mas_equalTo(14);

    }];

    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
    self.phoneLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.phoneLabel];
    
    [self.phoneLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.left.mas_equalTo(iconView.mas_right).mas_offset(3);
            make.centerY.mas_equalTo(iconView.mas_centerY);
    
        }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.nameLabel];
    
    [self.nameLabel  mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(self.imgView.mas_right).mas_offset(18);
        make.bottom.mas_equalTo(iconView.mas_top).mas_offset(-14);

    }];
    
    self.chooseIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chooseIconBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:self.chooseIconBtn];
    [self.chooseIconBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(64);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);

        
    }];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}

- (void)setUserModel:(UserInfoModel *)userModel{
    
    _userModel = userModel;
    NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",url,_userModel.icon];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.nameLabel.text = userModel.nickname;
    self.phoneLabel.text = userPhone;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
