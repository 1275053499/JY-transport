//
//  MessageRequsetData.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/21.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageRequestDelegate.h"
@interface MessageRequsetData : NSObject

@property (nonatomic,strong)id <MessageRequestDelegate>delegate;


//获取评价列表
- (void)requestDataForMessageEvaluate:(NSString *)url evObject:(NSString *)evObject;


//收藏
- (void)requestDataCollection:(NSString *)url UserPhone:(NSString *)userphone DriverPhone:(NSString *)phone;


//获取司机评分
- (void)requestDataDriverEvaluate:(NSString *)url DriverPhone:(NSString *)phone;
@end
