//
//  OrderThreeCell.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "OrderThreeCell.h"

@implementation OrderThreeCell

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderThreeCell";
    OrderThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
        
    }
    return cell;
}

- (void)setDateFromString:(NSString *)str{
    if (str == nil || str.length <= 0) {
        return;
    }
    NSRange range = [str rangeOfString:@"."]; //现获取要截取的字符串位置
    NSString * result = [str substringToIndex:range.location]; //截取字符串
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDictionary *weekDict = @{@"2" : @"周一", @"3" : @"周二", @"4" : @"周三", @"5" : @"周四", @"6" : @"周五", @"7" : @"周六", @"1" : @"周日"};
    
    NSDate *date = [format dateFromString:result];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:date];
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:date];
    NSInteger week = [calendar component:NSCalendarUnitWeekday fromDate:date];
    NSInteger hour = [calendar component:NSCalendarUnitHour fromDate:date];
    NSInteger minute = [calendar component:NSCalendarUnitMinute fromDate:date];
    
    NSString *weekStr = weekDict[[NSString stringWithFormat:@"%ld",(long)week]];
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld·%ld(%@) %ld:%ld:00",(long)month,(long)day,weekStr,hour,(long)minute];
    self.timeLabel.text = dateStr;
    
}

@end
