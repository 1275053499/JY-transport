//
//  balanceDetailModel.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface balanceDetailModel : NSObject
//id
@property(nonatomic,copy)NSString *amount;//交易金额
@property(nonatomic,copy)NSString *belongto;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *isNewRecord;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *payType;//支付方式俄国：支付宝
@property(nonatomic,copy)NSString *payer;//交易对象
@property(nonatomic,copy)NSString *quota;//原有余额
@property(nonatomic,copy)NSString *remarks;
@property(nonatomic,copy)NSString *settlement;//变动后余额
@property(nonatomic,copy)NSString *updateDate;


@end
