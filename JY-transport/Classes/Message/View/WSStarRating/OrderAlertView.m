//
//  OrderAlertView.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/4.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "OrderAlertView.h"

@interface OrderAlertView ()
@property(nonatomic,weak)UILabel *driverName;
@property(nonatomic,weak)UILabel *driverPhone;
@property(nonatomic,weak)UILabel *driverCarNumber;

@end





@implementation OrderAlertView

- ( instancetype )initWithFrame:(CGRect)frame withGroupNumber:(NSInteger) num{
    self = [super initWithFrame:frame];
    if (self) {

        
        _alertView = [[UIView alloc] init];
        [self addSubview:_alertView];
        _alertView.layer.cornerRadius = 10.0;
        _alertView.center = self.center;
        _alertView.frame = CGRectMake((ScreenWidth - 243)/2, (ScreenHeight - 164)/2-64, 243, 210);
        _alertView.backgroundColor = [UIColor whiteColor];
        
        UILabel *scoreLabel = [[UILabel alloc]init];
        scoreLabel.text = @"评分";
        scoreLabel.textColor = Default_label_colol;
        scoreLabel.font = [UIFont fontWithName:Default_APP_Font size:15];
        [_alertView addSubview:scoreLabel];
        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_alertView.mas_top).mas_offset(24);
            make.left.mas_equalTo(_alertView.mas_left).mas_offset(51);
        }];
        
        
        for (int i = 0; i < 5; i ++) {
            
            FMButton * button = [FMButton createFMButton];
            [button setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"empty_star"] forState:UIControlStateSelected];
            button.userInteractionEnabled = NO;
            [_alertView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.mas_equalTo(scoreLabel.mas_centerY).mas_offset(0);
             make.left.mas_equalTo(scoreLabel.mas_right).mas_offset(10 +i*26);
                make.width.mas_equalTo(19);
                make.height.mas_equalTo(18);
                
                
            }];
            
            
            
        }
        

        UIImageView *nameImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"person"]];
        [_alertView addSubview:nameImage];
        
        [nameImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_alertView.mas_top).mas_offset(54);
            make.left.mas_equalTo(_alertView.mas_left).mas_offset(25);
            make.width.mas_equalTo(34/2);
            make.height.mas_equalTo(36/2);
            
        }];
        UILabel *driverName = [[UILabel alloc]init];
    
      
        self.driverName = driverName;
        driverName.textColor = Default_label_colol;
        driverName.font = [UIFont fontWithName:Default_APP_Font size:15];
        [_alertView addSubview:driverName];
        [driverName mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(nameImage.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(nameImage.mas_right).mas_offset(12);
        }];
        
   
        //创建中间灰色分割线
        UIView * separateBottomLine = [[UIView alloc] init];
        separateBottomLine.backgroundColor = [UIColor colorWithRed:153.f/255 green:153.f/255 blue:153.f/255 alpha:1];
        [_alertView addSubview:separateBottomLine];
        separateBottomLine.alpha = 0.3;
//        separateBottomLine.frame = CGRectMake(0, CGRectGetMaxY(driverName.frame) + 12 , _alertView.bounds.size.width, 0.5);
        
        [separateBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(nameImage.mas_bottom).mas_offset(12);
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(_alertView.mas_left).mas_offset(25);
            make.right.mas_equalTo(_alertView.mas_right).mas_offset(-25);
        }];
        
        //电话
        
        
        UIImageView *phoneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone"]];
        [_alertView addSubview:phoneImage];
        
        [phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_alertView.mas_top).mas_offset(98);
            make.left.mas_equalTo(_alertView.mas_left).mas_offset(25);
            make.width.mas_equalTo(34/2);
            make.height.mas_equalTo(36/2);
            
        }];
        UILabel *driverPhone = [[UILabel alloc]init];
        self.driverPhone = driverPhone;
        driverPhone.textColor =Default_label_colol;
        driverPhone.font = [UIFont fontWithName:Default_APP_Font size:15];
        [_alertView addSubview:driverPhone];
        [driverPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(phoneImage.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(phoneImage.mas_right).mas_offset(12);
        }];
        
        
        //创建中间灰色分割线
        UIView * separateBottomLine2 = [[UIView alloc] init];
        separateBottomLine2.alpha = 0.3;
        separateBottomLine2.backgroundColor = [UIColor colorWithRed:153.f/255 green:153.f/255 blue:153.f/255 alpha:1];
        [_alertView addSubview:separateBottomLine2];
        //        separateBottomLine.frame = CGRectMake(0, CGRectGetMaxY(driverName.frame) + 12 , _alertView.bounds.size.width, 0.5);
        
        [separateBottomLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(phoneImage.mas_bottom).mas_offset(12);
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(_alertView.mas_left).mas_offset(25);
            make.right.mas_equalTo(_alertView.mas_right).mas_offset(-25);
        }];
        

        //车牌
        
        
        UIImageView *CarNumberImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"plate_number"]];
        [_alertView addSubview:CarNumberImage];
        
        [CarNumberImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_alertView.mas_top).mas_offset(136);
            make.left.mas_equalTo(_alertView.mas_left).mas_offset(25);
            make.width.mas_equalTo(34/2);
            make.height.mas_equalTo(36/2);
            
        }];
        UILabel *driverCarNumber = [[UILabel alloc]init];
        self.driverCarNumber =driverCarNumber;
        driverCarNumber.textColor = Default_label_colol;
        driverCarNumber.font = [UIFont fontWithName:Default_APP_Font size:15];
        [_alertView addSubview:driverCarNumber];
        [driverCarNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(CarNumberImage.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(phoneImage.mas_right).mas_offset(12);
        }];
        
