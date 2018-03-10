//
//  LookEvaluteTableViewCellOne.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/19.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "LookEvaluteTableViewCellOne.h"
#import "HCSStarRatingView.h"
@implementation LookEvaluteTableViewCellOne

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LookEvaluteTableViewCellOne";
    LookEvaluteTableViewCellOne *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}

- (void)setStartView:(NSString*)sum attitude:(NSString *)attitude speed:(NSString *)speed{
   
    _attitudeLabel.text = attitude;
    
   
    _serviceLabel.text = speed;
    
    HCSStarRatingView *starV = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(0, 0, 86, 20)];
    starV.maximumValue = 5;//最大星星值
    starV.minimumValue = 0;//最小的星星值
    starV.value = [speed doubleValue]; //当前值，默认0
    starV.userInteractionEnabled = NO;
    //    //是否允许半星，默认NO
    starV.allowsHalfStars = YES;
    //   是否是否允许精确选择 可以根据选择位置进行精确，默认NO
    starV.accurateHalfStars = NO;
    _serviceStartView.tintColor = RGBA(255, 173, 10, 1);
    //设置空星时的图片
    starV.emptyStarImage = [[UIImage imageNamed:@"empty_star"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];//UIImageRenderingModeAlwaysTemplate 始终根据Tint Color绘制图片，忽略图片的颜色信息。
    //设置全星时的图片
    starV.filledStarImage = [[UIImage imageNamed:@"evaluate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_serviceStartView addSubview:starV];
    

    
    
    HCSStarRatingView *starView = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(0, 0, 86, 20)];
    starView.maximumValue = 5;//最大星星值
    starView.minimumValue = 0;//最小的星星值
    starView.value = [attitude doubleValue];//当前值，默认0
    starView.userInteractionEnabled = NO;
    //    //是否允许半星，默认NO
    starView.allowsHalfStars = YES;
    //   是否是否允许精确选择 可以根据选择位置进行精确，默认NO
    starView.accurateHalfStars = NO;
    _attitudeStartView.tintColor = RGBA(255, 173, 10, 1);
    //设置空星时的图片
    starView.emptyStarImage = [[UIImage imageNamed:@"empty_star"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];//UIImageRenderingModeAlwaysTemplate 始终根据Tint Color绘制图片，忽略图片的颜色信息。
    //设置全星时的图片
    starView.filledStarImage = [[UIImage imageNamed:@"evaluate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_attitudeStartView addSubview:starView];
   
    _totalLabel.text = sum;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
