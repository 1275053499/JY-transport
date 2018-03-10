//
//  MessageRequsetData.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/21.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "MessageRequsetData.h"

@implementation MessageRequsetData

- (void)requestDataForMessageEvaluate:(NSString *)url evObject:(NSString *)evObject{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:@"app/evaluate/getEvaluateList"];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"evObject":evObject} success:^(id responseObj) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataForEvaluteSuccess:)]) {
            [self.delegate requestDataForEvaluteSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataForEvaluteFailed:)]) {
            [self.delegate requestDataForEvaluteFailed:error];
        }
    }];
    
}
- (void)requestDataCollection:(NSString *)url UserPhone:(NSString *)userphone DriverPhone:(NSString *)phone{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:@"app/user/truckCollection"];
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"userPhone":userPhone,@"truckPhone":phone} success:^(id responseObj) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataForCollectionSuccess:)]) {
            [self.delegate requestDataForCollectionSuccess:responseObj];
        }

        
    } failure:^(NSError *error) {

        if ([self.delegate respondsToSelector:@selector(requestDataForCollectionFailed:)]) {
            [self.delegate requestDataForCollectionFailed:error];
        }
        
    }];

    
}

- (void)requestDataDriverEvaluate:(NSString *)url DriverPhone:(NSString *)phone{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:@"app/evaluate/getSumToTruck"];
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":phone} success:^(id responseObj) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataForDriverEvaluateSuccess:)]) {
            [self.delegate requestDataForDriverEvaluateSuccess:responseObj];
        }
        
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataForDriverEvaluateFailed:)]) {
            [self.delegate requestDataForDriverEvaluateFailed:error];
        }
        
    }];

    
}
@end
