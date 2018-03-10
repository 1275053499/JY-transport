//
//  JYMessageRequestDataDelegate.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/16.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JYMessageRequestDataDelegate <NSObject>
@optional

//专线下单
- (void)requestGetOrderToLogisticsSuccess:(NSDictionary *)resultDic;

- (void)requestGetOrderToLogisticsFailed:(NSError *)error;

//获取物流公司信息

- (void)requsetGetCompanyInfoSuccess:(NSDictionary *)resultDic;

- (void)requsetGetCompanyInfoFailed:(NSError *)error;

//查询网点
- (void)requestGetLogisticsbaranchListSuccess:(NSDictionary *)resultDic;

- (void)requestGetLogisticsbaranchListFailed:(NSError *)error;


//用户提交评论
- (void)requsetCommitVaulteSuccess:(NSDictionary *)resultDic;

- (void)requsetCommitVaulteFailed:(NSError *)error;

//查看评价总分
- (void)requsetGetSumByLogisticsSuccess:(NSDictionary *)resultDic;

- (void)requsetGetSumByLogisticsFailed:(NSError *)error;


//查看评价
- (void)requGetEvaluateByLogisticsSuccess:(NSDictionary *)resultDic;

- (void)requGetEvaluateByLogisticsFailed:(NSError *)error;

//查看物流
- (void)requestGetTrackingByNumberSuccess:(id )resultDic;

- (void)requestGetTrackingByNumberFailed:(NSError *)error;


@end
