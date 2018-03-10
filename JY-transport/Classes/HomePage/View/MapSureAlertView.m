//
//  MapSureAlertView.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/14.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "MapSureAlertView.h"
#import "HCSStarRatingView.h"
#import "UIImageView+WebCache.h"

@interface MapSureAlertView ()
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic,strong) NSArray *imgNameArr;
@property (nonatomic,strong) HCSStarRatingView *starV;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *carId;
@property (weak, nonatomic) IBOutlet UIImageView *driverImg;

@end
@implementation MapSureAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)showSureAlertView {
    self.frame = [UIScreen mainScreen].bounds;
    UIWindow *current = [UIApplication sharedApplication].keyWindow;
    [current addSubview:self];
    self.underView.frame = CGRectMake(0, 0, ScreenWidth, 146);
    self.underView.backgroundColor = [UIColor whiteColor];
    _cancelBtn.layer.cornerRadius = 2.0;
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.borderWidth = 1;
    _cancelBtn.layer.borderColor = BGBlue.CGColor;
    _sureBtn.layer.cornerRadius = 2.0;
    _sureBtn.layer.masksToBounds = YES;
    
    [self creatStarVIew];
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [UIView setAnimationCurve:(UIViewAnimationCurveEaseOut)];
        
    }];

}

-(void)dissMIssAlertView{
    
    [UIView animateWithDuration:0.4 animations:^{
        [UIView setAnimationCurve:(UIViewAnimationCurveEaseIn)];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
- (void)setOrderMode:(OrderModel *)orderMode{
    
    _orderMode = orderMode;
    _name.text = _orderMode.jyTruckergroup.name;
    _carId.text = _orderMode.jyTruckergroup.licensePlate;
    _phoneNum.text = _orderMode.jyTruckergroup.phone;
    
    NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",url,_orderMode.jyTruckergroup.icon];
    [_driverImg sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    if (_orderMode.jyTruckergroup.isAuthentication == 1) {
        self.CertificationImg.image = [UIImage imageNamed:@"driver_head_certification_highlight"];

    }else{
        self.CertificationImg.image = [UIImage imageNamed:@"driver_head_certification_normal"];

    }
}

- (void)creatStarVIew{
    _starV = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    _starV.maximumValue = 5;//最大星星值
    _starV.minimumValue = 0;//最小的星星值
    _starV.value = [_orderMode.potin doubleValue];//当前值，默认0
    _starV.userInteractionEnabled = NO;
//    //是否允许半星，默认NO
    _starV.allowsHalfStars = YES;
//   是否是否允许精确选择 可以根据选择位置进行精确，默认NO
    _starV.accurateHalfStars = NO;
    _starView.tintColor = RGBA(255, 173, 10, 1);
    //设置空星时的图片
        _starV.emptyStarImage = [[UIImage imageNamed:@"empty_star"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];//UIImageRenderingModeAlwaysTemplate 始终根据Tint Color绘制图片，忽略图片的颜色信息。
    //设置全星时的图片
    _starV.filledStarImage = [[UIImage imageNamed:@"evaluate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [_starView addSubview:_starV];
}

@end
