//
//  UserInfoModel.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject<NSCoding>

@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *nickname;//姓名
@property(nonatomic,copy)NSString *icon;//头像
@property(nonatomic,copy)NSString *phone;//电话
@property(nonatomic,copy)NSString *sexuality;//性别
@property(nonatomic,copy)NSString *qq;//
@property(nonatomic,copy)NSString *remark;//备注
@property(nonatomic,copy)NSString *weixin;//
@property(nonatomic,copy)NSString *microblog;//

@end
