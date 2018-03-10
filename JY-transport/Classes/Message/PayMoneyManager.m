//
//  PayMoneyManager.m
//  JY-transport-driver
//
//  Created by 闫振 on 2018/1/9.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "PayMoneyManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

@implementation PayMoneyManager

//支付宝
- (void)payMoneyAlipayHttp:(NSString *)money payType:(NSString *)payType{
    
    NSString *base = base_url;
    NSString *url = @"app/wallet/walletRecharge";
    NSString *urlStr = [base stringByAppendingString:url];
    NSString *phone = userPhone;
    
    
    [[NetWorkHelper shareInstance] Post:urlStr parameter:@{@"phone":phone,@"amount":money,@"payType":payType} success:^(id responseObj) {
        
        NSString *code = [responseObj objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            
            NSLog(@"=======%@",responseObj);
            
            NSString *alipayScheme = @"JY-transport";
            NSString *result = [responseObj objectForKey:@"result"];
            [[AlipaySDK defaultService] payOrder:result fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
                
                
            }];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}



//微信支付
- (void)payMoneyForWechat:(NSString *)money payType:(NSString *)payType{
    NSString *phone = userPhone;
    
    NSString *base = base_url;
    NSString *url = @"app/wallet/walletRecharge";
    NSString *urlStr = [base stringByAppendingString:url];
    
    if([WXApi isWXAppInstalled]) {
        
        [[NetWorkHelper shareInstance] Post:urlStr parameter:@{@"phone":phone,@"amount":money,@"payType":payType} success:^(id responseObj) {
            
            NSString *code = [responseObj objectForKey:@"code"];
            if ([code isEqualToString:@"200"]) {
                
                
                NSString *result = [responseObj objectForKey:@"result"];
                NSDictionary *payDic = [self dictionaryWithJsonString:result];
                
                PayReq *req  = [[PayReq alloc] init];
                req.partnerId = [payDic objectForKey:@"partnerid"];
                req.prepayId = [payDic objectForKey:@"prepayid"];
                req.package = [payDic objectForKey:@"package"];
                req.nonceStr = [payDic objectForKey:@"noncestr"];
                req.timeStamp = [[payDic objectForKey:@"timestamp"]intValue];
                req.sign = [payDic objectForKey:@"sign"];
                
                //调起微信支付
                if ([WXApi sendReq:req]) {
                    NSLog(@"吊起成功");
                }
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }
}
@end
