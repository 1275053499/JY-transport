//
//  SearchOrderView.m
//  JY-transport
//
//  Created by 闫振 on 2017/12/6.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//
#import "TimeOutFeeView.h"
#import "NoticeTableViewCell.h"
@interface TimeOutFeeView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)UIImageView *imgView;

@end

@implementation TimeOutFeeView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
    }
    return self;
}
- (void)commonInit{
    
    UIButton *bottomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    bottomBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:bottomBtn];
    _bottomBtn = bottomBtn;
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,0,0) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
    [_bottomBtn addSubview:self.tableView];
    
    _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_close"]];
    _imgView.userInteractionEnabled = NO;
    [_bottomBtn addSubview:_imgView];
    
}
- (void)layoutSubviews{
    
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(280 * HOR_SCALE);
        make.centerX.mas_equalTo(_bottomBtn.centerX);
        make.centerY.mas_equalTo(_bottomBtn.centerY);
        make.height.mas_equalTo(200);
        
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(_tableView.centerX);
        make.top.mas_equalTo(self.tableView.mas_bottom).mas_equalTo(30);

        
    }];
    
}

- (void)showTimeOutView{
    
    UIWindow *wind = [UIApplication sharedApplication].keyWindow;
    [wind addSubview: self];
    
}
- (void)bottomBtnClick:(UIButton *)btn{
    
    [self disMissView];
    
}
- (void)disMissView{
    
  
    [self removeFromSuperview];
  
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NoticeTableViewCell class]) owner:self options:nil][0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    cell.nameLabel.textColor = RGB(153, 153, 153);
    cell.switchBtn.hidden = YES;
    cell.detailLab.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    cell.detailLab.textColor = RGB(51, 51, 51);
    
    
    if (indexPath.section == 0) {
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        lab.textColor = RGB(51, 51, 51);
        lab.font =[UIFont fontWithName:Default_APP_Font_Regu size:15];
        lab.text = _title;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.centerX = cell.centerX;
        lab.centerY = cell.centerY;
        [cell.contentView addSubview:lab];
    }else{
        cell.nameLabel.text = _nameArr[indexPath.section - 1];
        
        cell.detailLab.text = _valueArr[indexPath.section - 1];
    }
    
  
    return cell;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
    [self.tableView endEditing:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

