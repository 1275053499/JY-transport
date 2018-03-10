//
//  MineRequestData.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "MineRequestData.h"

@interface MineRequestData ()


@end
@implementation MineRequestData
+ (id)shareInstance{
    
    static MineRequestData *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (helper == nil) {
            helper = [[MineRequestData alloc]init];
        }
    });
    return  helper;
}



- (void)requsetDataId:(NSString *)Id icon:(NSString *)icon{
    
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/user/updateUserInfo"];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"id":Id,@"icon":icon} success:^(id responseObj) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataInMineSuccess:)]) {
            [self.delegate requestDataInMineSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataInMineFailed:)]) {
            [self.delegate requestDataInMineFailed:error];
        }
    }];
    
    
}

/**
 *  获取余额
 */
- (void)requestDataGetWalletForDriver:(NSString *)url phone:(NSString *)tel idea:(NSString *)idea{
    
    NSString *phoneNumber = userPhone;
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/wallet/getWalletByUser"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":phoneNumber,@"idea":@"0"} success:^(id responseObj) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataGetWalletForDriverSuccess:)]) {
            [self.delegate requestDataGetWalletForDriverSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestDataGetWalletForDriverFailed:)]) {
            
            [self.delegate requestDataGetWalletForDriverFailed:error];
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

//查看附近的物流公司
- (void)requestNearbyLogistices:(NSString *)url location:(CLLocationCoordinate2D)location page:(NSInteger)page{
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    NSNumber *latitude = [NSNumber numberWithDouble:location.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:location.longitude];

    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"latitude":latitude,@"longitude":longitude,@"page":@(page)} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestNearbyLogisticesSuccess:)]) {
            [self.delegate requestNearbyLogisticesSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestNearbyLogisticesFailed:)]) {
            [self.delegate requestNearbyLogisticesFailed:error];
        }
    }];
    
}

//搜索物流公司（省市区)
- (void)requestSearchLogistices:(NSString *)url province:(NSString *)province city:(NSString *)city district:(NSString *)district{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"province":province,@"city":city,@"district":district} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestSearchLogisticesSuccess:)]) {
            [self.delegate requestSearchLogisticesSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestSearchLogisticesFailed:)]) {
            [self.delegate requestSearchLogisticesFailed:error];
        }
    }];
    
}

//搜索物流公司（电话和名称)
- (void)requestSearchLogisticesWithPhone:(NSString *)url condition:(NSString *)condition{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"condition":condition} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestSearchLogisticesWithPhoneSuccess:)]) {
            [self.delegate requestSearchLogisticesWithPhoneSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestSearchLogisticesWithPhoneFailed:)]) {
            [self.delegate requestSearchLogisticesWithPhoneFailed:error];
        }
    }];
    
}

//获取收藏的物流
- (void)requestGetCollectionListForLogistices:(NSString *)url phone:(NSString *)phone{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":phone} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestGetCollectionListForLogisticesSuccess:)]) {
            [self.delegate requestGetCollectionListForLogisticesSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestGetCollectionListForLogisticesFailed:)]) {
            [self.delegate requestGetCollectionListForLogisticesFailed:error];
        }
    }];
    
}

//添加收藏物流
- (void)requestCollectionLogistices:(NSString *)url phone:(NSString *)phone logisticsId:(NSString *)logisticsId{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"phone":phone,@"logisticsId":logisticsId} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestCollectionLogisticesSuccess:)]) {
            [self.delegate requestCollectionLogisticesSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestCollectionLogisticesFailed:)]) {
            [self.delegate requestCollectionLogisticesFailed:error];
        }
    }];
}

//取消收藏物流公司
- (void)requestCancelCollectionLogistices:(NSString *)url logisticsId:(NSString *)logisticsId{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"myLogisticisId":logisticsId} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requestCancelCollectionLogisticesSuccess:)]) {
            [self.delegate requestCancelCollectionLogisticesSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestCancelCollectionLogisticesFailed:)]) {
            [self.delegate requestCancelCollectionLogisticesFailed:error];
        }
    }];
    
}
@end
