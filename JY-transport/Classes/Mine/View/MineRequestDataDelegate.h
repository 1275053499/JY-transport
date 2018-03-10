//
//  MineRequestDataDelegate.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MineRequestDataDelegate <NSObject>

@optional

- (void)requestDataInMineSuccess:(NSDictionary *)resultDic;

- (void)requestDataInMineFailed:(NSError *)error;


//获取司机余额成功
- (void)requestDataGetWalletForDriverSuccess:(NSDictionary *)resultDic;
//获取司机余额失败
- (void)requestDataGetWalletForDriverFailed:(NSError *)error;


//查看物流
- (void)requestGetTrackingByNumberSuccess:(id )resultDic;

- (void)requestGetTrackingByNumberFailed:(NSError *)error;

//查看附近物流公司
- (void)requestNearbyLogisticesSuccess:(id )resultDic;

- (void)requestNearbyLogisticesFailed:(NSError *)error;

//获取收藏的物流公司
- (void)requestGetCollectionListForLogisticesSuccess:(id )resultDic;

- (void)requestGetCollectionListForLogisticesFailed:(NSError *)error;

//收藏物流公司
- (void)requestCollectionLogisticesSuccess:(id )resultDic;

- (void)requestCollectionLogisticesFailed:(NSError *)error;

//取消收藏物流公司
- (void)requestCancelCollectionLogisticesSuccess:(id )resultDic;

- (void)requestCancelCollectionLogisticesFailed:(NSError *)error;

//搜索物流公司(省市区)
- (void)requestSearchLogisticesSuccess:(id )resultDic;

- (void)requestSearchLogisticesFailed:(NSError *)error;

//搜索物流公司(电话和名称)
- (void)requestSearchLogisticesWithPhoneSuccess:(id )resultDic;

- (void)requestSearchLogisticesWithPhoneFailed:(NSError *)error;

@end
