//
//  CarTeamMode.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/11.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DriverInfoMode;
@interface CarTeamMode : NSObject
//纬度
@property (nonatomic,strong) NSString *latitude;
//经度
@property (nonatomic,strong) NSString *longitude;
//车队信息
@property (nonatomic,strong) DriverInfoMode *truckGoup;
@property (nonatomic,strong) NSString *avgGrade;
@property (nonatomic,strong) NSString *avgPotin;
@property (nonatomic,strong) NSString *countServce;
@property (nonatomic,strong) NSString *createDate;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,assign) BOOL isNewRecord;
@property (nonatomic,strong) NSString *logDate;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *remarks;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *name;


@end
