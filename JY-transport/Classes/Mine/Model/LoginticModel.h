//
//  LoginticModel.h
//  JY-transport
//
//  Created by 闫振 on 2017/11/16.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYCompanyModel.h"
@interface LoginticModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *basicStatus;
@property (nonatomic,strong)NSString *logisticsId;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)JYCompanyModel *group;
@end
