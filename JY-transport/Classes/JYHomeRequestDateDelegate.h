//
//  JYHomeRequestDateDelegate.h
//  JY-transport
//
//  Created by 闫振 on 2017/9/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JYHomeRequestDateDelegate <NSObject>

@optional

//专线下单
- (void)requestCommitDedicatedOrderSuccess:(NSDictionary *)resultDic;

- (void)requestCommitDedicatedOrderFailed:(NSError *)error;

//获取物流公司估价
- (void)requsetInquiryQuotationSuccess:(NSDictionary *)resultDic;

- (void)requsetInquiryQuotationFailed:(NSError *)error;


// 确定价格后 提交地址信息
- (void)requsetConfirmationAddressSuccess:(NSDictionary *)resultDic;

- (void)requsetConfirmationAddressFailed:(NSError *)error;

// 取消物流公司
- (void)requsetCancellationProviderSuccess:(NSDictionary *)resultDic;
- (void)requsetCancellationProviderFailed:(NSError *)error;


// 确定价格  状态7
- (void)requsetConfirmationPriceSuccess:(NSDictionary *)resultDic;
- (void)requsetConfirmationPriceFailed:(NSError *)error;


// 取消订单
- (void)requsetCancelOrderSuccess:(NSDictionary *)resultDic;
- (void)requsetCancelOrderFailed:(NSError *)error;

// 香港下单确定价格
- (void)requsetGetHongkongPriceSuccess:(NSDictionary *)resultDic;
- (void)requsetGetHongkongPriceFailed:(NSError *)error;

// 香港下单
- (void)requsetHongkongOrderSuccess:(NSDictionary *)resultDic;
- (void)requsetHongkongOrderFailed:(NSError *)error;

@end
