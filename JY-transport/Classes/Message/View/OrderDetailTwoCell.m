//
//  OrderDetailTwoCell.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "OrderDetailTwoCell.h"
#import "OrderModel.h"
@implementation OrderDetailTwoCell

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderDetailTwoCell";
    OrderDetailTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
        
    }
    return cell;
}
- (void)setOrderStutas:(OrderModel *)model{
    
    self.orderContent.textColor = RGB(255, 57, 55);

    if ([model.basicStatus isEqualToString:@"0"]) {
        self.orderContent.text = @"等待接单";
    }else if ([model.basicStatus isEqualToString:@"1"]){
        
        self.orderContent.text = @"已接单";
    }else if ([model.basicStatus isEqualToString:@"2"]){
        
        self.orderContent.text = @"进行中";
    }else if ([model.basicStatus isEqualToString:@"3"]){
        self.orderContent.text = @"未支付";
        
    }else if ([model.basicStatus isEqualToString:@"4"] || [model.basicStatus isEqualToString:@"9"] ){
        self.orderContent.text = @"完成";
        
    }else if ([model.basicStatus isEqualToString:@"5"]){
        
        self.orderContent.text = @"取消";
        
        
    }else if ([model.basicStatus isEqualToString:@"6"]){
        self.orderContent.text = @"等待确认";
        
    }else if ([model.basicStatus isEqualToString:@"7"]){
         self.orderContent.text = @"装货中";
    }else if ([model.basicStatus isEqualToString:@"8"]){
         self.orderContent.text = @"卸货中";
    }else{
        
        
    }

}

@end
