//
//  ModelOfUserInfo.h
//  JY-transport
//
//  Created by 王政的电脑 on 17/4/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelOfUserInfo : NSObject<NSCoding>
+ (instancetype)userWithDict:(NSDictionary *)dict;
- (instancetype)initContentWithDict:(NSDictionary *)dict;
@end
