//
//  MessageRequestDelegate.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/21.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MessageRequestDelegate <NSObject>
@optional
//获取评价列表
- (void)requestDataForEvaluteSuccess:(id )resultDic;

- (void)requestDataForEvaluteFailed:(NSError *)error;


//收藏
- (void)requestDataForCollectionSuccess:(NSDictionary *)resultDic;

- (void)requestDataForCollectionFailed:(NSError *)error;


//  获取司机评分
- (void)requestDataForDriverEvaluateSuccess:(NSDictionary *)resultDic;

- (void)requestDataForDriverEvaluateFailed:(NSError *)error;
@end
