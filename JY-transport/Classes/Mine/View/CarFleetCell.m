//
//  CarFleetCell.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "CarFleetCell.h"
#import "DriverInfoMode.h" 
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CarFleetViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <UIImageView+WebCache.h>
@interface CarFleetCell() <AMapSearchDelegate,BMKGeoCodeSearchDelegate>
//车主头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
//车主名字

@property (weak, nonatomic) IBOutlet UILabel *detailAddress;
//车牌
@property (weak, nonatomic) IBOutlet UILabel *plateNumber;

@property (weak, nonatomic) IBOutlet UILabel *Cartype;

@property (weak, nonatomic) IBOutlet UIButton *telPhoneCallBUtton;

@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (nonatomic,assign)CLLocationDegrees latitude;
@property (nonatomic,assign)CLLocationDegrees longitude;

@property (nonatomic,strong)AMapSearchAPI *search;
//@property (nonatomic,strong)BMKGeoCodeSearch *geoCodeSearch;
//@property (nonatomic,strong)BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraints;


@end
@implementation CarFleetCell



- (IBAction)callPhoneButton:(id)sender {
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CarFleetCell";
    CarFleetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
      
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
       
    }
    return cell;
}
- (void)creatStarView:(CGFloat)markStr{
    _starView = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    
    int vau = ceil(markStr);
    _starView.maximumValue = vau;//最大星星值
    _starView.minimumValue = 0;//最小的星星值
    _starView.value =markStr;//当前值，默认0
   _starView.userInteractionEnabled = NO;
    
    //是否允许半星，默认NO
    _starView.allowsHalfStars = YES;
    
    //是否是否允许精确选择 可以根据选择位置进行精确，默认NO
    _starSuperVIew.userInteractionEnabled = NO;
    _starView.accurateHalfStars = NO;
    
    //星星的颜色
    _starView.tintColor = RGBA(255, 173, 10, 1);

    //设置空星时的图片
//    _starView.emptyStarImage = [[UIImage imageNamed:@"evaluate_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];//UIImageRenderingModeAlwaysTemplate 始终根据Tint Color绘制图片，忽略图片的颜色信息。
    //设置全星时的图片
    _starView.filledStarImage = [[UIImage imageNamed:@"evaluate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [_starView addTarget:self action:@selector(didChange:) forControlEvents:UIControlEventValueChanged];
    [_starSuperVIew addSubview:_starView];
    

}
- (void)setCarMode:(CarTeamMode *)carMode{
    
    _carMode = carMode;
    DriverInfoMode *mode = self.carMode.truckGoup;
    CLLocationDegrees lat = [self.carMode.latitude doubleValue];
    CLLocationDegrees log =[self.carMode.longitude doubleValue];
    
    CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(CLLocationCoordinate2DMake(lat,log), AMapCoordinateTypeBaidu);
    
    self.latitude = amapcoord.latitude;
    self.longitude =amapcoord.longitude;
    self.name.text = mode.name;
    self.phone.text =mode.phone;
    self.carNumber.text = mode.licensePlate;
    self.cartype.text = mode.vehicleChs;
    
    NSString *QiNiuBaseURL = QiNiu_DownLoadImageUrl;
    NSString *drIcon = mode.icon;
    NSString *url = [NSString stringWithFormat:@"%@%@",QiNiuBaseURL,drIcon];
    NSURL *URL = [NSURL URLWithString:url];
    if (drIcon == nil) {
        URL = nil;
    }
    _drivericon.layer.cornerRadius =_drivericon.size.width/2;
    _drivericon.layer.masksToBounds = YES;
    [self.drivericon sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    _detailAddress.text = carMode.name;
    _address.text = carMode.address;
    if ([mode.basicStatus isEqualToString:@"1"]) {
        self.carBeseState.text = @"空闲";
        self.carBeseState.textColor = [UIColor colorWithHexString:@"#118AE7"];
    }else if ([mode.basicStatus isEqualToString:@"2"]){
        self.carBeseState.textColor = [UIColor colorWithHexString:@"#E47A6D"];
        self.carBeseState.text = @"忙碌";
    }else{
        
    }
//    CGFloat mark = [_carMode.avgGrade doubleValue] + [_carMode.avgPotin doubleValue];
    
//    if (mark != 0 ) {
//        [self creatStarView:(mark/2)];
//    }
    
}

@end
