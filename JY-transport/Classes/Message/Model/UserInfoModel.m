//
//  UserInfoModel.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
/**
 *  将某个对象写入文件时会调用
 *  在这个方法中说清楚哪些属性需要存储
 */

- (void)encodeWithCoder:(NSCoder *)encoder
{
    // [super encodeWithCoder:encoder];
    
    //[super mj_encode:encoder];
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.nickname forKey:@"nickname"];
    [encoder encodeObject:self.icon forKey:@"icon"];
    [encoder encodeObject:self.sexuality forKey:@"sexuality"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.qq forKey:@"qq"];
    [encoder encodeObject:self.remark forKey:@"remark"];
    [encoder encodeObject:self.weixin forKey:@"weixin"];
    [encoder encodeObject:self.microblog forKey:@"microblog"];
    
    
}
/**
 *  从文件中解析对象时会调用
 *  在这个方法中说清楚哪些属性需要存储
 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        self.nickname = [decoder decodeObjectForKey:@"nickname"];
        self.id = [decoder decodeObjectForKey:@"id"];
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.sexuality = [decoder decodeObjectForKey:@"sexuality"];
        self.qq = [decoder decodeObjectForKey:@"qq"];
        self.weixin = [decoder decodeObjectForKey:@"weixin"];
        self.microblog = [decoder decodeObjectForKey:@"microblog"];
        self.remark = [decoder decodeObjectForKey:@"remark"];
  
    }
    return self;
    
}
@end
