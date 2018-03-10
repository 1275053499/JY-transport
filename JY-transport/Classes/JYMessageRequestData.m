//
//  JYMessageRequestData.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/16.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYMessageRequestData.h"

@implementation JYMessageRequestData

+ (id)shareInstance{
    static JYMessageRequestData *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (helper == nil) {
            helper = [[JYMessageRequestData alloc]init];
        }
    });
    return  helper;
}
//获取物流公司信息
- (void)requsetGetCompanyInfoByLogisticsId:(NSString *)url logisticsId:(NSString *)logisticsId{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"logisticsId":logisticsId} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requsetGetCompanyInfoSuccess:)]) {
            [self.delegate requsetGetCompanyInfoSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requsetGetCompanyInfoFailed:)]) {
            [self.delegate requsetGetCompanyInfoFailed:error];
        }
        
    }];
    
}

//订单列表
- (void)requsetGetOrderToLogistics:(NSString *)url phone:(NSString *)phone statusPage:(NSInteger )statusPage page:(NSInteger)page{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":phone,@"status":@(statusPage),@"page":@(page)} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestGetOrderToLogisticsSuccess:)]) {
            [self.delegate requestGetOrderToLogisticsSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestGetOrderToLogisticsFailed:)]) {
            [self.delegate requestGetOrderToLogisticsFailed:error];
        }
        
    }];
    

    
}

/**
 *  获取网点列表  
 */
- (void)requsetgetLogisticsbaranchListUrl:(NSString *)url ID:(NSString *)ID{
    
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"logisticsid":ID} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestGetLogisticsbaranchListSuccess:)]) {
            [self.delegate requestGetLogisticsbaranchListSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestGetLogisticsbaranchListFailed:)]) {
            [self.delegate requestGetLogisticsbaranchListFailed:error];
        }
    }];
    
    
}
//用户提交评价
- (void)requsetCommitVaulte:(NSString *)url orderId:(NSString *)orderId speedScore:(NSString *)speedScore attitudeScore:(NSString *)attitudeScore evComment:(NSString *)evComment appraiser:(NSString *)appraiser{
    
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"orderId":orderId,@"speedScore":speedScore,@"attitudeScore":attitudeScore,@"evComment":evComment,@"appraiser":appraiser} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requsetCommitVaulteSuccess:)]) {
            [self.delegate requsetCommitVaulteSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requsetCommitVaulteFailed:)]) {
            [self.delegate requsetCommitVaulteFailed:error];
        }
    }];

    
}


/**
 *  查看评价 获取总分
 */
- (void)requGetSumByLogistics:(NSString *)url logisticsId:(NSString *)logisticsId{
    
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"logisticsId":logisticsId} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requsetGetSumByLogisticsSuccess:)]) {
            [self.delegate requsetGetSumByLogisticsSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requsetGetSumByLogisticsFailed:)]) {
            [self.delegate requsetGetSumByLogisticsFailed:error];
        }
    }];
    
}

/**
 *  查看评价
 */
- (void)requGetEvaluateByLogistics:(NSString *)url logisticsId:(NSString *)logisticsId page:(NSString*)page{

    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"logisticsId":logisticsId,@"page":page} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requGetEvaluateByLogisticsSuccess:)]) {
            [self.delegate requGetEvaluateByLogisticsSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requGetEvaluateByLogisticsFailed:)]) {
            [self.delegate requGetEvaluateByLogisticsFailed:error];
        }
    }];
    
}

//查看物流
- (void)requestGetTrackingByNumber:(NSString *)url transportNumber:(NSString *)transportNumber{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"transportNumber":transportNumber} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestGetTrackingByNumberSuccess:)]) {
            [self.delegate requestGetTrackingByNumberSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestGetTrackingByNumberFailed:)]) {
            [self.delegate requestGetTrackingByNumberFailed:error];
        }
    }];
    
}

@end
