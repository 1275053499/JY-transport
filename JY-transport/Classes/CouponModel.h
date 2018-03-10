//
//  CouponModel.h
//  JY-transport
//
//  Created by 闫振 on 2018/1/4.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *ID;
@property (nonatomic,strong)NSString *cpCondition;
@property (nonatomic,strong)NSString *deliveryTime;///时间
@property (nonatomic,strong)NSString *basicStatus;
@property (nonatomic,strong)NSString *cpValue;
@property (nonatomic,strong)NSString *picture;///图片
@property (nonatomic,strong)NSString *title;///标题
@property (nonatomic,strong)NSString *cpContent;///使用规则
@property (nonatomic,strong)NSString *cpLabel;


@end
