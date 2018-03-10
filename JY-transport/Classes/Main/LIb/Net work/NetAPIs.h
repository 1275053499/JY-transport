//
//  NetAPIs.h
//  IntelligentAssistent
//
//  Created by xylt on 16/5/6.
//  Copyright © 2016年 Qingyi.H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlInterfaces.h"

@interface NetAPIs : NSObject

+ (void)PosWithURL:(NSString *)url
                 parameter:(NSDictionary *)parameter
                   success:(void (^)(NSArray *result))success
                   faliure:(void (^)(NSError *error))failure;

@end
