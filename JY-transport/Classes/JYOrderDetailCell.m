//
//  JYOrderDetailCell.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/17.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYOrderDetailCell.h"
#import "JYOrderDetailModel.h"
#import "JYOrderAddressModel.h"
@implementation JYOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"JYOrderDetailCell";
    JYOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}
- (void)setModel:(JYOrderDetailModel *)model{
    _model = model;
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *addressStr = _model.jyOrderSupplementary.senderAddress;
    NSString *addressEnd = _model.jyOrderSupplementary.recipientsAddress;
    
    NSString *senderName = _model.jyOrderSupplementary.senderName;
    NSString *senderPhone = _model.jyOrderSupplementary.senderPhone;
    
    NSString *recipientsName = _model.jyOrderSupplementary.recipientsName;
    NSString *recipientsPhone = _model.jyOrderSupplementary.recipientsPhone;
    
    _sendPhone.text = senderPhone;
    _sendName.text = senderName;
    _nameLabel.text = recipientsName;
    _phoneLabel.text = recipientsPhone;
    if (senderPhone == nil || [senderPhone isEqual:[NSNull null]]) {
        _sendPhone.text = @"";
    }
    if (senderName == nil || [senderName isEqual:[NSNull null]]) {
        _sendName.text = @"";
    }
    if (recipientsName == nil || [recipientsName isEqual:[NSNull null]]) {
        _nameLabel.text = @"";
    }
    if (recipientsPhone == nil || [recipientsPhone isEqual:[NSNull null]]) {
        _phoneLabel.text = @"";
    }

    if (addressStr == nil || [addressStr isEqual:[NSNull null]]) {
        addressStr = @"";
    }
    if (addressEnd == nil || [addressEnd isEqual:[NSNull null]]) {
        addressEnd = @"";
    }
    
    NSString *startStr = [NSString stringWithFormat:@"%@%@",_model.originatingSite,addressStr];
    NSString *endStr = [NSString stringWithFormat:@"%@%@",_model.destination,addressEnd];
    
    _startLabel.text = startStr;
    _endLabel.text = endStr;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
