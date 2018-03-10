//
//  JYMessageRequestData.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/16.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYMessageRequestDataDelegate.h"
@interface JYMessageRequestData : NSObject

@property (nonatomic,strong)id <JYMessageRequestDataDelegate>delegate;


+ (id)shareInstance;

//订单列表
- (void)requsetGetOrderToLogistics:(NSString *)url phone:(NSString *)phone statusPage:(NSInteger )statusPage page:(NSInteger)page;


//获取物流公司信息
- (void)requsetGetCompanyInfoByLogisticsId:(NSString *)url logisticsId:(NSString *)logisticsId;

/**
 *  获取网点列表  获取员工列表路线列表
 */
- (void)requsetgetLogisticsbaranchListUrl:(NSString *)url ID:(NSString *)ID;



//用户提交评价
- (void)requsetCommitVaulte:(NSString *)url orderId:(NSString *)orderId speedScore:(NSString *)speedScore attitudeScore:(NSString *)attitudeScore evComment:(NSString *)evComment appraiser:(NSString *)appraiser;



/**
 *  查看评价 获取总分
 */
- (void)requGetSumByLogistics:(NSString *)url logisticsId:(NSString *)logisticsId;

/**
 *  查看评价
 */
- (void)requGetEvaluateByLogistics:(NSString *)url logisticsId:(NSString *)logisticsId page:(NSString*)page;

//查看物流
- (void)requestGetTrackingByNumber:(NSString *)url transportNumber:(NSString *)transportNumber;


@end
