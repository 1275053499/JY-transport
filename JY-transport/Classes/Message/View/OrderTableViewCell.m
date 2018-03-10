//
//  OrderTableViewCell.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "OrderTableViewCell.h"

@interface OrderTableViewCell()


@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *sourceTopLabel;

@property (weak, nonatomic) IBOutlet UILabel *sourcedownLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property(nonatomic,strong)NSMutableArray *arrivePlaceAddressArray;
@property(nonatomic,strong)NSMutableArray *arrivePlaceArray;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation OrderTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderTableViewCell";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
       // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
          cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}

- (void)setModel:(OrderModel *)model
{
    _model = model;
    NSRange range = [model.departTime rangeOfString:@"."]; //现获取要截取的字符串位置
    NSString * result = [model.departTime substringToIndex:range.location]; //截取字符串
    self.timeLabel.text = result;
    
    self.sourceTopLabel.text = model.departPlace;
    self.sourcedownLabel.text = model.city;
    self.orderLabel.text = [NSString stringWithFormat:@"订单编号: %@",model.orderNo];
    
    
    self.arrivePlaceAddressArray = [NSMutableArray array];
    NSArray *arr= [self.model.arrivePlace componentsSeparatedByString:@","];
    [self.arrivePlaceAddressArray addObjectsFromArray:arr];
    [self.arrivePlaceAddressArray removeLastObject];
    
    
    self.arrivePlaceArray = [NSMutableArray array];
    NSArray *arrivePlaceArr= [self.model.district componentsSeparatedByString:@","];
    [self.arrivePlaceArray addObjectsFromArray:arrivePlaceArr];
    [self.arrivePlaceArray removeLastObject];
    
    
    self.destinationTopLabel.text = self.arrivePlaceAddressArray.lastObject;
    self.destinationDownLabel.text = self.arrivePlaceArray.lastObject;
    
//    self.moneyLabel.text = [@"¥ " stringByAppendingString:[NSString stringWithFormat:@"%.0f",self.model.bid]];

    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.0f",self.model.bid];
    self.carTypeLabel.textColor = [UIColor colorWithHexString:@"#DD7C6D"];

    
    if ([model.basicStatus isEqualToString:@"0"]) {
        
        self.carTypeLabel.text = @"等待接单";
    }else if ([model.basicStatus isEqualToString:@"1"]){
        self.carTypeLabel.text = @"已接单";
    }else if ([model.basicStatus isEqualToString:@"2"]){
        self.carTypeLabel.text = @"进行中";
    }else if ([model.basicStatus isEqualToString:@"3"]){
        self.carTypeLabel.text = @"未支付";
    }else if ([model.basicStatus isEqualToString:@"4"] || [model.basicStatus isEqualToString:@"9"] ){
        self.carTypeLabel.text = @"已完成";
    }else if ([model.basicStatus isEqualToString:@"5"]){
        self.carTypeLabel.text = @"已取消";
        self.moneyLabel.hidden = YES;
    }else if ([model.basicStatus isEqualToString:@"6"]){
        self.carTypeLabel.text = @"等待确认";

    }else if ([model.basicStatus isEqualToString:@"7"]){
        self.carTypeLabel.text = @"装货中";
    }else if ([model.basicStatus isEqualToString:@"8"]){
        self.carTypeLabel.text = @"卸货中";
    }else{
        
        
    }
    
    
   // self.carTypeLabel.text = model
    
}







@end
