//
//  JYHomeRequestDate.h
//  JY-transport
//
//  Created by 闫振 on 2017/9/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYHomeRequestDateDelegate.h"
@interface JYHomeRequestDate : NSObject

@property (nonatomic,strong)id <JYHomeRequestDateDelegate>delegate;

+ (id)shareInstance;


/**
 * 专线下单
 */

- (void)requsetCommitDedicatedOrder:(NSString *)url evlue:(NSDictionary *)evuleDic service:(NSString *)service addressStr:(NSDictionary *)start addressEnd:(NSDictionary *)endDic describeContent:(NSString *)describeContent photo:(NSString *)photo time:(NSString *)time timeType:(NSNumber *)timeType nowTime:(NSString *)timeNow;



/**
 * 获取物流公司估价
 */

- (void)requsetInquiryQuotation:(NSString *)url orderID:(NSString *)orderID;

/**
 * 确认价格。填写地址信息
 */

- (void)requsetConfirmationAddress:(NSString *)url orderInfo:(NSDictionary *)orderInfo phone:(NSString *)phone;


/**
 * 取消物流公司
 */
- (void)requsetCancellationProvider:(NSString *)url orderID:(NSString *)orderID;


/**
 * 取消订单
 */
- (void)requsetCancelOrder:(NSString *)url cancelType:(NSString *)cancelType cancelContent:(NSString *)cancelContent orderId:(NSString *)orderId;


/**
 * 确定价格
 */
- (void)requsetConfirmationPrice:(NSString *)url orderID:(NSString *)orderID;


/**
 * 香港路线 获取价格
 */
- (void)requsetGetHongkongPrice:(NSString *)url region:(NSString*)region volume:(NSString *)volume  weight:(NSString *)weight isDistribution:(NSString *)isDistribution isWarehousing:(NSString *)isDistribution;


/**
 * 香港下单
 */

- (void)requsetCommitDedicatedOrderForHongkong:(NSString *)url  evlue:(NSDictionary *)evuleDic startPlace:(NSString *)startPlace endPlace:(NSString *)endPlace describeContent:(NSString *)describeContent photo:(NSString *)photo time:(NSString *)time timeType:(NSNumber *)timeType nowTime:(NSString *)timeNow evaluation:(NSString *)evaluation;


@end
