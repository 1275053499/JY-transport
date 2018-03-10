//
//  lookForDriverMapController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/3.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "lookForDriverMapController.h"
//#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>
#import "XGAnnotation.h"
#import "XGAnnotationView.h"
#import "OrderAlertView.h"
#import "locationDriverModel.h"
#import "LookForCarViewController.h"
#import "MapSureAlertView.h"
#import "timeAlertView.h"
#import "orderDetailViewController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Base/BMKTypes.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "payViewController.h"
#import "MessageViewController.h"

#import "OrderMapAddressTableViewCell.h"
#import "LookEvaluateViewController.h"
#import "WaitingForLoadView.h"
#define MINIMUM_ZOOM_ARC 0.004 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.85
#define MAX_DEGREES_ARC 360
@interface lookForDriverMapController ()<BMKMapViewDelegate,OrderAlertViewDelegate,CLLocationManagerDelegate,BMKLocationServiceDelegate>
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (nonatomic, weak) UIButton *centerButton;
@property(nonatomic,weak)UIButton *zoomin;
@property(nonatomic,weak)UIButton *zoomout;
@property(nonatomic,weak)XGAnnotation *lastAnnotation;
@property (nonatomic,strong)NSString *distanceStr;


@property(nonatomic,strong)NSMutableArray *arrivePlaceLatitudeArray;
@property(nonatomic,strong)NSMutableArray *arrivePlaceLongitudeArray;
@property(nonatomic,strong)NSMutableArray *arrivePlaceAddressArray;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,strong)timeAlertView *alertView;

@property (nonatomic,assign)BOOL isFirstloadAlert;
@property (nonatomic,assign)BOOL isService;
@property (nonatomic,strong)NSTimer *timerLook;
@property (nonatomic,strong)MapSureAlertView *alertViewDriver;//确定司机服务时  弹出司机评分

@property (nonatomic,assign)BOOL isFirstLoadDriverLocation; //是否第一次掉用定位司机位置方法
@property (nonatomic,assign)BOOL isFirstLoadDriverAlertView; //是否第一次掉用加载司机评分时图
@property (nonatomic,assign)BOOL isfirstPresentPayMoney;//是否第一次弹出去支付页面

@property (nonatomic,strong)BMKLocationService *locService;
@property (nonatomic,strong)NSArray *annations;//保存司机和起点的大头针
@property (nonatomic,strong)NSMutableSet *annationsSet;
@property (nonatomic,assign)BOOL isFirstService;//服务中是否第一次缩放地图
@property (nonatomic,assign)BOOL isFirstWait;//等待装货是否第一次缩放地图
@property (nonatomic,strong)BMKUserLocation *userLocation;
@property (nonatomic,strong)NSTimer *driverLocationTimer;

@end

@implementation lookForDriverMapController
{
    BMKMapView                          *_map;
    CLLocationManager              *_manager;
    UISegmentedControl             *_segment;
    UIButton                       *_backBtn;
    UIButton                     *_aerialBtn;
    NSMutableArray         *_polyLineMutable;
    NSMutableArray            *_routeDetails;
    
}
- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirstloadAlert =  NO;
    _isFirstLoadDriverLocation = NO;
    _isFirstLoadDriverAlertView = NO;
    _isfirstPresentPayMoney = NO;
    _isService = NO;
    
    _isFirstService = NO;
    _isFirstWait = NO;
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(back)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"寻找司机";

    if ([self.model.basicStatus isEqualToString:@"1"] || [self.model.basicStatus isEqualToString:@"2"]|| [self.model.basicStatus isEqualToString:@"7"]|| [self.model.basicStatus isEqualToString:@"8"]) {
        [self updateDriverLocation];
    }
    if ([self.model.basicStatus isEqualToString:@"1"]) {
        
        self.navigationItem.title = @"等待装货";

    }else if ([self.model.basicStatus isEqualToString:@"2"]){
        self.navigationItem.title = @"运输中";
    }
    // 添加地图
    [self addMapView];
    // 设置地图的缩放模式
    [self addMapScale];
    // 设置返回按钮
    [self addBackBtn];
    // 设置航拍模式
    [self addAerialBtn];
    [self getOrderDetailData];

    _annations = [NSArray array];
    _annationsSet = [NSMutableSet set];
   // [self addStartAndEndAnnotation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeg:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationdidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderDetailData) name:@"getDrivers" object:nil];//司机抢单  需要刷新订单状态
    
}

