//
//  NearbyVehiclesVC.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/13.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "NearbyVehiclesVC.h"
#import <CoreLocation/CoreLocation.h>
#import "CarTeamMode.h"
#import "DriverInfoMode.h"
#import "CarFleetCell.h"
#import "SearchCellTableViewCell.h"

#import "LookForCarViewController.h"
@interface NearbyVehiclesVC ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *heardSuperView;
@property (weak, nonatomic) IBOutlet UILabel *vehiclesLabel;//车型
@property (nonatomic,strong)UITableView *selectTableView;
@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)NSArray *selectArr;//可选择的车型数组
@property (nonatomic,strong)NSArray *selectArrEnglish;//可选择的车型数组 英文
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic,strong)NSString *vehicesLabelEnglish;//英文车型
@property (nonatomic,assign)int page;
@property (nonatomic,strong)NSMutableArray *nearCarArr;
@property (nonatomic,strong)NSString *longi;
@property (nonatomic,strong)NSString *latui;

@property (nonatomic, strong) CLLocationManager *lcManager;// 设置位置管理者属性


@end

@implementation NearbyVehiclesVC
static NSString *cellId = @"selectCell";
static NSString *listCellId = @"slistCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLocation];
    self.view.backgroundColor = BgColorOfUIView;
    self.navigationItem.title = @"附近车辆";
    self.vehiclesLabel.text = @"请选择车型";
    self.vehiclesLabel.textColor = RGBA(153, 153, 153, 1);
    _nearCarArr = [NSMutableArray array];
    _page = 1;
    [self initOthers];


}

- (BOOL)getLocation{
    
    // 判断是否打开了位置服务
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] > 2) ){
            //定位功能可用
        // 创建位置管理者对象
        self.lcManager = [[CLLocationManager alloc] init];
        self.lcManager.delegate = self; // 设置代理
        // 设置定位距离过滤参数 (当本次定位和上次定位之间的距离大于或等于这个值时，调用代理方法)
        self.lcManager.distanceFilter = 10;
        self.lcManager.desiredAccuracy = kCLLocationAccuracyBest; // 设置定位精度(精度越高越耗电)
        [self.lcManager startUpdatingLocation]; // 开始更新位置
        
        return YES;
    }else{
        
        [self   presentTipAlert];
        return NO;

    }

}
- (void)presentTipAlert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位服务未开启" message:@"请在设置-隐私-定位服务中允许简运使用定位服务" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
       
//        if (IOS_VERSION < 10) {
//            NSURL *url= [NSURL URLWithString:@"prefs:root=com.yongheli.JY-transport"];
//            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
//                [[UIApplication sharedApplication]openURL:url];
//            }
//        }else if (IOS_VERSION >= 10) {
//
//            NSURL *url= [NSURL URLWithString:@"App-Prefs:root=Privacy&path=LOCATION"];
//
//            if( [[UIApplication sharedApplication]canOpenURL:UIApplicationOpenSettingsURLString] ) {
//                [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
//                }];
//            }
//
//        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
  
    [alert addAction:cancel];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
    
}

