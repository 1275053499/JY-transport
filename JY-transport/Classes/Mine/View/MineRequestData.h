//
//  MineRequestData.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineRequestDataDelegate.h"
#import <CoreLocation/CoreLocation.h>
@interface MineRequestData : NSObject

@property (nonatomic,strong)id <MineRequestDataDelegate>delegate;

+ (id)shareInstance;

//把七牛云图片名称上传到服务器
- (void)requsetDataId:(NSString *)Id icon:(NSString *)icon;


/**
 *  获取余额
 *@para
 *@para
 *@para
 */
- (void)requestDataGetWalletForDriver:(NSString*)url phone:(NSString*)tel idea:(NSString *)idea;


//查看物流
- (void)requestGetTrackingByNumber:(NSString *)url transportNumber:(NSString *)transportNumber;

//查看附近的物流公司
- (void)requestNearbyLogistices:(NSString *)url location:(CLLocationCoordinate2D)location page:(NSInteger)page;

//搜索物流公司(省市区)
- (void)requestSearchLogistices:(NSString *)url province:(NSString *)province city:(NSString *)city district:(NSString *)district;


//获取收藏的物流公司
- (void)requestGetCollectionListForLogistices:(NSString *)url phone:(NSString *)phone;


//添加收藏物流公司
- (void)requestCollectionLogistices:(NSString *)url phone:(NSString *)phone logisticsId:(NSString *)logisticsId;

//取消收藏物流公司
- (void)requestCancelCollectionLogistices:(NSString *)url logisticsId:(NSString *)logisticsId;

//搜索物流公司（电话昵称）

- (void)requestSearchLogisticesWithPhone:(NSString *)url condition:(NSString *)condition;

@end
