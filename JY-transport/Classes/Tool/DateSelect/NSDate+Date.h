//
//  NSDate+Date.h
//  我的-设置
//
//  Created by 胡松 on 2017/9/12.
//  Copyright © 2017年 husong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Date)
//时间转字符串 指定格式 yyyy-MM-dd HH:mm:ss
+(NSString *)stringWithDate:(NSDate *)date;

//获取当前时间 str 格式(YYYYMMddhhmmss)
+ (NSString *)getnowDate:(NSString *)str;
@end
