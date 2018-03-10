//
//  ModelOfUserInfo.m
//  JY-transport
//
//  Created by 王政的电脑 on 17/4/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "ModelOfUserInfo.h"

@implementation ModelOfUserInfo
+ (instancetype)userWithDict:(NSDictionary *)dict;
{
    return [[self alloc] initContentWithDict:dict];
}

- (instancetype)initContentWithDict:(NSDictionary *)dict;
{
    if (self = [super init]) {
        
    }
    return self;
}


/**
 *  从文件中解析对象的时候调
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    
}
@end
