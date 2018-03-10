//
//  TMLocationManager.m
//  JY-transport

//  Created by 闫振 on 2018/2/1.
//  Copyright © 2018年 永和丽科技. All rights reserved.

#import "TMLocationManager.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface TMLocationManager ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic,strong)BMKLocationService *locService;

@property (nonatomic,strong)BMKGeoCodeSearch *geoCodeSearch;


@end
@implementation TMLocationManager

- (instancetype)init{
    if (self = [super init]) {

       
        [self initializeLocation];
        
    }
    
    return self;
    
}

+ (instancetype)sharelocationManager{
    
    TMLocationManager *manager = [[TMLocationManager alloc] init];

    return manager;
}
- (void)initializeLocation{
    
    [self checkCLAuthorizationStatus];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //    _locService.distanceFilter = 10;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    //    _locService.pausesLocationUpdatesAutomatically = YES;
    //    _locService.allowsBackgroundLocationUpdates = YES;
    //启动LocationService
    [_locService startUserLocationService];
    
}
- (BOOL)checkCLAuthorizationStatus{
    
    if ([CLLocationManager locationServicesEnabled] == NO){
        NSLog(@"你目前有这个设备的所有位置服务禁用");
        return NO;
    }else{
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            NSLog(@"请开启定位服务");
            return NO;
        }
        return YES;
    }
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
   
    [self.locService stopUserLocationService];
    
    self.locService.delegate = nil;
    CLLocationCoordinate2D center = userLocation.location.coordinate;

    [self sendGeoCodeSearch:center];
    
}

- (void)sendGeoCodeSearch:(CLLocationCoordinate2D )location{
    
    BMKGeoCodeSearch *geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    geoCodeSearch.delegate = self;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = location;
    BOOL flag = [geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
        
    }
    else{
        NSLog(@"反geo检索发送失败");
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    
    if (error == BMK_SEARCH_NO_ERROR) {
       NSString *city = result.addressDetail.city;
        if ([city isEqual:[NSNull null]] || city == nil || city.length <= 0) {
            city = @"始发地";
        }
        if (_tmLocationBlock) {
            _tmLocationBlock(city);
            self.geoCodeSearch.delegate = nil;

        }

    }
}

- (void)dealloc{
    
}
- (void)startLoaction{
    
    if ([self checkCLAuthorizationStatus] == NO) {
        return;
    }
   
}
- (void)stopLoaction{
    
   
}
@end
