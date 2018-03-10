//
//  AFAppDotNetAPIClient.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager.h"

@interface AFAppDotNetAPIClient : AFHTTPSessionManager

+(AFHTTPSessionManager *)sharedClient;
@end
