//
//  JYALAssetsLibrary.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/13.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYALAssetsLibrary.h"

@implementation JYALAssetsLibrary

+ (JYALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static JYALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[JYALAssetsLibrary alloc] init];
    });
    return library;
}
@end
