//
//  placeLocationViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/9.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "placeLocationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "XGAnnotation.h"
#import "XGAnnotationView.h"

@interface placeLocationViewController ()<MKMapViewDelegate>

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (nonatomic, weak) UIButton *centerButton;
@property(nonatomic,weak)UIButton *zoomin;
@property(nonatomic,weak)UIButton *zoomout;
@property(nonatomic,weak)XGAnnotation *lastAnnotation;
@end

@implementation placeLocationViewController
{
    MKMapView                          *_map;
    CLLocationManager              *_manager;
    UISegmentedControl             *_segment;
    UIButton                       *_backBtn;
    UIButton                     *_aerialBtn;
    NSMutableArray         *_polyLineMutable;
    NSMutableArray            *_routeDetails;
    NSTimer *timer;
    
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
   self.navigationItem.title = @"地图";
    // 添加地图
    [self addMapView];
     //设置地图的缩放模式
    [self addMapScale];
    // 设置返回按钮
    [self addBackBtn];
    // 设置航拍模式
    [self addAerialBtn];
    
    [self addCenterAnnotationView];
    
    
    
    
}

-(void)addCenterAnnotationView
{

   // XGAnnotation *startAnnotation = [[XGAnnotation alloc] init];
    
    
    CLLocationCoordinate2D coordinate = _map.userLocation.location.coordinate;
    // 设置跨度 = 当前地图的跨度
    MKCoordinateSpan spn = _map.region.span;
    [_map setRegion:MKCoordinateRegionMake(coordinate, spn) animated:YES];
    
    
    
//    CLLocationCoordinate2D startAnnotationcoor =  CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
    
  
    
    
    
//    startAnnotation.coordinate = startAnnotationcoor;
//    startAnnotation.title = @"起点";
//    startAnnotation.subtitle =@"";
//    startAnnotation.icon = @"center_car";
//    self.lastAnnotation = startAnnotation;
//    [_map addAnnotation:startAnnotation];
    
    
    
    

    
    




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
    _map.camera = [MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(39.9, 116.4) fromDistance:100 pitch:90 heading:0];
    _map.userTrackingMode = MKUserTrackingModeFollow;
}
#pragma mark - 添加地图
-(void)addMapView{
    MKMapView *map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:map];
    _map = map;
    
    
    // 在地图上显示定位
    // 1、请求授权(在Info.plist中添加NSLocationWhenInUseUsageDescription）
    _manager = [[CLLocationManager alloc] init];
    [_manager requestWhenInUseAuthorization];
    
    // 2.设置地图的用户跟踪模式
    map.userTrackingMode = MKUserTrackingModeFollow;
    map.delegate = self;
    
    // 其他的新属性
    // 显示指南针
    _map.showsCompass = YES;
    // 显示感兴趣的点，默认是显示的
    _map.showsPointsOfInterest = YES;
    // 显示标尺(单位：mi 英尺)
    _map.showsScale = YES;
    // 显示交通情况
    _map.showsTraffic = YES;
    // 显示定位大头针，默认是显示的
    _map.showsUserLocation = YES;
    // 显示建筑物的3D模型，设置3D/沙盘/航拍模式(高德地图不支持)
    _map.showsBuildings = YES;
    
    
}
#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error) {
            return ;
        }
        CLPlacemark *pm = placemarks.lastObject;
        _map.userLocation.title = [NSString stringWithFormat:@"%@-%@-%@",pm.administrativeArea,pm.locality,pm.subLocality];
        _map.userLocation.subtitle = pm.name;
        
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[XGAnnotation class]]) return nil;
    
    static NSString *ID = @"tuangou";
    // 从缓存池中取出可以循环利用的大头针view
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
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
    CLLocationCoordinate2D coordinate = _map.userLocation.location.coordinate;
    // 设置跨度 = 当前地图的跨度
    MKCoordinateSpan spn = _map.region.span;
    [_map setRegion:MKCoordinateRegionMake(coordinate, spn) animated:YES];
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
    MKCoordinateSpan spn;
    _zoomout.hidden = NO;
    spn = MKCoordinateSpanMake(_map.region.span.latitudeDelta * 0.5, _map.region.span.longitudeDelta * 0.5);
    
    
    [_map setRegion:MKCoordinateRegionMake(coordinate, spn) animated:YES];
    
}
//变小
-(void)clickZoom2:(UIButton *)sender{
    
    CLLocationCoordinate2D coordinate = _map.region.center;
    MKCoordinateSpan spn;
    spn = MKCoordinateSpanMake(_map.region.span.latitudeDelta * 2, _map.region.span.longitudeDelta * 02);
    if (spn.latitudeDelta >= 114 && spn.longitudeDelta >= 102) {
        _zoomout.hidden = YES;
        return;
    }
    [_map setRegion:MKCoordinateRegionMake(coordinate, spn) animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    
    if([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    [super didReceiveMemoryWarning];
}

@end
