//
//  EvaluateModel.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/22.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
@interface EvaluateModel : NSObject


@property (nonatomic,strong)NSString *createBy;
@property (nonatomic,strong)NSString *createDate;
@property (nonatomic,strong)NSString *evComment;
@property (nonatomic,strong)NSString *evGrade;
@property (nonatomic,strong)NSString *evPotin;
@property (nonatomic,strong)NSString *orderNo;
@property (nonatomic,strong)NSString *remark;
@property (nonatomic,strong)NSString *updateBy;
@property (nonatomic,strong)NSString *updateDate;
@property (nonatomic,strong)NSString *delFlag;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)UserInfoModel *jyUserinfo;
@end