- (void)creatTopAddressView{
    
    
    OrderMapAddressTableViewCell *addressView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderMapAddressTableViewCell class]) owner:nil options:0][0];
    addressView.backgroundColor = [UIColor whiteColor];
    addressView.frame = CGRectMake(0, 0, ScreenWidth, 109);
    addressView.model = self.model;
    [self.view addSubview:addressView];
}
//进入前台
- (void)applicationWillEnterForeg:(NSNotification *)nottfication{
    
    //开启定时器
    [self performSelector:@selector(addTimer) withObject:nil afterDelay:0.1];
}

//退到后台
- (void)applicationdidEnterBackground:(NSNotification *)nottfication{
    //关闭定时器
    [self.timerLook invalidate];
    self.timerLook = nil;
    
}
//添加开始和结束两个按钮
-(void)addStartAndEndAnnotationstarLat:(NSString*)lat startLng:(NSString *)lng{
   
    XGAnnotation  *startAnnotation = [[XGAnnotation alloc] init];
    CLLocationCoordinate2D startAnnotationcoor =  CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
    startAnnotation.coordinate = startAnnotationcoor;
    startAnnotation.title = @"起点";
    startAnnotation.subtitle = self.model.city;
    startAnnotation.icon = @"start";
    [_annationsSet addObject:startAnnotation];
    [_map addAnnotation:startAnnotation];
    XGAnnotation *endAnnotation = [[XGAnnotation alloc] init];
    
    NSString *endLat = [self.arrivePlaceLatitudeArray lastObject];
    NSString *endLong = [self.arrivePlaceLongitudeArray lastObject];
    CLLocationCoordinate2D coor =  CLLocationCoordinate2DMake([endLat doubleValue], [endLong doubleValue]);
    endAnnotation.coordinate = coor;
    endAnnotation.title = @"终点";
    endAnnotation.icon = @"end";
    endAnnotation.subtitle = self.arrivePlaceAddressArray.lastObject;
    [_map addAnnotation:endAnnotation];
    //    [annotationArr addObject:startAnnotation];
    //    [annotationArr addObject:endAnnotation];
    //    [_map showAnnotations:annotationArr animated:YES];
    NSLog(@"%f%f======111%f,%f",startAnnotationcoor.latitude,startAnnotationcoor.longitude,coor.latitude,coor.longitude);
    
    if (self.arrivePlaceAddressArray.count>1) {
        
        for (int i = 0; i < self.arrivePlaceAddressArray.count-1; i ++) {
            
            XGAnnotation *centerAnnotation = [[XGAnnotation alloc] init];
            centerAnnotation.title = @"临时装货点";
            centerAnnotation.icon = [NSString  stringWithFormat:@"linshi%d",i+1];
            centerAnnotation.subtitle = self.arrivePlaceAddressArray[i];
            centerAnnotation.coordinate = CLLocationCoordinate2DMake([self.arrivePlaceLatitudeArray[i] doubleValue], [self.arrivePlaceLongitudeArray[i] doubleValue]);
            [_map addAnnotation:centerAnnotation];

        }
        //
    }
    
}
- (void)back
{
    [_map removeFromSuperview];
    _map.delegate = nil;
    _locService.delegate = nil;
    _map = nil;
    [_driverLocationTimer invalidate];
    _driverLocationTimer = nil;
    NSArray*arrController =self.navigationController.viewControllers;
    NSInteger VcCount = arrController.count;
    UIViewController *lastVC = arrController[VcCount - 2];
    if ([lastVC isKindOfClass:[LookForCarViewController class]]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    }
}

