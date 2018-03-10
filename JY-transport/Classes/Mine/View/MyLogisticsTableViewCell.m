//
//  MyLogisticsTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2017/11/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "MyLogisticsTableViewCell.h"
#import "LoginticModel.h"
#import <UIImageView+WebCache.h>
#import "JYCompanyModel.h"

@implementation MyLogisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MyLogisticsTableViewCell";
    MyLogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
        
    }
    return cell;
}
- (void)setModel:(LoginticModel *)model{
    _model = model;
    _phone.text = model.group.phone;
    _companyName.text = model.group.companyname;
    _companyName.numberOfLines = 0;
    NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
    NSString *urlstr;
    if (model.group.icon == nil || [model.group.icon isEqual:[NSNull null]]) {
        urlstr = @"";
    }else{
        urlstr  = [NSString stringWithFormat:@"%@%@",url,model.group.icon];
        
    }
    [_companyIcon sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"logistics_img_acquiescence"]];
}
- (IBAction)LogisticsOrdersClick:(UIButton *)sender {
    [MBProgressHUD showInfoMessage:@"此功能即将开通"];
}

- (void)setComModel:(JYCompanyModel *)comModel{
    
    _comModel = comModel;
    _phone.text = comModel.phone;
    _companyName.text = comModel.companyname;
    _companyName.numberOfLines = 0;

    NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
    NSString *urlstr;
    if (comModel.icon == nil || [comModel.icon isEqual:[NSNull null]]) {
        urlstr = @"";
    }else{
        urlstr  = [NSString stringWithFormat:@"%@%@",url,comModel.icon];
        
    }
    [_companyIcon sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"logistics_img_acquiescence"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
