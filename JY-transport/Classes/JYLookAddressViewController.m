//
//  JYLookAddressViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/21.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYLookAddressViewController.h"

#import <MAMapKit/MAMapKit.h>
#import "JYAnnotation.h"
#import "UIView+Toast.h"
#import "TLCityPickerController.h"
#import "AddressCellTableViewCell.h"

#import "searchResultModel.h"
@interface JYLookAddressViewController ()<MAMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TLCityPickerDelegate,UINavigationControllerDelegate,BMKPoiSearchDelegate>

@property(nonatomic,strong)BMKMapView *mapView;
/**  searchView  **/
@property(nonatomic,strong) UIView *searchView;
/**  back button  **/
@property(nonatomic,strong) UIButton *back;
/**  search textFiled  **/
@property(nonatomic,strong) UITextField *searchTextFiled;
/**  标注  **/
//@property(nonatomic,strong) MAPointAnnotation *pointAnnotation;
/**  标注  **/
@property(nonatomic,strong) BMKPointAnnotation *pointAnnotation;
/**  位置按钮  **/
@property(nonatomic,strong) UIButton *address;
/**  搜搜结果列表  **/
@property(nonatomic,strong) UITableView *searchTableView;
/**  data source  **/
@property(nonatomic,strong) NSArray *dataSource;
/**  城市  **/
@property(nonatomic,strong) NSString *cityName;
/**  确定位置  **/
@property(nonatomic,strong) UIButton *confirm;
/**  坐标  **/



@property (nonatomic,assign)BOOL isFirstLocation;

@property (nonatomic,strong)NSString *city;
@property (nonatomic,assign) BOOL userCity;
@property (nonatomic,strong)NSString *userCityStr;
@property (nonatomic,strong)BMKLocationService *locService;

@property (nonatomic,strong)BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic,strong)BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
@property (nonatomic,strong)BMKReverseGeoCodeResult *resultData;

@property (nonatomic,strong)BMKPoiSearch *searcher;
@property (nonatomic,strong)UILabel *titleLabel; //气泡标题
@property (nonatomic,strong)UILabel *subleLabel;//气泡副标题
@property (nonatomic,strong)UIImageView *pubbleView;//气泡view
@property (nonatomic,strong)UIImageView *findView;//搜寻中的气泡view

@property (nonatomic,assign)BOOL markSekectCellData;
@property (nonatomic,assign)BOOL markClickCell;
@property (nonatomic,assign)CLLocationCoordinate2D markcellLocation;

@property (nonatomic,strong)UIView *heardView;
@property (nonatomic,strong)UIView *footView;

@property (nonatomic,strong)NSArray *myArray;
@property (nonatomic,assign)BOOL isFirstSearch;
@property (nonatomic,strong)NSArray *subAddress;
@property (nonatomic,strong)NSArray *latuateArr;
@property (nonatomic,strong)NSArray *longtuateArr;
@end

@implementation JYLookAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationBar.hidden = YES;
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    
    _city = @"位置";
    ///初始化地图
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44)];
    [_mapView setLogoPosition:BMKLogoPositionRightBottom];
    [self.view addSubview:self.mapView];
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    self.mapView.showsUserLocation = YES;
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = YES;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = YES;//精度圈是否显示
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    
    // 1.跟踪用户位置(显示用户的具体位置)
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    // 2.设置代理
    self.mapView.delegate = self;
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //    _locService.distanceFilter = 10;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    //    _locService.pausesLocationUpdatesAutomatically = YES;
    //    _locService.allowsBackgroundLocationUpdates = YES;
    //启动LocationService
    [_locService startUserLocationService];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    
    
    _reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    [self initView];
    
    _markSekectCellData = NO;
    _markClickCell = NO;
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    _isFirstLocation = NO;
    _userCity = NO;
    [self creatImageView];
    _myArray = [NSArray array];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaultes objectForKey:@"myArr"];
    _myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (_myArray == nil) {
        _myArray = [NSArray array];
    }
    
    //读取数组NSArray类型的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundhome:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    _isFirstSearch = NO;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _geoCodeSearch.delegate = nil;
}
- (void)searchPoiInfo:(NSString *)keyWorld{
    
    //发起检索
    BMKCitySearchOption *option = [[BMKCitySearchOption alloc]init];
    option.city = self.address.titleLabel.text;
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.keyword = keyWorld;
    BOOL flag = [_searcher poiSearchInCity:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    
}
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (poiResult !=nil ) {
        
        NSLog(@"周边检索＝＝＝＝＝成功");
        if ( poiResult.poiInfoList.count > 0) {
            
            _isFirstSearch = YES;
            _footView.hidden  = YES;
            _heardView.hidden  = YES;
            self.searchTableView.hidden = NO;
            
            NSArray *bmkInfoArr = poiResult.poiInfoList;
            self.dataSource = bmkInfoArr;
            //          BMKPoiInfo *info = self.dataSource[0];
            [self.searchTableView reloadData];
            
        }
        
    }
    
}
//创建大头针view
- (void)creatImageView{
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"datouzhen2"]];
    imgView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y-CGRectGetHeight(_pubbleView.bounds)/2);
    [self.mapView addSubview:imgView];
    
    UIImage *image = [UIImage imageNamed:@"bubble2"];
    _pubbleView = [[UIImageView alloc] initWithImage:image];
    _pubbleView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y-CGRectGetHeight(_pubbleView.bounds)/2 - 40);
    [self.mapView addSubview:_pubbleView];
    
    
    _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _subleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_pubbleView addSubview:_titleLabel];
    [_pubbleView addSubview:_subleLabel];
    [self findAddress];
}