//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    //开启定时器
 [self performSelector:@selector(addTimer) withObject:nil afterDelay:0.5];
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    [self.timerLook invalidate];
    _timerLook = nil;
    _isFirstWait = NO;
}

// 添加一个定时器5秒一次检测是否有人接单了
-(void)addTimer
{
    if (_timerLook) {
        return;
    }
    _timerLook = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(getOrderDetailData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerLook forMode:NSRunLoopCommonModes];

}
- (void)getLocationsLatitudeAndLongtitude:(OrderModel *)mode{
    
    //地理位置数组
    self.arrivePlaceAddressArray = [NSMutableArray array];
    NSArray *arr= [mode.district componentsSeparatedByString:@","];
    [self.arrivePlaceAddressArray addObjectsFromArray:arr];
    [self.arrivePlaceAddressArray removeLastObject];
    
    
    // 地理坐标数组
    
    self.arrivePlaceLatitudeArray = [NSMutableArray array];
    NSArray *endLatitude= [mode.endLatitude componentsSeparatedByString:@","];
    [self.arrivePlaceLatitudeArray addObjectsFromArray:endLatitude];
    [self.arrivePlaceLatitudeArray removeLastObject];
    
    
    self.arrivePlaceLongitudeArray = [NSMutableArray array];
    NSArray *endLongtitude= [mode.endLongitude componentsSeparatedByString:@","];
    [self.arrivePlaceLongitudeArray addObjectsFromArray:endLongtitude];
    [self.arrivePlaceLongitudeArray removeLastObject];

}

