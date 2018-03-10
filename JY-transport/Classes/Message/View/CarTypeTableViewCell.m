//
//  CarTypeTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2017/10/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.

#import "CarTypeTableViewCell.h"
#import "OrderModel.h"
@implementation CarTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CarTypeTableViewCell";
    CarTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}

- (void)setModel:(OrderModel *)model{
    
    _model = model;
   
    _carTypeLabel.text =  [self judgeVechileisTypeChina:model.vehicle];
    _carTypeLabel.textColor = RGB(51, 51, 51);
    _imgHeightConstraint.constant = 70 *HOR_SCALE;
    _carTypeLabel.font = [UIFont fontWithName:Default_APP_Font size:15];
    NSString *imgName= [self judgeVechileisCarTypeForImageView:model.vehicle];
    _imgView.image = [UIImage imageNamed:imgName];
}


//根据中文车型 找到 英文
- (NSString *)judgeVechileisTypeChina:(NSString *)str{
    NSString *type = @"";
    if ([str isEqualToString:@"MINIVAN"]) {
        type = @"微面";
    }else if ([str isEqualToString:@"LARGEVAN"]){
        type =  @"大型面包车";
    }else if ([str isEqualToString:@"IVECO"]){
        type =   @"依维柯";
    }else if ([str isEqualToString:@"MINITRUCK"]){
        type =   @"微型货车";
    }else if ([str isEqualToString:@"SMALLTRUCK"]){
        type =   @"小型货车";
    }else if ([str isEqualToString:@"MEDIUMTRUCK"]){
        type =   @"中型货车";
    }else if ([str isEqualToString:@"FLATBED"]){
        type =   @"平板车";
    }
    return type;
}
- (NSString *)judgeVechileisCarTypeForImageView:(NSString *)str{
    NSString *type = @"";
    if ([str isEqualToString:@"MINIVAN"]) {
        type = @"big_minibus";
    }else if ([str isEqualToString:@"LARGEVAN"]){
        type =  @"micro_facet";
    }else if ([str isEqualToString:@"IVECO"]){
        type =   @"iveco";
    }else if ([str isEqualToString:@"MINITRUCK"]){
        type =   @"mini_truck";
    }else if ([str isEqualToString:@"SMALLTRUCK"]){
        type =   @"medium_truck";
    }else if ([str isEqualToString:@"MEDIUMTRUCK"]){
        type =   @"light_van";
    }else if ([str isEqualToString:@"FLATBED"]){
        type =   @"pingbanche";
    }
    return type;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
