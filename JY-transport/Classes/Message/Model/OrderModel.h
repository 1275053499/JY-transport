//
//  OrderModel.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DriverInfoMode.h"
#import "JYCharteredOrderModel.h"
@interface OrderModel : NSObject


//单号
@property(nonatomic,copy)NSString *orderNo;
//出发时间
@property(nonatomic,copy)NSString *departTime;
//时间
@property(nonatomic,copy)NSString *updateDate;
@property(nonatomic,copy)NSString *createDate;

@property(nonatomic,copy)NSString *basicStatus;
@property(nonatomic,copy)NSString *endLatitude;
@property(nonatomic,copy)NSString *endLongitude;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *isNewRecord;
@property(nonatomic,copy)NSString *latitude;
@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,copy)NSString *serviceStaff;


@property(nonatomic,copy)NSString *reqApplicant;
@property(nonatomic,copy)NSString *reqName;


//出发地点
@property(nonatomic,copy)NSString *departPlace;
//到达地点
@property(nonatomic,copy)NSString *arrivePlace;
//车型
@property(nonatomic,copy)NSString *vehicleType;
//服务
@property(nonatomic,copy)NSString *service;
//服务天数
@property(nonatomic,copy)NSString *days;
//联系人
@property(nonatomic,copy)NSString *contacts;
//手机号码
@property(nonatomic,copy)NSString *phone;
//省
@property(nonatomic,copy)NSString *province;
//城
@property(nonatomic,copy)NSString *city;
//区
@property(nonatomic,copy)NSString *district;
//创建人
@property(nonatomic,copy)NSString *createBy;
//备注
@property(nonatomic,copy)NSString *remark;
//估价
@property(nonatomic,copy)NSString *evaluate;
// 星级
@property(nonatomic,copy)NSString *potin;
//出价
@property(nonatomic,assign)double bid;

@property(nonatomic,strong)NSString *vehicle;

@property(nonatomic,strong)DriverInfoMode *jyTruckergroup;

@property (nonatomic,strong)JYCharteredOrderModel *jyCharteredOrder;

@property (nonatomic,assign)int timeType;
@property (nonatomic,strong)NSString *isLieu;//是否代收货款
@property (nonatomic,strong)NSString *lieuAmount;//代收金额
@property (nonatomic,strong)NSString *annexDescription;//单据描述
@property (nonatomic,strong)NSString *enclosure;//单据图片


@end
