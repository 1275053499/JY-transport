//
//  JYOrderDetailModel.h
//  JY-transport
//
//  Created by 闫振 on 2017/9/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYCargoDetailsModel.h"
#import "JYOrderAddressModel.h"
#import "JYServiceProviderModel.h"
@interface JYOrderDetailModel : NSObject
@property (nonatomic,strong)NSString *deliveryTime;
@property (nonatomic,strong)NSString *describeContent;
@property (nonatomic,strong)NSString *describePhoto;
@property (nonatomic,strong)NSString *destination;
@property (nonatomic,strong)NSString *destinationCity;
@property (nonatomic,strong)NSString *destinationProvince;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *insuranceAmount;
@property (nonatomic,strong)NSString *isDistribution;
@property (nonatomic,assign)int isInsure;
@property (nonatomic,strong)NSString *isLieu;
@property (nonatomic,strong)NSString *isWarehousing;
@property (nonatomic,strong)JYCargoDetailsModel *jyCargoDetails;
@property (nonatomic,strong)JYOrderAddressModel *jyOrderSupplementary;
@property (nonatomic,strong)JYServiceProviderModel *jyServiceProvider;
@property (nonatomic,strong)NSString *orderTime;
@property (nonatomic,strong)NSString *orderStatus;
@property (nonatomic,strong)NSString *lieuAmount;
@property (nonatomic,strong)NSString *orderType;
@property (nonatomic,strong)NSString *originatingCity;
@property (nonatomic,strong)NSString *originatingProvince;
@property (nonatomic,strong)NSString *originatingSite;
@property (nonatomic,strong)NSString *serviceDetails;
@property (nonatomic,strong)NSString *specifiedTime;
@property (nonatomic,assign)int timeType;
@property (nonatomic,strong)NSString *valueofGoods;
@property (nonatomic,strong)NSString *transportNumber;
@property (nonatomic,strong)NSArray *jyTransportationTrackings;
@property (nonatomic,strong)NSString *orderNo;


@end