-(void)getOrderDetailData
{
   
    NSLog(@"lookfordrivwe 定时器掉用");
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/getReqDetailByOrderNo"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"orderNo": self.orderNunber,@"phone":userPhone} success:^(id responseObj) {
        
        OrderModel *model = [OrderModel mj_objectWithKeyValues:responseObj];
        self.model = model;

        [self getLocationsLatitudeAndLongtitude:model];
        
        if ([model.basicStatus isEqualToString:@"6"]) {
            
//           [timer setFireDate:[NSDate distantFuture]];
//             [_alertViewDriver removeFromSuperview];
//            _alertViewDriver = [[OrderAlertView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)withGroupNumber:10];
//            _alertViewDriver.delegate = self;
//            _alertViewDriver.model = model;
//            _alertViewDriver.backgroundColor = [UIColor clearColor];
            
            if (_isFirstLoadDriverAlertView !=YES) {
                if (_alertViewDriver) {
                    return ;
                }
                _alertViewDriver= [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MapSureAlertView class]) owner:self options:nil][0];
                _alertViewDriver.orderMode = model;
                [_alertViewDriver showSureAlertView];
                [_alertViewDriver.scoreSureButton addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_alertViewDriver.scoreCancelBtn addTarget:self action:@selector(cancelbtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_alertViewDriver.phoneBtn addTarget:self action:@selector(callDriverPhone:) forControlEvents:(UIControlEventTouchUpInside)];
                [_alertViewDriver.lookEvaluate addTarget:self action:@selector(lookEvaluateClick:) forControlEvents:(UIControlEventTouchUpInside)];

                [self.view addSubview:_alertViewDriver];
                _isFirstLoadDriverAlertView = YES;
            }
           
            
  
        }else if ([model.basicStatus isEqualToString:@"0"]){
            if (_isFirstloadAlert == YES) {

                return ;
            }

            self.navigationItem.title = @"寻找司机";
            [self creatTopAddressView];
            _alertView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([timeAlertView class]) owner:self options:nil][0];
            _alertView.frame = CGRectMake((ScreenWidth-200)/2, (ScreenHeight-64)/2-64, 200, 87);
            _alertView.distanceNum.hidden =YES;
            [_alertView setAnationView];
            [_map addSubview: _alertView];
            _isFirstloadAlert = YES;
            
            
            
        }else if ([model.basicStatus isEqualToString:@"1"]){
            _isService = YES;
        self.navigationItem.title = @"等待装货";
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.label.numberOfLines = 2;
//            hud.mode = MBProgressHUDModeText;
//            hud.label.textColor = [UIColor whiteColor];
//            hud.label.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
//            hud.label.text= @"司机已到达起点\n请尽快安排装货";
//            [hud hideAnimated:YES afterDelay:3];
            
            [self creatTopAddressView];

            [self startLocationDriver];

             [self addStartAndEndAnnotationstarLat:self.model.latitude startLng:self.model.longitude];
            
        }else if ([model.basicStatus isEqualToString:@"2"]){
            [self addStartAndEndAnnotationstarLat:self.model.latitude startLng:self.model.longitude];
            [_alertView removeFromSuperview];
            _isService = NO;
            self.navigationItem.title =@"运输中";
            [self creatTopAddressView];

            [self startLocationDriver];
            
        }else if ([model.basicStatus isEqualToString:@"3"]){
            [_alertView removeFromSuperview];
            _isService = NO;
            self.navigationItem.title = @"服务结束";
//            orderDetailViewController *vc = [[orderDetailViewController alloc] init];
//            [self.navigationController  popViewControllerAnimated:YES];
            if (_isfirstPresentPayMoney == NO) {
                 [self presentPayMoney];
                _isfirstPresentPayMoney = YES;
            }
           
            
        }else if ([model.basicStatus isEqualToString:@"4"] || [self.model.basicStatus isEqualToString:@"9"] ){
//            [_alertView removeFromSuperview];
//            self.navigationItem.title = @"服务结束";
//            [self.navigationController  popViewControllerAnimated:YES];
        }else if ([model.basicStatus isEqualToString:@"7"]){
            self.navigationItem.title = @"装货中";
            //只执行一次的代码
            WaitingForLoadView *view = [[WaitingForLoadView alloc] initWithFrame:CGRectMake((ScreenWidth -200)/2, (ScreenHeight -StateBarHeight -NavigationBarHeight - 120)/2, 200, 120 + 60)];
            
            [self.view addSubview:view];
            
            [self creatTopAddressView];
            
            [self startLocationDriver];
            
            [self addStartAndEndAnnotationstarLat:self.model.latitude startLng:self.model.longitude];
        }else if ([model.basicStatus isEqualToString:@"8"]){
            
            self.navigationItem.title = @"卸货中";
            [self creatTopAddressView];
            [self startLocationDriver];
            
            [self addStartAndEndAnnotationstarLat:self.model.latitude startLng:self.model.longitude];
        }else{
        //定时器不断得到司机的位置
            
//        [self startLocationDriver];
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
    
  
}
- (void)lookEvaluateClick:(UIButton *)btn{
    DriverInfoMode *drModel = self.model.jyTruckergroup;

    LookEvaluateViewController *evaluateVC = [[LookEvaluateViewController alloc] init];
    evaluateVC.driverPhone = drModel.phone;
    [self.navigationController pushViewController:evaluateVC animated:YES];

    
}
- (void)presentPayMoney{
    
    
    NSString *message = NSLocalizedString(@"服务结束，现在去支付吗？", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
         [self.navigationController popToRootViewControllerAnimated:YES];
        NSLog(@"取消");
    }];
 
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
       

        
        payViewController *vc = [[payViewController alloc] init];
        vc.model  = self.model;
        vc.pushFromWhichVC = @"UIAlertController";
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)cancelbtnClick:(UIButton *)sender {
    
   
    _isFirstLoadDriverAlertView = NO;
    NSString *baseStr = base_url;
    
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/cancelConfirmrToUser"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"orderNo": self.orderNunber,@"phone":userPhone} success:^(id responseObj) {
        
        
        if ([[responseObj objectForKey:@"message"] isEqualToString:@"0"]) {
            
            [_alertViewDriver removeFromSuperview];
        }else{
           
            [MBProgressHUD showError:@"取消失败，请从新开始"];
        }
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络异常"];
    }];
    
    
}

