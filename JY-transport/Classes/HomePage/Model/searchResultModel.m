//
//  searchResultModel.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/31.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "searchResultModel.h"



@implementation searchResultModel



-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.longitude] forKey:@"longitude"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.latitude] forKey:@"latitude"];
    
}
-(instancetype)initWithCoder:(NSCoder* )aDecoder
{
    if (self == [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
         self.address = [aDecoder decodeObjectForKey:@"address"];
        NSNumber *number = [aDecoder decodeObjectForKey:@"latitude"];
        self.latitude = number.doubleValue;
        NSNumber *num = [aDecoder decodeObjectForKey:@"longitude"];
        self.longitude = num.doubleValue;
        
    }
    return self;
}

@end
