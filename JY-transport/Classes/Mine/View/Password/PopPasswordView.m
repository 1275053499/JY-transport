//
//  PopPasswordView.m
//  TTPassword
//
//  Created by ttcloud on 16/6/20.
//  Copyright © 2016年 ttcloud. All rights reserved.
//

#import "PopPasswordView.h"

@interface  PopPasswordView()
@property (nonatomic,strong)UILabel *labmoney;
@end

@implementation PopPasswordView



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIView *view0=[[UIView alloc]initWithFrame:self.frame];
        view0.backgroundColor = RGB(51, 51, 51);
        view0.alpha=0.5;
        [self addSubview:view0];
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-280)/2, 200, 280, 190)];
        view.layer.cornerRadius=11;
        view.backgroundColor=[UIColor whiteColor];
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view0.mas_top).mas_offset(200);
            make.height.mas_equalTo(190);
            make.width.mas_equalTo(280);
            make.centerX.mas_equalTo(0);
        }];
        
        UIButton *disbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        disbtn.frame=CGRectMake(8,8, 22, 22);
        [view addSubview:disbtn];

        [disbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_top).mas_offset(0);
            make.left.mas_equalTo(view.mas_left).mas_offset(0);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(44);
        }];
        
        [disbtn setImage:[UIImage imageNamed:@"iconClose"] forState:UIControlStateNormal];
        [disbtn addTarget:self action:@selector(disbtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.tip=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 17)];
        self.tip.textAlignment = NSTextAlignmentCenter;
        self.tip.font=[UIFont systemFontOfSize:14];
        self.tip.textColor = RGB(51, 51, 51);
        self.tip.font = [UIFont fontWithName:Default_APP_Font_Regu size:17];
        self.tip.textAlignment = NSTextAlignmentCenter;
        self.tip.text=@"请输入支付密码";
        [view addSubview: self.tip];

        [self.tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(disbtn.mas_centerY);
            make.centerX.mas_equalTo(0);

        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGB(204, 204, 204);
        [view addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(view.mas_width);
            make.top.mas_equalTo(self.tip.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(0.5);
        }];

        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 200, 30)];
        lab.font = [UIFont fontWithName:Default_APP_Font_Regu size:13];
        lab.textColor = RGB(51, 51, 51);

        lab.text = @"提现金额(元)";
        [view addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(lineView.mas_bottom).mas_offset(12);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(15);
        }];
        
        UILabel *labmoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 200, 30)];
        labmoney.text = @"";
        labmoney.font = [UIFont fontWithName:Default_APP_Font_Regu size:30];
        labmoney.textColor = RGB(51, 51, 51);
        _labmoney = labmoney;
        [view addSubview:labmoney];

        [labmoney mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(lab.mas_bottom).mas_offset(10);
            make.centerX.mas_equalTo(0);
        }];


        CGFloat passWidth = (view.frame.size.width- 40 * 6)/2;
        self.tmPasswordView = [[TMTextFieldView alloc] initWithFrame:CGRectMake(passWidth, 93, 40 * 6, 50)];
        self.tmPasswordView.Square_Width = 40;
        [view addSubview:self.tmPasswordView];

        [self.tmPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(passWidth);
            make.right.mas_equalTo(-passWidth);
            make.bottom.mas_equalTo(view.mas_bottom).mas_offset(-10);
            make.height.mas_equalTo(50);
        }];



    }
    return self;
}
- (void)setMoney:(NSString *)money{
    
    _money = money;
    _labmoney.text = [NSString stringWithFormat:@"¥%@",money];
    
}
- (void)disbtnAction:(UIButton *)btn{
    [self removeFromSuperview];
}
@end