- (void)callDriverPhone:(UIButton *)sender {
    
    DriverInfoMode *drModel = self.model.jyTruckergroup;
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", drModel.phone];
    if (IOS_VERSION >= 10.0) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        
    } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
    
}

- (void)sureBtnClick:(UIButton *)sender {
  
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/chartered/changeReq"];
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"orderNo":self.orderNunber,@"status":@"1"} success:^(id responseObj) {
        
     
        if ([[NSString stringWithFormat:@"%d",[responseObj intValue]] isEqualToString:@"0"]) {
            self.navigationItem.title = @"等待装货";
            [self creatTopAddressView];

              [self addStartAndEndAnnotationstarLat:self.model.latitude startLng:self.model.longitude];

             [_alertViewDriver removeFromSuperview];
            [_alertView removeFromSuperview];
          [self startLocationDriver];
        }else{
            
            [MBProgressHUD showError:@"失败，请从新开始"];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络异常"];
    }];
    
}
-(void)ButtonDidCilckedWithCancleOrConfirm:(NSString *)states
{
    
    if ([states isEqualToString:@"cancle"]) {
        //点击取消按钮

        
    }
    if ([states isEqualToString:@"OK"]) {
        
    }
 }

-(double)distanceBetweenOrderBy:(double) lat1 lat:(double) lat2 lat:(double) lng1 lat:(double) lng2{
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    return  distance;
    
}
- (void)updateDriverLocation{
    
    _driverLocationTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(startLocationDriver) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_driverLocationTimer forMode:NSRunLoopCommonModes];

   
}
//开始定位司机
-(void)startLocationDriver
{
    
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/coordinates/getNew"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":self.model.jyTruckergroup.phone} success:^(id responseObj) {
        
        [_map removeAnnotation:_lastAnnotation];
//        [_map removeAnnotations:_map.annotations];
       locationDriverModel *model = [locationDriverModel mj_objectWithKeyValues:responseObj];
        double longIt = model.longitude.doubleValue;
        double latitu = model.latitude.doubleValue;
        double latStra = [self.model.latitude doubleValue];
        double lonEnd = [self.model.longitude doubleValue];

        double distance = [self distanceBetweenOrderBy:latStra lat:latitu lat:lonEnd lat:longIt];
    
        NSString *str = [NSString stringWithFormat:@"距离司机%.2fkm",distance/1000];
        _distanceStr = str;
        NSLog(@"qqqqqqqqpppppppmmmmmmm%@",str);
        XGAnnotation *startAnnotation = [[XGAnnotation alloc] init];
        CLLocationCoordinate2D startAnnotationcoor =  CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
        startAnnotation.coordinate = startAnnotationcoor;
//        startAnnotation.subtitle = self.model.city;
        startAnnotation.icon = @"center_car";
        startAnnotation.title = @"司机位置";
        self.lastAnnotation = startAnnotation;
        [_annationsSet addObject:self.lastAnnotation];
        [_map addAnnotation:self.lastAnnotation];
        if (_isFirstWait != YES) {
            [self zoomMapViewToFitAnnotations:_map animated:YES];
        }
//        if (_isFirstService != YES) {
//            [self zoomMapViewToFitAnnotations:_map animated:YES];
//            
//        }

        if (_isService == YES) {
            
            if (_isFirstLoadDriverLocation != YES) {
                _alertView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([timeAlertView class]) owner:self options:nil][0];
                _alertView.frame = CGRectMake((ScreenWidth-200)/2, (ScreenHeight-64)/2-64, 200, 87);
//                _alertView.calloutView.backgroundColor = RGBA(43, 43, 43, 0.6);
                _alertView.timeNum.hidden =YES;
                _alertView.driverNum.hidden =YES;
                [_map addSubview:_alertView];
                _isFirstLoadDriverLocation = YES;
            }
            _alertView.distanceNum.text = _distanceStr;

            
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
    

}


