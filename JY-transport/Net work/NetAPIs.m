//
//  NetAPIs.m
//  IntelligentAssistent
//
//  Created by xylt on 16/5/6.
//  Copyright © 2016年 Qingyi.H. All rights reserved.
//

#import "NetAPIs.h"
#import "NetWorkHelper.h"

@implementation NetAPIs

+ (void)PosWithURL:(NSString *)url
                 parameter:(NSDictionary *)parameter
                   success:(void (^)(NSArray *result))success
                   faliure:(void (^)(NSError *error))failure
{
    
    [[NetWorkHelper shareInstance]Post:url parameter:parameter success:^(id responseObj) {
        
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
    
}

@end
