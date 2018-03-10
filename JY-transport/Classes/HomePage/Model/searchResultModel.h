//
//  searchResultModel.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/31.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface searchResultModel : NSObject<NSCoding>

@property (nonatomic,assign)CLLocationDegrees latitude;
@property (nonatomic,assign)CLLocationDegrees longitude;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *city;
@end
