//
//  TMRouteInquiryController.m
//  JY-transport
//
//  Created by 闫振 on 2018/2/1.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "TMRouteInquiryController.h"
#import "TMRouteInquiryTableViewCell.h"
#import "TMLocationManager.h"
#import "PSCityPickerView.h"
#import "TMRouteInquiryResultController.h"
#import "JYCompanyModel.h"
@interface TMRouteInquiryController ()<UITableViewDelegate,UITableViewDataSource,PSCityPickerViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
//定位 必须属性 保持强引用
@property (nonatomic,strong)TMLocationManager *manager;
@property (nonatomic,strong)PSCityPickerView *cityPicker;

@property (nonatomic,assign)NSInteger selectBtnTag;//点击选择哪个btn的标记
@property (nonatomic,strong)NSString *chooseStart;//选择的起点
@property (nonatomic,strong)NSString *chooseend;//选择的终点
@property (nonatomic,strong)NSString *originProvinceID;
@property (nonatomic,strong)NSString *endProvinceID;



@end

static NSString *TMRouteCell = @"TMRouteInquiryTableViewCell";

@implementation TMRouteInquiryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"线路查询";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return" highIcon:@"return" target:self action:@selector(returnBackAction)];
    _originProvinceID = @"";
    _endProvinceID = @"";
    [self createTableView];
   
//    [self startLoaction];

}
- (void)startLoaction{
    _manager = [TMLocationManager sharelocationManager];
    [_manager startLoaction];
    
    __weak typeof(self) weakSelf = self;

    _manager.tmLocationBlock = ^(NSString * city) {
 
        weakSelf.chooseStart = city;
        UIButton *startbtn = [weakSelf.view viewWithTag:1113];
        [startbtn setTitle:city forState:(UIControlStateNormal)];
        
        
    };
}


- (void)returnBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     [self.tableView registerClass:[TMRouteInquiryTableViewCell class] forCellReuseIdentifier:TMRouteCell];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 150;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TMRouteInquiryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TMRouteCell];
    if (cell == nil) {
        cell = [[TMRouteInquiryTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:TMRouteCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.startbtn addTarget:self action:@selector(startbtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
       [cell.endBtn addTarget:self action:@selector(startbtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    v.backgroundColor = BgColorOfUIView;
    UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    finishBtn.backgroundColor = BGBlue;
    finishBtn.layer.cornerRadius = 5;
    finishBtn.layer.masksToBounds = YES;
    [finishBtn setTitle:@"专线查询" forState:(UIControlStateNormal)];
    finishBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:17];
    finishBtn.frame = CGRectMake(15, 100, ScreenWidth -30, 50);
    [finishBtn addTarget:self
                  action:@selector(finishBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [v addSubview:finishBtn];
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 150;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (PSCityPickerView *)cityPicker
{
    if (!_cityPicker)
    {
        _cityPicker = [[PSCityPickerView alloc] initWithFrame:CGRectMake(12, ScreenHeight - 220, ScreenWidth - 24, 220)];
        _cityPicker.ComponentNum = 3;
        _cityPicker.ComponentWidth = (ScreenWidth - 50)/3;
        _cityPicker.ComponentRowheight = 40;
        _cityPicker.backgroundColor = [UIColor whiteColor];
        _cityPicker.cityPickerDelegate = self;
    }
    return _cityPicker;
}
#pragma mark - PSCityPickerViewDelegate
- (void)cityPickerView:(PSCityPickerView *)picker finishPickProvince:(NSString *)province city:(NSString *)city district:(NSString *)district ProvinceID:(NSString *)provinceID cityID:(NSString *)cityID districtID:(NSString *)districtID
{
    
    if (city == nil  || province == nil) {
        city = @"北京";
        province = @"北京";
        district = @"东城区";
    }
    
    
    NSString *chooseAddress = [NSString stringWithFormat:@"%@·%@",city,district];
    
    UIButton *startbtn = [self.view viewWithTag:1113];
    UIButton *endbtn = [self.view viewWithTag:1114];
   if (_selectBtnTag == 1113){
       _originProvinceID = provinceID;
       _chooseStart = chooseAddress;
        [startbtn setTitle:chooseAddress forState:(UIControlStateNormal)];
        [startbtn setTitleColor:BGBlue forState:(UIControlStateNormal)];

   }else if (_selectBtnTag == 1114) {
        _endProvinceID = provinceID;
       _chooseend = chooseAddress;
       [endbtn setTitle:chooseAddress forState:(UIControlStateNormal)];
       [endbtn setTitleColor:BGBlue forState:(UIControlStateNormal)];
   }
}
- (void)startbtnClick:(UIButton *)btn{
  
   _selectBtnTag = btn.tag;
    [self.cityPicker showPickView];
    
}
- (void)finishBtnClick:(UIButton *)btn{
 
    [self searchData:1];
  
}


- (void)searchData:(NSInteger)page{
    
    NSString *baseStr = base_url;
    NSString *url = [baseStr stringByAppendingString:@"app/user/getLogisticGroupByLine"];
    
    [[NetWorkHelper shareInstance] Post:url parameter:@{@"originProvince":_originProvinceID,@"endProvince":_endProvinceID,@"page":@(page)} success:^(id responseObj) {
        
        NSString *code = [responseObj objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            
            NSMutableArray *dataArr = [JYCompanyModel mj_objectArrayWithKeyValuesArray:[responseObj objectForKey:@"result"]];

            TMRouteInquiryResultController *vc = [[TMRouteInquiryResultController alloc] init];
            vc.startStr = _chooseStart;
            vc.endStr = _chooseend;
            vc.dataArr = dataArr;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([code isEqualToString:@"404"]){
             [MBProgressHUD showError:@"暂无此线路"];
        }
        else{
            [MBProgressHUD showError:@"查询失败"];
        }
       
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"查询失败"];

    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