- (void)creatTableView{

    [_selectTableView removeFromSuperview];
    UITableView *selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 45, ScreenWidth-24, 37*6) style:UITableViewStylePlain];
    selectTableView.backgroundColor = [UIColor redColor];
    selectTableView.scrollEnabled = NO;
    selectTableView.delegate = self;
    selectTableView.dataSource = self;
    [selectTableView setLayoutMargins:UIEdgeInsetsZero];
    [selectTableView setSeparatorInset:UIEdgeInsetsZero];
    selectTableView.layer.borderWidth = 1;
    selectTableView.layer.borderColor = BGBlue.CGColor;
    _selectTableView = selectTableView;
    [self.view addSubview:_selectTableView];
    
}
- (void)creatListTableView{
    
    UITableView *listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 57, ScreenWidth , ScreenHeight -57 -64) style:UITableViewStylePlain];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    _listTableView = listTableView;
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    self.listTableView.backgroundColor = RGBA(232, 232, 232, 1);
    [self.listTableView setTableFooterView:v];
    [self.view addSubview:_listTableView];
}
- (void)initOthers{
    
    _selectArr = [NSArray array];
    _selectArr = @[@"微面",@"大型面包车",@"依维柯",@"微型货车",@"小型货车",@"中型货车",@"平板车"];
    _selectArrEnglish = [NSArray array];
    _selectArrEnglish = @[@"MINIVAN",@"LARGEVAN",@"IVECO",@"MINITRUCK",@"SMALLTRUCK",@"MEDIUMTRUCK",@"FLATBED"];
    _heardSuperView.frame = CGRectMake(0, 0, ScreenWidth, 40);
    
}
- (IBAction)selectVehiclesBtn:(UIButton *)sender {

    [self creatTableView];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dissMIssSexView];
}
- (void)dissMIssSexView{


    [_selectTableView removeFromSuperview];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _selectTableView) {
        return _selectArr.count;
    }else{
        return _nearCarArr.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;

    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (tableView == _selectTableView) {
       
        SearchCellTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SearchCellTableViewCell class]) owner:self options:nil][0];
        cell.listLabel.text = _selectArr[indexPath.section];
        cell.listLabel.text = _selectArr[indexPath.section];
        cell.listLabel.textColor = RGBA(51, 51, 51, 1);
        cell.listLabel.font = [UIFont systemFontOfSize:12];

        return cell;
    }else{
    
        CarFleetCell *carCell = [CarFleetCell cellWithTableView:tableView];
        carCell.carMode = self.nearCarArr[indexPath.section];
        carCell.callPhoneButton.tag = indexPath.section;
        carCell.lookForCarButton.tag = indexPath.section;
        [carCell.callPhoneButton addTarget:self action:@selector(callClick:) forControlEvents:UIControlEventTouchUpInside];

        [carCell.lookForCarButton addTarget:self action:@selector(lookForCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        carCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return carCell;

        }
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _selectTableView) {
        
        if ([self getLocation]) {
            
            _vehiclesLabel.textColor = BGBlue;
            _vehiclesLabel.text = _selectArr[indexPath.section];
            _vehicesLabelEnglish = _selectArrEnglish[indexPath.section];
            
            [self queryNearVehicles];
            [self dissMIssSexView];
            [self creatListTableView];
        }else{
            
        }
        
       
    }else{
       
    }
   
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    view.backgroundColor = BgColorOfUIView;
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    if (tableView == _selectTableView) {
        return 0.001;
        
    }else{
        if (section == 0) {
            return 0.001;
        }else{
            return 9;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _selectTableView) {
        return 37;

    }else{
        return 165;
        
    }
  }

//拨打电话
- (void)callClick:(UIButton *)btn{
    
    CarTeamMode *mode = self.nearCarArr[btn.tag];
    NSMutableString* callPhone=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",mode.truckGoup.phone];
    
    if (IOS_VERSION >= 10.0) {
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        
    } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}
- (void)lookForCarBtnClick:(UIButton *)btn{
    
    CarTeamMode *mode = self.nearCarArr[btn.tag];
    LookForCarViewController *lookVC = [[LookForCarViewController alloc] init];
    lookVC.teamDrMode = mode.truckGoup;
    [self.navigationController pushViewController:lookVC animated:YES];

}
//请求数据
-(void)queryNearVehicles
{
    _page = 1;
    NSString *url = [NSString stringWithFormat:base_url];
    NSString *urlstr = [url stringByAppendingString:@"app/user/getNearbyTrucklist"];
    [[NetWorkHelper shareInstance]Post:urlstr parameter:@{@"vehicle":self.vehicesLabelEnglish,@"page":@"1",@"longitude":_longi,@"latitude":_latui} success:^(id responseObj) {
        self.nearCarArr = [CarTeamMode mj_objectArrayWithKeyValuesArray:responseObj];
      
            [self.listTableView reloadData];
      
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络异常"];
    }];
}


/** 获取到新的位置信息时调用*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"定位到了");
    CLLocation *location = [locations lastObject];
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    _latui = [NSString stringWithFormat:@"%f",latitude];
    _longi = [NSString stringWithFormat:@"%f",longitude];
    
    
}
/** 不能获取位置信息时调用*/
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"获取定位失败");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