//创建搜寻中气泡
- (void)findAddress{
    
    _findView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble2"]];
    _findView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y-CGRectGetHeight(_pubbleView.bounds)/2 - 40);
    UILabel *findLabel = [[UILabel alloc] init];
    findLabel.text = @"搜寻中...";
    findLabel.font = [UIFont systemFontOfSize:14];
    findLabel.textColor = RGBA(153, 153, 153, 1);
    findLabel.frame = CGRectMake((_pubbleView.width -40)/2, (_pubbleView.height -38)/2, 40, 30);
    [_findView addSubview:findLabel];
    [self.mapView addSubview:_findView];
}
//气泡view的title 和subleTitle
- (void)creatPubbleTitlleView:(NSString*)titleText SubleText:(NSString *)subleText{
    
    
    _titleLabel.text = titleText;
    CGSize size = [titleText boundingRectWithSize:CGSizeMake(ScreenWidth -100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    CGFloat TitleW = size.width;
    _titleLabel.textAlignment =NSTextAlignmentCenter;
    
    
    _subleLabel.text = subleText;
    CGSize subSize = [subleText boundingRectWithSize:CGSizeMake(ScreenWidth -100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _subleLabel.textColor = RGBA(153, 153, 153, 1);
    CGFloat SubleW = subSize.width;
    _subleLabel.adjustsFontSizeToFitWidth = YES;
    _subleLabel.textAlignment =NSTextAlignmentCenter;
    
    
    CGFloat PubbleW;
    if (TitleW > SubleW ) {
        PubbleW = TitleW;
    }else{
        PubbleW = SubleW;
    }
    if (PubbleW > ScreenWidth - 100) {
        PubbleW = ScreenWidth -100;
    }
    
    CGFloat pubble =  self.findView.frame.origin.y + 55;
    
    CGFloat pubbleY = pubble -size.height - subSize.height -40;
    [_titleLabel setFrame:CGRectMake((PubbleW+10 - TitleW)/2, 8, TitleW, 20)];
    [_subleLabel setFrame:CGRectMake((PubbleW+10 - SubleW)/2, size.height+10, SubleW, 20)];
    
    _pubbleView.frame = CGRectMake((ScreenWidth - PubbleW-10)/2,pubbleY, PubbleW + 10, size.height + subSize.height +40);
    
    UIImage *image = [UIImage imageNamed:@"bubble2"];
    CGFloat top = image.size.width*0.5;
    CGFloat left = image.size.width * 0.5;
    CGFloat bottom = image.size.height *0.5;
    CGFloat right = image.size.width * 0.5;
    
    [image resizableImageWithCapInsets:UIEdgeInsetsMake(top-0.5,left-0.5,bottom-0.5,right-0.5) resizingMode:UIImageResizingModeStretch];
    _pubbleView.image = image;
}


#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}



- (void)initView {
    __weak typeof(self) weakSelf = self;
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view.mas_width).multipliedBy(0.9);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
    }];
    
    [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.equalTo(weakSelf.searchView.mas_height);
        make.left.equalTo(weakSelf.searchView.mas_left);
        make.bottom.equalTo(weakSelf.searchView.mas_bottom);
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor grayColor];
    [self.searchView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.searchView.mas_bottom).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(1);
        make.left.equalTo(weakSelf.back.mas_right).offset(10);
    }];
    
    [self.searchTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line1.mas_right).offset(10);
        make.bottom.equalTo(weakSelf.searchView.mas_bottom);
        make.height.equalTo(weakSelf.searchView.mas_height);
        make.right.equalTo(weakSelf.searchView.mas_right).offset(-80);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor grayColor];
    [self.searchView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.bottom.equalTo(weakSelf.searchView.mas_bottom).offset(-10);
        make.width.mas_equalTo(1);
        make.left.equalTo(weakSelf.searchTextFiled.mas_right).offset(10);
    }];
    
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line2.mas_right).offset(10);
        make.right.equalTo(weakSelf.searchView.mas_right);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(weakSelf.searchView.mas_bottom);
    }];
    
    //    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(weakSelf.searchView.mas_bottom).offset(10);
    //        make.left.equalTo(weakSelf.searchView.mas_left);
    //        make.right.equalTo(weakSelf.searchView.mas_right);
    //        make.height.mas_equalTo(0);
    //    }];
    
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(44);
    }];
}
#pragma mark -  textFiled 代理

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    self.searchView.layer.borderWidth = 0;
    //    [UIView animateWithDuration:1 animations:^{
    //        self.topView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.topView.frame.origin.y + self.searchView.frame.size.height);
    //    }];
    //    CGFloat hei = [UIScreen mainScreen].bounds.size.height - _searchTableView.frame.origin.y - 316;
    //    [_searchTableView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(hei);
    //    }];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaultes objectForKey:@"myArr"];
    _myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (textField.text.length == 0) {
        if (_myArray.count > 0) {
            _footView.hidden  = NO;
            _heardView.hidden  = NO;
            self.searchTableView.hidden = NO;
            [self.searchTableView reloadData];
        }else{
            self.searchTableView.hidden = YES;
            _footView.hidden  = YES;
            _heardView.hidden  = YES;
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchPoiInfo:textField.text];
    [_searchTextFiled resignFirstResponder];
    
    return YES;
}

