
//
//  carTeamTableViewCell.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "carTeamTableViewCell.h"
#import <UIImageView+WebCache.h>
@interface carTeamTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *driverImgView;
@property (weak, nonatomic) IBOutlet UILabel *carNumber;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *vehicleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation carTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"carTeamTableViewCell";
    carTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}
- (void)setDriverinfoMode:(DriverInfoMode *)driverinfoMode
{
    
    _driverinfoMode = driverinfoMode;
    self.carNumber.text = self.driverinfoMode.licensePlate;
    self.phoneNumber.text = self.driverinfoMode.phone;
    self.nameLabel.text = self.driverinfoMode.name;
    self.vehicleLabel.text = self.driverinfoMode.vehicle;
    self.nameLabel.numberOfLines = 0;
    NSString *QiNiuBaseURL = QiNiu_DownLoadImageUrl;
    NSString *drIcon = self.driverinfoMode.icon;
    NSString *url = [NSString stringWithFormat:@"%@%@",QiNiuBaseURL,drIcon];
    NSURL *URL = [NSURL URLWithString:url];
    if (drIcon == nil) {
        URL = nil;
    }
    
    [self.driverImgView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"default_avatar"]];

    if ([_driverinfoMode.isCollection isEqualToString:@"0"]) {
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    }else{
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"collect_select"] forState:UIControlStateNormal];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
