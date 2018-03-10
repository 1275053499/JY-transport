//
//  JYOrderAddressModel.h
//  JY-transport
//
//  Created by 闫振 on 2017/9/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYOrderAddressModel : NSObject
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *recipientsAddress;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *recipientsName;
@property (nonatomic,strong)NSString *recipientsPhone;
@property (nonatomic,strong)NSString *senderAddress;
@property (nonatomic,strong)NSString *senderName;
@property (nonatomic,strong)NSString *senderPhone;

@end
