//
//  JYGrabValueTableViewCell.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYGrabValueTableViewCell.h"

@implementation JYGrabValueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"JYGrabValueTableViewCell";
    JYGrabValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
    
}


- (void)setDateFromString:(JYOrderDetailModel *)model{
    
    if (model.timeType == 0) {
        
        self.sendType.text = @"即时发货";
        
    }else{
        
        [self setDateForSendType:model.deliveryTime];
    }

    
    

}
- (void)setDateForSendType:(NSString *)str{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDictionary *weekDict = @{@"2" : @"周一", @"3" : @"周二", @"4" : @"周三", @"5" : @"周四", @"6" : @"周五", @"7" : @"周六", @"1" : @"周日"};
    
    NSDate *date = [format dateFromString:str];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:date];
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:date];
    NSInteger week = [calendar component:NSCalendarUnitWeekday fromDate:date];
    NSInteger hour = [calendar component:NSCalendarUnitHour fromDate:date];
    NSInteger minute = [calendar component:NSCalendarUnitMinute fromDate:date];
    
    NSString *weekStr = weekDict[[NSString stringWithFormat:@"%ld",(long)week]];
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld·%ld(%@) %ld:%ld:00",(long)month,(long)day,weekStr,hour,(long)minute];
    self.sendType.text = dateStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