#pragma mark - 添加航拍按钮_backBtn
-(void)addAerialBtn{
    UIButton *aerialBtn = [[UIButton alloc] initWithFrame:CGRectMake(_backBtn.frame.origin.x, _backBtn.frame.origin.y - 35, 30, 30)];
    aerialBtn.backgroundColor = [UIColor clearColor];
    [aerialBtn setImage:[UIImage imageNamed:@"aerial"] forState:UIControlStateNormal];
    
    [aerialBtn addTarget:self action:@selector(addAerialModel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aerialBtn];
    _aerialBtn = aerialBtn;
}

#pragma mark - 设置地图的航拍模式
-(void)addAerialModel{
    
// 设置航拍模式
//    _map.camera = [MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(39.9, 116.4) fromDistance:100 pitch:90 heading:0];
    _map.userTrackingMode = BMKUserTrackingModeFollow;
}
#pragma mark - 添加地图
-(void)addMapView{
    
    BMKMapView *map = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    _map = map;
      [_map setLogoPosition:BMKLogoPositionRightBottom];
      [self.view addSubview:map];
    // 在地图上显示定位
    // 1、请求授权(在Info.plist中添加NSLocationWhenInUseUsageDescription）
//    _manager = [[CLLocationManager alloc] init];
//    [_manager requestWhenInUseAuthorization];
    
    // 2.设置地图的用户跟踪模式
    map.userTrackingMode = BMKUserTrackingModeFollow;
    map.delegate = self;
    
    // 其他的新属性
    // 显示指南针
//    _map.showsCompass = YES;
    // 显示感兴趣的点，默认是显示的
//    _map.showsPointsOfInterest = YES;
    // 显示标尺(单位：mi 英尺)
//    _map.showsScale = YES;
    // 显示交通情况
//    _map.showsTraffic = YES;
    // 显示定位大头针，默认是显示的
    _map.showsUserLocation = YES;
    // 显示建筑物的3D模型，设置3D/沙盘/航拍模式(高德地图不支持)
//    _map.showsBuildings = YES;

//    [self putMapAnimation];
    
    _locationManager = [[CLLocationManager alloc] init];
//    [_locationManager requestAlwaysAuthorization];
//    _locationManager.delegate = self;
//    // 设置定位精确度到米
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.distanceFilter = 10;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    [_locService startUserLocationService];
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{

    CLLocation * location = userLocation.location;
    _userLocation =  userLocation;
        // 取出用户当前的经纬度
        CLLocationCoordinate2D center = userLocation.location.coordinate;
        
        // 设置地图的中心点（以用户所在的位置为中心点）
        [_map setCenterCoordinate:userLocation.location.coordinate animated:YES];
        
        BMKCoordinateRegion region;
        region.center.longitude = center.longitude;
        region.center.latitude = center.latitude;
        region.span.latitudeDelta = 0.005;
        region.span.longitudeDelta = 0.005;
        [_map updateLocationData:userLocation];
        [_map setRegion:region animated:YES];
        NSLog(@"===================%f",userLocation.location.coordinate.latitude);
      [_locService stopUserLocationService];

}

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//
//    CLLocation * location = locations.lastObject;
//     _locationUser = location;
//    
//  
//}
- (void)dealloc{
   
    NSLog(@"来了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)zoomMapViewToFitAnnotations:(BMKMapView *)mapView animated:(BOOL)animated
{
    _isFirstService = YES;
    _isFirstWait = YES;
    NSArray *annotations;
    if ([self.navigationItem.title isEqualToString:@"等待装货"]) {
         annotations = [_annationsSet allObjects];
    }else{
         annotations = mapView.annotations;
    }
   
    int count = (int)[annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    BMKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = BMKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    BMKMapRect mapRect = [[BMKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    BMKCoordinateRegion region =  BMKCoordinateRegionForMapRect(mapRect);

         //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

#pragma mark - MKMapViewDelegate
//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    
//    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (placemarks.count == 0 || error) {
//            return ;
//        }
//        CLPlacemark *pm = placemarks.lastObject;
//        _map.userLocation.title = [NSString stringWithFormat:@"%@-%@-%@",pm.administrativeArea,pm.locality,pm.subLocality];
//        _map.userLocation.subtitle = pm.name;
        
       
//    }];

    
//}
//-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
//{
//    if ([self.model.basicStatus isEqualToString:@"1"]) {
//        MKAnnotationView *ulv = [mapView viewForAnnotation:mapView.userLocation];
//        ulv.hidden = YES;
//    }
   
//}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    NSLog(@"%@－－－－－－",[annotation class]);
    if (![annotation isKindOfClass:[XGAnnotation class]]) return nil;
    
    static NSString *ID = @"tuangou";
    // 从缓存池中取出可以循环利用的大头针view
    BMKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        // 显示子标题和标题
        annoView.canShowCallout = YES;
        // 设置大头针描述的偏移量
        annoView.calloutOffset = CGPointMake(0, -10);
        
        // 设置大头针描述左边的控件
        annoView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    // 传递模型
    annoView.annotation = annotation;
    // 设置图片
    XGAnnotation *tuangouAnno = annotation;
    annoView.image = [UIImage imageNamed:tuangouAnno.icon];
    return annoView;

    
}
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{

//    NSLog(@"-------===========-%@",self.model.basicStatus);
//    NSLog(@"%@",[annotation class]);
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        
//        
////        if ([self.model.basicStatus isEqualToString:@"0 "]) {
//        
//        
//            NSLog(@"---------------------%@",self.model.basicStatus);
//            
//          XGAnnotationView  *annoVie = [[XGAnnotationView alloc] init];
//            annoVie.calloutOffset = CGPointMake(0, -10);
//             [annoVie setAnationView];
//            [annoVie setSelected:YES animated:NO];
//            // 设置为NO，用以调用自定义的calloutView;
//            annoVie.image = [UIImage imageNamed:@"end"];
//            return annoVie;
//            
////        }
//    }else{
//        static NSString *ID = @"tuangou";
//        // 从缓存池中取出可以循环利用的大头针view
//        XGAnnotationView *annoView =(XGAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
//        if (annoView == nil) {
//            annoView = [[XGAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
//        }
//            // 显示子标题和标题
//            annoView.canShowCallout = YES;
//            
//            // 设置大头针描述的偏移量
//            annoView.calloutOffset = CGPointMake(0, -10);
//            // 设置大头针描述左边的控件
//            annoView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            // 传递模型
//           
//            // 设置图片
//            XGAnnotation *tuangouAnno = annotation;
//            annoView.image = [UIImage imageNamed:tuangouAnno.icon];
//            annoView.annotation = annotation;
//        
//        if ([self.model.basicStatus isEqualToString:@"1"]) {
//            NSLog(@"---------------------%@",self.model.basicStatus);
//            annoView.calloutOffset = CGPointMake(0, -10);
//            annoView.timeOrDistance = @"distance";
//            annoView.distanceStr  = _distanceStr;
//            [annoView setAnationView];
//            [annoView setSelected:YES animated:NO];
//            
//        }
//        
//        return annoView;
//
//        
//    }
//    return nil;
   
//    //MKUserLocation和MKPointAnnotatin都遵循标注协议，可以作为地图标注
//     NSLog(@"%@－－－－－－",[annotation class]);
//    if (![annotation isKindOfClass:[XGAnnotation class]]) return nil;
//    
//    static NSString *ID = @"tuangou";
//    // 从缓存池中取出可以循环利用的大头针view
//    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
//    if (annoView == nil) {
//        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
//        // 显示子标题和标题
//        annoView.canShowCallout = YES;
//        // 设置大头针描述的偏移量
//        annoView.calloutOffset = CGPointMake(0, -10);
//        
//        // 设置大头针描述左边的控件
//        annoView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    }
//    
//    // 传递模型
//    annoView.annotation = annotation;
//    // 设置图片
//    XGAnnotation *tuangouAnno = annotation;
//    annoView.image = [UIImage imageNamed:tuangouAnno.icon];
//    return annoView;

//}
#pragma mark - action handle
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 设置返回按钮
-(void)addBackBtn{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, ScreenHeight- 120, 30, 30)];
    backBtn.backgroundColor = [UIColor clearColor];
    //    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    //    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [backBtn setImage:[UIImage imageNamed:@"current_location"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    _backBtn = backBtn;
}
#pragma mark - 返回按钮的响应事件
-(void)clickBackBtn{
    CLLocationCoordinate2D coordinate = _userLocation.location.coordinate;
    // 设置跨度 = 当前地图的跨度
    BMKCoordinateSpan spn = _map.region.span;
    [_map setRegion:BMKCoordinateRegionMake(coordinate, spn) animated:YES];
}

#pragma mark - 设置地图的放大和缩小
-(void)addMapScale{
    UIButton *zoomin = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 40, ScreenHeight-150, 30, 30)];
    zoomin.backgroundColor = [UIColor clearColor];
    //    [zoomin setTitle:@"放大" forState:UIControlStateNormal];
    //    [zoomin setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [zoomin setBackgroundImage:[UIImage imageNamed:@"amplify"] forState:UIControlStateNormal];
    [self.view addSubview:zoomin];
    [zoomin addTarget:self action:@selector(clickZoom1:) forControlEvents:UIControlEventTouchUpInside];
    _zoomin = zoomin;
    
    UIButton *zoomout = [[UIButton alloc] initWithFrame:CGRectMake(zoomin.frame.origin.x, zoomin.frame.origin.y + 35, 30, 30)];
    zoomout.backgroundColor = [UIColor clearColor];
    //    [zoomout setTitle:@"缩小" forState:UIControlStateNormal];
    //    [zoomout setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [zoomout setBackgroundImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];
    [self.view addSubview:zoomout];
    [zoomout addTarget:self action:@selector(clickZoom2:) forControlEvents:UIControlEventTouchUpInside];
    _zoomout = zoomout;
    
}

#pragma mark - 地图的缩放

// 变大
-(void)clickZoom1:(UIButton *)sender{
    CLLocationCoordinate2D coordinate = _map.region.center;
    BMKCoordinateSpan spn;
    _zoomout.hidden = NO;
    spn = BMKCoordinateSpanMake(_map.region.span.latitudeDelta * 0.5, _map.region.span.longitudeDelta * 0.5);
    
    
    [_map setRegion:BMKCoordinateRegionMake(coordinate, spn) animated:YES];
    
}
//变小
-(void)clickZoom2:(UIButton *)sender{
    
    CLLocationCoordinate2D coordinate = _map.region.center;
    BMKCoordinateSpan spn;
    spn = BMKCoordinateSpanMake(_map.region.span.latitudeDelta * 2, _map.region.span.longitudeDelta * 02);
    if (spn.latitudeDelta >= 114 && spn.longitudeDelta >= 102) {
        _zoomout.hidden = YES;
        return;
    }
    [_map setRegion:BMKCoordinateRegionMake(coordinate, spn) animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    
    if([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}
@end