//
        //创建中间灰色分割线
        UIView * separateBottomLine3 = [[UIView alloc] init];
        separateBottomLine3.alpha = 0.3;
        separateBottomLine3.backgroundColor = [UIColor colorWithRed:153.f/255 green:153.f/255 blue:153.f/255 alpha:1];
        [_alertView addSubview:separateBottomLine3];
        
        [separateBottomLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(CarNumberImage.mas_bottom).mas_offset(12);
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(_alertView.mas_left).mas_offset(25);
            make.right.mas_equalTo(_alertView.mas_right).mas_offset(-25);
        }];
        
        

        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(separateBottomLine.frame)  , _alertView.frame.size.width / 2, 42)];
        [_alertView addSubview:_cancelButton];
        [_cancelButton setTitleColor:[UIColor colorWithRed:16.f/255 green:123.f/255 blue:251.f/255 alpha:1] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
         [_cancelButton setTitleColor:Default_label_colol forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        _cancelButton.tag = 0;
        [_cancelButton addTarget:self action:@selector(didClickBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
        UIBezierPath *cancelmaskPath = [UIBezierPath bezierPathWithRoundedRect:_cancelButton.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *cancelmaskLayer = [[CAShapeLayer alloc] init];
        cancelmaskLayer.frame = _cancelButton.bounds;
        cancelmaskLayer.path = cancelmaskPath.CGPath;
        _cancelButton.layer.mask = cancelmaskLayer;
        
        
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(separateBottomLine3.mas_bottom).mas_offset(0);
            make.width.mas_equalTo(_alertView.bounds.size.width/2);
            make.left.mas_equalTo(_alertView.mas_left).mas_offset(0);
            make.bottom.mas_equalTo(_alertView.mas_bottom).mas_offset(0);
        }];
        
        

        
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(_alertView.bounds.size.width/2, CGRectGetMaxY(separateBottomLine.frame) , _alertView.frame.size.width / 2, 42)];
        [_alertView addSubview:_confirmButton];
        _confirmButton.tag = 1;
        [_confirmButton setTitleColor:[UIColor colorWithRed:16.f/255 green:123.f/255 blue:251.f/255 alpha:1] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmButton setBackgroundColor:[UIColor whiteColor]];
        [_confirmButton addTarget:self action:@selector(didClickBtnConfirm:) forControlEvents:UIControlEventTouchUpInside];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_confirmButton.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _confirmButton.bounds;
        maskLayer.path = maskPath.CGPath;
        _confirmButton.layer.mask = maskLayer;
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(separateBottomLine3.mas_bottom).mas_offset(0);
            make.width.mas_equalTo(_alertView.bounds.size.width/2);
            make.right.mas_equalTo(_alertView.mas_right).mas_offset(0);
            make.bottom.mas_equalTo(_alertView.mas_bottom).mas_offset(0);
        }];
        
        //创建中间灰色分割线
        UIView * mLine = [[UIView alloc] init];
        mLine.alpha = 0.3;
        mLine.backgroundColor = [UIColor grayColor];
        [_alertView addSubview:mLine];
        mLine.frame = CGRectMake(_alertView.bounds.size.width / 2,  CGRectGetMaxY(separateBottomLine3.frame) + 2, 0.5, 42);
        [mLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(separateBottomLine3.mas_bottom).mas_offset(0);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(42);
            make.centerX.mas_equalTo(_alertView.mas_centerX).mas_offset(0);
            
        }];
        
        
        
    }
    return self;
    
}

- (void)setModel:(OrderModel *)model
{
    _model = model;
    
    self.driverName.text = model.jyTruckergroup.name;
    self.driverCarNumber.text = model.jyTruckergroup.licensePlate;
    self.driverPhone.text = model.jyTruckergroup.phone;
}



- (void) didClickBtnCancel:(UIButton *)btn {
    [self.delegate ButtonDidCilckedWithCancleOrConfirm:@"cancle"];
    [_alertView removeFromSuperview];
    [self removeFromSuperview];
}
- (void) didClickBtnConfirm:(UIButton *)btn {
    
   [self.delegate ButtonDidCilckedWithCancleOrConfirm:@"OK"];
    [_alertView removeFromSuperview];
    [self removeFromSuperview];
}


@end
