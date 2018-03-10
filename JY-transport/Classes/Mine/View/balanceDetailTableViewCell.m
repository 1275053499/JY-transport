//
//  balanceDetailTableViewCell.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "balanceDetailTableViewCell.h"
@interface balanceDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *moneyStyle;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *creatTime;

@property (weak, nonatomic) IBOutlet UILabel *moneyNumber;

@end

@implementation balanceDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"balanceDetailTableViewCell";
    balanceDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}

 - (void)setModel:(balanceDetailModel *)model
{
    _model = model;
    
    self.moneyStyle.text = model.payType;
    NSString *str = [NSString stringWithFormat:@"%.2f",[model.settlement doubleValue]];
    self.balanceLabel.text = [@"余额 " stringByAppendingString:str];//model.settlement;
    self.creatTime.text = model.createDate;
    self.moneyNumber.text = model.amount;
 


}
@end