-(void)textField1TextChange:(UITextField *)textField{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaultes objectForKey:@"myArr"];
    _myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (self.searchTextFiled.text.length == 0) {
        if (_myArray.count > 0) {
            _isFirstSearch = NO;
            _footView.hidden  = NO;
            _heardView.hidden  = NO;
            self.searchTableView.hidden = NO;
            [self.searchTableView reloadData];
        }
        
    }else{
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (string.length == 0) {
        if (self.searchTextFiled.text.length == 0) {
            
        }else{
            //            [self searchAddress:[textField.text substringToIndex:textField.text.length - 1]];
            //            [self searchPoiInfo:textField.text];
            NSLog(@"33333333");
        }
    }else{
        [self searchPoiInfo:textField.text];
        NSLog(@"444444444");
    }
    return YES;
}
//- (void)searchAddress:(NSString*)str {
//
//    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
//    request.keywords = str;
//    request.cityLimit = YES;
//    request.city = self.address.titleLabel.text;
//    [self.searchApi AMapPOIKeywordsSearch:request];
//
//
//}

#pragma mark - TLCityPickerDelegate
-(void)cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    NSLog(@"%@",city.cityName);
    [self.address setTitle:city.cityName forState:UIControlStateNormal];
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        [self getSelectCityLocation:city.cityName];
        
    }];
    
    
}
- (void)getSelectCityLocation:(NSString *)city{
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= city;
    geoCodeSearchOption.address = city;
    BOOL flag = [_geoCodeSearch geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo获取城市位置的坐标请求发送成功");
    }
    else
    {
        NSLog(@"geo获取城市位置的坐标请求发送失败");
    }
    
}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        CLLocationCoordinate2D location = result.location;
        [self.mapView setCenterCoordinate:location animated:YES];
        
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
-(void)cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark -  TableView 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_myArray.count > 0 && _isFirstSearch == NO) {
        
        return _myArray.count + 1 ;
    }else{
        return self.dataSource.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCellTableViewCell *cell =[AddressCellTableViewCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (_myArray.count > 0 && _isFirstSearch == NO) {
        if (indexPath.row == _myArray.count) {
            _heardView.hidden = NO;
            _footView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, _searchTableView.width, 52)];
            _footView.backgroundColor = [UIColor orangeColor];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame  = CGRectMake(0, 0, _searchTableView.width, 52);
            [btn setTitle:@"删除记录"  forState:(UIControlStateNormal)];
            [btn addTarget:self action:@selector(clickemptyBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_footView addSubview:btn];
            [cell.contentView addSubview:_footView];
        }else{
            searchResultModel *mode = [[searchResultModel alloc] init];
            
            mode =  self.myArray[indexPath.row];
            cell.cityName.text = mode.name;
            cell.subCityName.text = mode.address;
        }
        
        return cell;
    }else{
        BMKPoiInfo *info = self.dataSource[indexPath.row];
        
        cell.cityName.text = info.name;
        cell.subCityName.text = info.address;
        
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    searchResultModel *model = [[searchResultModel alloc] init];
    
    if (_heardView.hidden == NO) {
        model = _myArray[indexPath.row];
        
        _markcellLocation = CLLocationCoordinate2DMake(model.latitude, model.longitude);
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(model.latitude,model.longitude);
        [self.mapView setCenterCoordinate:location animated:YES];
        [_searchTextFiled resignFirstResponder];
        [self creatPubbleTitlleView:model.name SubleText:model.address];
        [self.address setTitle:model.city forState:UIControlStateNormal];
        _markSekectCellData = YES;
        _footView.hidden = YES;
        _heardView.hidden =YES;
        self.searchTableView.hidden = YES;
        _markClickCell = YES;
        _searchTextFiled.text = model.name;
        
    }else{
        [self.searchTextFiled resignFirstResponder];
        self.searchTableView.hidden = YES;
        _markClickCell = YES;
        _markSekectCellData = YES;
        BMKPoiInfo *info = self.dataSource[indexPath.row];
        [self creatPubbleTitlleView:info.name SubleText:info.address];
        [self.address setTitle:info.city forState:UIControlStateNormal];
        _markcellLocation = info.pt;
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(info.pt.latitude, info.pt.longitude);
        [self.mapView setCenterCoordinate:location animated:YES];
        _searchTextFiled.text = info.name;
        model.name = info.name;
        model.address = info.address;
        model.latitude = info.pt.latitude;
        model.longitude = info.pt.longitude;
        model.city = info.city;
        _findView.hidden  = YES;
        _heardView.hidden = YES;
        //保存为历史纪录
        [self SearchText:model];
        
    }
    
}

#pragma mark -  地图代理


//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    // 系统气泡
    //    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    //    {
    //        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
    //        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
    //        if (annotationView == nil)
    //        {
    //            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
    //        }
    //
    //        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
    //        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
    //        annotationView.pinColor = BMKPinAnnotationColorPurple;
    //        // 从天上掉下效果
    //        annotationView.animatesDrop = YES;
    //
    //        [annotationView setSelected:YES animated:YES];
    ////        annotationView.image = [UIImage imageNamed:@"end"];
    //        [mapView selectAnnotation:annotation animated:YES];
    //        return annotationView;
    //
    //    }
//    return nil;

//}


/**
 *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 *@param mapView 地图View
 *@param status 此时地图的状态
 */
//- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status{
//
//
//}

/**
 *地图区域即将改变时会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    //    self.pointAnnotation.subtitle = @"搜寻中...";
    //    self.pointAnnotation.title = @"";
    //    [_mapView selectAnnotation:self.pointAnnotation animated:YES];
    
    self.confirm.enabled = NO;
    self.confirm.backgroundColor =[UIColor grayColor];
    _findView.hidden = NO;
    _pubbleView.hidden = YES;
    NSLog(@"地图区域即将改变时会调用此接口");
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    _reverseGeoCodeSearchOption.reverseGeoPoint = mapView.centerCoordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:_reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
    NSLog(@"地图渲染完毕后会调用此接口%f,%f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    
    NSLog(@"地图区域改变完成后会调用此接口");
}



/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    
    if (result.address != nil) {
        NSString * street = result.address;
        //                self.pointAnnotation.subtitle = street;
        if (result.poiList.count > 0) {
            _findView.hidden = YES;
            _pubbleView.hidden = NO;
            BMKPoiInfo *info = result.poiList[0];
            //                    self.pointAnnotation.title = info.name;
            
            if (_markSekectCellData == NO) {
                [self creatPubbleTitlleView:info.name SubleText:street];
            }
            
            _markSekectCellData = NO;
            _city =result.addressDetail.city;
            [self getUserCity:_city];
            [_address setTitle:_city forState:UIControlStateNormal];
            self.resultData = result;
            self.confirm.enabled = YES;
            self.confirm.backgroundColor = [UIColor colorWithHexString:@"#118ae7"];
            NSLog(@"反地理成功");
            //                     [_mapView selectAnnotation:self.pointAnnotation animated:YES];
            [_mapView mapForceRefresh];
        }
        
    }
    
    
    
}
- (void)getUserCity:(NSString *)str{
    
    if (_userCity != YES) {
        _userCityStr = str;
    }
    _userCity = YES;
}
#pragma mark - MKMapViewDelegate
/**
 *  当用户的位置更新，就会调用（不断地监控用户的位置，调用频率特别高）
 *
 *  @param userLocation 表示地图上蓝色那颗大头针的数据
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    if (_isFirstLocation ==NO) {
        // 取出用户当前的经纬度
        CLLocationCoordinate2D center = userLocation.location.coordinate;
        
        // 设置地图的中心点（以用户所在的位置为中心点）
        [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        
        BMKCoordinateRegion region;
        region.center.longitude = center.longitude;
        region.center.latitude = center.latitude;
        region.span.latitudeDelta = 0.005;
        region.span.longitudeDelta = 0.005;
        [_mapView updateLocationData:userLocation];
        [_mapView setRegion:region animated:YES];
        NSLog(@"===================%f",userLocation.location.coordinate.latitude);
        
        //         self.pointAnnotation = [[BMKPointAnnotation alloc] init];
        //     self.pointAnnotation.lockedToScreen = YES;
        //              self.pointAnnotation.coordinate= center;
        _reverseGeoCodeSearchOption.reverseGeoPoint = _mapView.centerCoordinate;
        BOOL flag = [_geoCodeSearch reverseGeoCode:_reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
        
        
        [_mapView addAnnotation:_pointAnnotation];
        
    }   _isFirstLocation =YES;
    
}



- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [UIView new];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.layer.cornerRadius = 2;
        _searchView.layer.masksToBounds = YES;
        _searchView.layer.borderColor = [UIColor grayColor].CGColor;
        _searchView.layer.borderWidth = 0.5;
        [self.view addSubview:_searchView];
    }
    return _searchView;
}

- (UIButton *)back
{
    if (!_back) {
        _back = [UIButton new];
        [_back setImage:[UIImage imageNamed:@"bake_LookCar"] forState:UIControlStateNormal];
        [_back addTarget:self action:@selector(backToPage) forControlEvents:UIControlEventTouchUpInside];
        [self.searchView addSubview:_back];
    }
    return _back;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
- (UITextField *)searchTextFiled
{
    if (!_searchTextFiled) {
        _searchTextFiled = [[UITextField alloc] init];
        _searchTextFiled.returnKeyType = UIReturnKeySearch;
        _searchTextFiled.placeholder = @"搜索地址";
        _searchTextFiled.delegate = self;
        [_searchTextFiled addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self.searchView addSubview:_searchTextFiled];
    }
    return _searchTextFiled;
}



//搜索历史纪录
-(void)SearchText :(searchResultModel *)seaTxt
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaultes objectForKey:@"myArr"];
    NSArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (myArray == nil) {
        myArray = [NSArray array];
    }
    // NSArray --> NSMutableArray
    NSMutableArray *searTXT = [NSMutableArray array];
    searTXT = [myArray mutableCopy];
    BOOL isEqualTo1,isEqualTo2;
    isEqualTo1 = NO,isEqualTo2 = NO;
    
    if (searTXT.count > 0) {
        isEqualTo2 = YES;
        int num;
        num = -1;
        //判断搜索内容是否存在，存在的话放到数组最后一位，不存在的话添加。
        for (searchResultModel * model in myArray) {
            num ++;
            if ([seaTxt.name isEqualToString:model.name]) {
                //获取指定对象的索引
                
                //                NSUInteger index = [myArray indexOfObject:seaTxt];
                [searTXT removeObjectAtIndex:num];
                [searTXT addObject:seaTxt];
                isEqualTo1 = YES;
                break;
            }
        }
    }
    
    if (!isEqualTo1 ||  !isEqualTo2) {
        
        [searTXT addObject:seaTxt];
    }
    if(searTXT.count > 10)
    {
        [searTXT removeObjectAtIndex:0];
    }
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dat = [NSKeyedArchiver archivedDataWithRootObject:searTXT];
    [userDefaults setObject:dat forKey:@"myArr"];
}
//删除历史纪录
-(void)clickemptyBtn:(UIButton *)button{
    NSString *message = NSLocalizedString(@"确定清空所有历史搜索吗？", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }];
    
    //确认删除
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSData *data = [userDefaultes objectForKey:@"myArr"];
        NSArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        
        NSMutableArray *searTXT = [myArray mutableCopy];
        [searTXT removeAllObjects];
        
        
        NSData *dat = [NSKeyedArchiver archivedDataWithRootObject:searTXT];
        [userDefaults setObject:dat forKey:@"myArr"];
        
        
        _footView.hidden = YES;
        _heardView.hidden =YES;
        self.searchTableView.hidden = YES;
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


// 地址按钮点击事件
- (void)Address {
    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    
    cityPickerVC.loactionCityName = self.userCityStr;
    //  cityPickerVC.commonCitys = [[NSMutableArray alloc] initWithArray: @[@"1400010000", @"100010000"]];        // 最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    //    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
    
    //    }];
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:cityPickerVC];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (UIButton *)address
{
    if (!_address) {
        _address = [UIButton new];
        [_address setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _address.titleLabel.font = [UIFont systemFontOfSize:15];
        [_address setTitle:@"位置" forState:UIControlStateNormal];
        [_address addTarget:self action:@selector(Address) forControlEvents:UIControlEventTouchUpInside];
        [self.searchView addSubview:_address];
    }
    return _address;
}

- (UITableView *)searchTableView
{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc]init];
        [_searchTableView registerNib:[UINib nibWithNibName:@"AddressCellTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
        _searchTableView.frame = CGRectMake(20, 100, ScreenWidth - 40, ScreenHeight * 0.45);
        self.searchTableView.tableFooterView = [[UIView alloc]init];
        _searchTableView.backgroundColor = [UIColor clearColor];
        _searchTableView.layer.cornerRadius = 3;
        _searchTableView.layer.masksToBounds = YES;
        _searchTableView.dataSource = self;
        _searchTableView.delegate = self;
        _searchTableView.rowHeight = 52;
        //_searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _heardView = [[UIView alloc] initWithFrame:CGRectMake(20, 78, 78, 20)];
        _heardView.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(1, 5, 100, 15)];
        _heardView.hidden = YES;
        [_heardView addSubview:lab];
        lab.text = @"历史纪录";
        [self.view addSubview:_heardView];
        
        
        
        [self.view addSubview:_searchTableView];
    }
    return _searchTableView;
}

- (UIButton *)confirm
{
    
    if (!_confirm) {
        _confirm = [UIButton new];
        //        _confirm.backgroundColor = [UIColor redColor];
        [_confirm setTitle:@"确认位置" forState:UIControlStateNormal];
        [_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirm addTarget:self action:@selector(confirmAddress) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirm];
    }
    return _confirm;
}
//
-(void)confirmAddress
{
    
    if (self.delegate && self.resultData != nil) {
        NSString *poi = @"";
        if (self.resultData.poiList.count > 0) {
            
            BMKPoiInfo *info =self.resultData.poiList[0];
            poi = info.name;
        }
        NSString *address = self.resultData.address;
        
        if (_markClickCell == YES) {
            // 代理回调
            [self.delegate didSelectAddress:_subleLabel.text poi:_titleLabel.text location:_markcellLocation];
            [self.delegate cityWideForDayAndHalfDay:_address.titleLabel.text];
            [self.navigationController popViewControllerAnimated:YES];
            _markClickCell = NO;
        }else{
            // 代理回调
            [self.delegate didSelectAddress:address poi:poi location:self.resultData.location];
            BMKAddressComponent *amp = self.resultData.addressDetail;
            [self.delegate cityWideForDayAndHalfDay:amp.city];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        _mapView.delegate = nil;
        [_mapView removeFromSuperview];
        _mapView = nil;
        
    }
}


-(void)backToPage
{
    
    _mapView.delegate = nil;
    [_mapView removeFromSuperview];
    _mapView = nil;
    [_searchTextFiled resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    _footView.hidden  = YES;
    _heardView.hidden  = YES;
    self.searchTableView.hidden = YES;
    self.searchTextFiled.text = @"";
    [self.searchTextFiled resignFirstResponder];
}


- (void)backgroundhome:(NSNotification *)notification{
    
    [self.view endEditing:YES];
    
}

- (void)dealloc{
    
    if (_mapView) {
        _mapView = nil;
    }
    _mapView.delegate = nil;
    [_mapView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}
@end
