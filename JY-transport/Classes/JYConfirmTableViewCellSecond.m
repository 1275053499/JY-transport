//
//  JYConfirmTableViewCellSecond.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/4.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYConfirmTableViewCellSecond.h"
#import "LoginticModel.h"
#import "JYCompanyModel.h"
#import <UIImageView+WebCache.h>



@implementation JYConfirmTableViewCellSecond

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(LoginticModel *)model{
    
    _model = model;
    _companyPhone.text = model.group.phone;
    _companyName.text = model.group.companyname;
    _companyName.numberOfLines = 0;
    NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
    NSString *urlstr;
    if (model.group.icon == nil || [model.group.icon isEqual:[NSNull null]]) {
        urlstr = @"";
    }else{
      urlstr  = [NSString stringWithFormat:@"%@%@",url,model.group.icon];

    }
    [_companyIcon sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
}
- (void)setComModel:(JYCompanyModel *)comModel{
    
    _comModel = comModel;
    _companyPhone.text = comModel.phone;
    _companyName.text = comModel.companyname;
    _companyName.numberOfLines = 0;

    NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
    NSString *urlstr;
    if (comModel.icon == nil || [comModel.icon isEqual:[NSNull null]]) {
        urlstr = @"";
    }else{
        urlstr  = [NSString stringWithFormat:@"%@%@",url,comModel.icon];
        
    }
    [_companyIcon sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
}
@end
