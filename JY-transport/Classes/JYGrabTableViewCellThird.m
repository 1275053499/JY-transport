//
//  JYGrabTableViewCellThird.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/31.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYGrabTableViewCellThird.h"
#import "JYCargoDetailsModel.h"
@implementation JYGrabTableViewCellThird

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"JYGrabTableViewCellThird";
    JYGrabTableViewCellThird *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
    
}
- (void)setvalueforCellRowTwo:(JYCargoDetailsModel *)model{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _nameLabel.text = [NSString stringWithFormat:@"名称：%@",model.name];
    _nameLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];


    _midLabel.text = [NSString stringWithFormat:@"数量：%@ 件",model.amount];
    _midLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];

    _lastLabel.text = [NSString stringWithFormat:@"重量：%@ kg",model.weight];
    _lastLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];

    
}

- (void)setvalueforCellRowThree:(JYCargoDetailsModel *)model isInsure:(int)isInsure{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _nameLabel.text = [NSString stringWithFormat:@"体积：%@ m³",model.volume];

    _midLabel.text = [NSString stringWithFormat:@"包装：%@",model.packing];
    _nameLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
    _midLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
    _lastLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
    

    if (isInsure == 1) {
        _lastLabel.textColor = BGBlue;
        _lastLabel.text = @"已投保";
        
    }else{
        
        _lastLabel.text = @"";

        
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
