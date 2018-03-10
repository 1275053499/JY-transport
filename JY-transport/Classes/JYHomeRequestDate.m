//
//  JYHomeRequestDate.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYHomeRequestDate.h"

@implementation JYHomeRequestDate

+ (id)shareInstance{
    
    static JYHomeRequestDate *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (helper == nil) {
            helper = [[JYHomeRequestDate alloc]init];
        }
    });
    return  helper;
}

/**
 * 取消物流公司
 */

- (void)requsetCancellationProvider:(NSString *)url orderID:(NSString *)orderID{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"orderId":orderID} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requsetCancellationProviderSuccess:)]) {
            [self.delegate requsetCancellationProviderSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requsetCancellationProviderFailed:)]) {
            [self.delegate requsetCancellationProviderFailed:error];
        }
    }];
}

/**
 * 确定价格
 */
- (void)requsetConfirmationPrice:(NSString *)url orderID:(NSString *)orderID{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"orderId":orderID} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requsetConfirmationPriceSuccess:)]) {
            [self.delegate requsetConfirmationPriceSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requsetConfirmationPriceFailed:)]) {
            [self.delegate requsetConfirmationPriceFailed:error];
        }
    }];

}

/**
 * 取消订单
 */
- (void)requsetCancelOrder:(NSString *)url cancelType:(NSString *)cancelType cancelContent:(NSString *)cancelContent orderId:(NSString *)orderId{
    

    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"orderId":orderId,@"cancelType":cancelType,@"cancelContent":cancelContent} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requsetCancelOrderSuccess:)]) {
            [self.delegate requsetCancelOrderSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requsetCancelOrderFailed:)]) {
            [self.delegate requsetCancelOrderFailed:error];
        }
    }];
    
}
/**
 * 获取物流公司估价
 */

- (void)requsetInquiryQuotation:(NSString *)url orderID:(NSString *)orderID{
    
    
        NSString *urlBase = [NSString stringWithFormat:base_url];
        NSString *urlstr = [urlBase stringByAppendingString:url];
    
        [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"orderId":orderID} success:^(id responseObj) {
            if ([self.delegate respondsToSelector:@selector(requsetInquiryQuotationSuccess:)]) {
                [self.delegate requsetInquiryQuotationSuccess:responseObj];
            }
    
        } failure:^(NSError *error) {
    
            if ([self.delegate respondsToSelector:@selector(requsetInquiryQuotationFailed:)]) {
                [self.delegate requsetInquiryQuotationFailed:error];
            }
        }];
        
}


/**
 * 专线下单
 */

- (void)requsetCommitDedicatedOrder:(NSString *)url evlue:(NSDictionary *)evuleDic service:(NSString *)service addressStr:(NSDictionary *)start addressEnd:(NSDictionary *)endDic describeContent:(NSString *)describeContent photo:(NSString *)photo time:(NSString *)time timeType:(NSNumber *)timeType nowTime:(NSString *)timeNow{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    int isLieu = 0;
    int isInsure = 0;

    NSInteger PaymentNum = [[evuleDic objectForKey:@"PaymentNum"] integerValue];
    NSInteger evulteNum = [[evuleDic objectForKey:@"evulteNum"] integerValue];
    NSString *valueofGoods = [evuleDic objectForKey:@"evulteStr"];
    
    double insuranceA = [valueofGoods doubleValue] *0.004;
    NSString *insuranceAmount = [NSString stringWithFormat:@"%.1f",insuranceA];
    
    double lieuAmount = [[evuleDic objectForKey:@"money"] doubleValue];
    
    NSString *name = [evuleDic objectForKey:@"name"];
    NSString *amount = [evuleDic objectForKey:@"number"];
    NSString *packing = [evuleDic objectForKey:@"package"];
    NSString *cargoType = [evuleDic objectForKey:@"typeStr"];
    NSString *volume = [evuleDic objectForKey:@"volume"];
    NSString *weight = [evuleDic objectForKey:@"weight"];

    if (evulteNum == 2) {
        isInsure = 1;
    }else {
        isInsure = 0;
    }
    
    if (PaymentNum == 2) {
        isLieu = 1;
    }else {
        isLieu = 0;

    }
    
    NSString *originatingProvince = [start objectForKey:@"provinceID"];
    NSString *originatingCity = [start objectForKey:@"cityID"];
    NSString *originatingSite = [start objectForKey:@"startChoose"];
    
    NSString *destinationProvince = [endDic objectForKey:@"provinceID"];
    NSString *destinationCity = [endDic objectForKey:@"cityID"];
    NSString *destination = [endDic objectForKey:@"endChoose"];


    NSDictionary *jyCargoDetails = @{@"cargoType":cargoType,@"name":name,@"volume":volume,@"amount":amount,@"weight":weight,@"packing":packing};
    
    NSDictionary *dic = @{@"orderType":@"1",@"valueofGoods":valueofGoods,@"isInsure":@(isInsure),@"insuranceAmount":insuranceAmount,@"deliveryTime":time,@"orderTime":timeNow,@"isLieu":@(isLieu),@"lieuAmount":@(lieuAmount),@"originatingSite":originatingSite,@"destination":destination,@"originatingProvince":originatingProvince,@"originatingCity":originatingCity,@"destinationProvince":destinationProvince,@"destinationCity":destinationCity,@"serviceDetails":service,@"describeContent":describeContent,@"describePhoto":photo,@"creatString":userPhone,@"updateString":userPhone,@"timeType":timeType,@"jyCargoDetails":jyCargoDetails};
    
    NSString *str = [self dictionaryToJson:dic];

    
 
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"dedicatedOrder":str} success:^(id responseObj) {

        if ([self.delegate respondsToSelector:@selector(requestCommitDedicatedOrderSuccess:)]) {
            [self.delegate requestCommitDedicatedOrderSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requestCommitDedicatedOrderFailed:)]) {
            [self.delegate requestCommitDedicatedOrderFailed:error];
        }
    }];

    
}
/**
 * 确认价格。填写地址信息
 */

