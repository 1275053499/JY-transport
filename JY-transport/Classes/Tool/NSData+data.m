//
//  NSData+data.m
//  JY-transport
//
//  Created by 闫振 on 2017/12/11.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "NSData+data.h"

@implementation NSData (data)
// 压缩图片
+(NSData *)imageData:(UIImage *)myimage{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024){//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return data;
}
@end