- (void)requsetConfirmationAddress:(NSString *)url orderInfo:(NSDictionary *)orderInfo phone:(NSString *)phone{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    NSString *orderSupplementary = [self dictionaryToJson:orderInfo];
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"orderSupplementary":orderSupplementary,@"phone":phone} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requsetConfirmationAddressSuccess:)]) {
            [self.delegate requsetConfirmationAddressSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requsetConfirmationAddressFailed:)]) {
            [self.delegate requsetConfirmationAddressFailed:error];
        }
    }];
    
}
/**
 * 香港下单的确认价格
 */

- (void)requsetGetHongkongPrice:(NSString *)url region:(NSString*)region volume:(NSString *)volume  weight:(NSString *)weight isDistribution:(NSString *)isDistribution isWarehousing:(NSString *)isWarehousing{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"region":region,@"volume":volume,@"weight":weight,@"isDistribution":isDistribution,@"isWarehousing":isWarehousing} success:^(id responseObj) {
        if ([self.delegate respondsToSelector:@selector(requsetGetHongkongPriceSuccess:)]) {
            [self.delegate requsetGetHongkongPriceSuccess:responseObj];
        }
        
    } failure:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(requsetGetHongkongPriceFailed:)]) {
            [self.delegate requsetGetHongkongPriceFailed:error];
        }
    }];
    
    
}
/**
 * 香港下单
 */

- (void)requsetCommitDedicatedOrderForHongkong:(NSString *)url  evlue:(NSDictionary *)evuleDic startPlace:(NSString *)startPlace endPlace:(NSString *)endPlace describeContent:(NSString *)describeContent photo:(NSString *)photo time:(NSString *)time timeType:(NSNumber *)timeType nowTime:(NSString *)timeNow evaluation:(NSString *)evaluation{
    
    NSString *urlBase = [NSString stringWithFormat:base_url];
    NSString *urlstr = [urlBase stringByAppendingString:url];
    
    int isLieu = 0;
    int isInsure = 0;
    
    NSInteger PaymentNum = [[evuleDic objectForKey:@"PaymentNum"] integerValue];
    NSInteger evulteNum = [[evuleDic objectForKey:@"evulteNum"] integerValue];
    NSString *valueofGoods = [evuleDic objectForKey:@"evulteStr"];
    
    double insuranceA = [valueofGoods doubleValue] *0.004;
    NSString *insuranceAmount = [NSString stringWithFormat:@"%.1f",insuranceA];
    
    double lieuAmount = [[evuleDic objectForKey:@"money"] doubleValue];
    
    NSString *name = [evuleDic objectForKey:@"name"];
    NSString *amount = [evuleDic objectForKey:@"number"];
    NSString *packing = [evuleDic objectForKey:@"package"];
    NSString *cargoType = [evuleDic objectForKey:@"typeStr"];
    NSString *volume = [evuleDic objectForKey:@"volume"];
    NSString *weight = [evuleDic objectForKey:@"weight"];
    
    if (evulteNum == 2) {
        isInsure = 1;
    }else {
        isInsure = 0;
    }
    
    if (PaymentNum == 2) {
        isLieu = 1;
    }else {
        isLieu = 0;
        
    }
    
    
    
    NSDictionary *jyCargoDetails = @{@"cargoType":cargoType,@"name":name,@"volume":volume,@"amount":amount,@"weight":weight,@"packing":packing};
    
    NSDictionary *dic = @{@"orderType":@"2",@"valueofGoods":valueofGoods,@"isInsure":@(isInsure),@"insuranceAmount":insuranceAmount,@"deliveryTime":time,@"orderTime":timeNow,@"isLieu":@(isLieu),@"lieuAmount":@(lieuAmount),@"originatingSite":startPlace,@"destination":endPlace,@"originatingProvince":@"",@"originatingCity":@"",@"destinationProvince":@"",@"destinationCity":@"",@"serviceDetails":@"",@"describeContent":describeContent,@"describePhoto":photo,@"creatString":userPhone,@"updateString":userPhone,@"timeType":timeType,@"jyCargoDetails":jyCargoDetails,@"evaluation":evaluation};
    
    NSString *str = [self dictionaryToJson:dic];
    
    
    
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"dedicatedOrder":str} success:^(id responseObj) {
        
  
    if ([self.delegate respondsToSelector:@selector(requsetHongkongOrderSuccess:)]) {
        [self.delegate requsetHongkongOrderSuccess:responseObj];
    }
    
} failure:^(NSError *error) {
    
    if ([self.delegate respondsToSelector:@selector(requsetHongkongOrderFailed:)]) {
        [self.delegate requsetHongkongOrderFailed:error];
    }
}];

    
}
//字典转json格式字符串：
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
