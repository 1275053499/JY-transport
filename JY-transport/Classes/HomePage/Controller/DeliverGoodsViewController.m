//
//  DeliverGoodsViewController.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/5/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "DeliverGoodsViewController.h"
#import "JYTitleButton.h"


#import "JYShipLineTableViewCell.h"


#import "PSCityPickerView.h"
#import "JYWaitingAnimationViewController.h"
#import "JYHomeRequestDate.h"
#import <QiniuSDK.h>

#import "XZPickView.h"
#import <IQKeyboardManager.h>
#import "JYOrderDetailModel.h"
#import "JYShipBaseViewController.h"

#import "JYShipOrderDetailTableViewCell.h"
#import "JYDescripeTableViewCell.h"
#import "JYSwitchEvulteTableViewCell.h"
#import "JYSwitchTableViewCell.h"
#import "JYShipServicesTabcell.h"
#import "JYSendDescriptionViewController.h"
@interface DeliverGoodsViewController ()<PSCityPickerViewDelegate,JYHomeRequestDateDelegate,XZPickViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,weak)UIView *topView;
@property(nonatomic,strong)NSMutableArray *topTitleArr;


@property(nonatomic,strong)NSArray *titles;




@property (nonatomic,strong)NSString *latitude;
@property (nonatomic,strong)NSString *longitude;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,assign)NSInteger btntag;//选择地址按钮标记tag

@property (nonatomic,strong)UIButton *locationBtn;//定位按钮

@property (strong, nonatomic) PSCityPickerView *cityPicker;
@property (nonatomic,strong)NSString *startChoose;// 选择起点
@property (nonatomic,strong)NSString *endChoose;// 选择终点

@property (nonatomic,strong)NSDictionary *addressStrDic;
@property (nonatomic,strong)NSDictionary *addressEndDic;
@property (nonatomic,strong)NSMutableArray *photoArr;//图片数组
@property (nonatomic,strong)NSString *text;//描述文本
@property (nonatomic,strong)NSMutableArray *photoName;//图片名字
@property (nonatomic,strong)NSString *selectDate;//预约选择时间
@property (nonatomic,assign)NSInteger tag;


@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSString *volume;//体积
@property (nonatomic,strong)NSString *number;//数量
@property (nonatomic,strong)NSString *weight;//重量
@property (nonatomic,strong)NSString *package;//包装
@property (nonatomic,strong)NSString *evulteStr;//价值
@property (nonatomic,strong)NSString *name;//货物名称
@property (nonatomic,strong)NSString *evulteMoney;
@property (nonatomic,assign)NSInteger PaymentNum;
@property (nonatomic,strong)NSString *money;
@property (nonatomic,strong)JYSwitchEvulteTableViewCell *evuleteCell;
@property (nonatomic,strong)NSMutableArray *serviceArr;
@property (nonatomic,assign)NSInteger evulteNum;

@property (nonatomic,strong)UIButton *sureBtn;
@property (nonatomic,strong)UIButton *yueBtn;



@end

@implementation DeliverGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"设定详情";
    self.view.backgroundColor = RGB(234, 239, 243);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _addressStrDic = [NSDictionary dictionary];
    _addressEndDic = [NSDictionary dictionary];
    _photoName = [NSMutableArray array];
    _photoArr = [NSMutableArray array];
    _text =@"";
    _tag = 0;
    _selectDate = @"";
    _volume = @"";
    _number = @"";
    _weight = @"";
    _package = @"";
    _evulteStr = @"";
    _name = @"";
    _evulteMoney = @"";
    _money = @"";
    _PaymentNum = 1;
    _evulteNum = 1;
    _serviceArr = [NSMutableArray array];

    [self creatTableView];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"keyBoardShow"
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"keyBoardHide"
                                               object:nil];

    //添加货物描述返回时，传图片和内容过来
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageAndContent:)
                                                 name:@"imageAndContent"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrameNotification:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    
    self.titles=@[@"货物详情",@"服务详情",];
//  [self initBMKMapLocation];

    [self creatBtn];
    
}


- (void)willChangeStatusBarFrameNotification:(NSNotification *)nottfication{
    
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - StateBarHeight - 50);
    _yueBtn.frame = CGRectMake((ScreenWidth - 135), ScreenHeight - NavigationBarHeight - StateBarHeight - 50- 42, 135, 50);
    _sureBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight -42,ScreenWidth -135, 50);

   
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];

}

- (void)creatTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -42 -50 - NavigationBarHeight - StateBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor =BgColorOfUIView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //为了让tableview 第一行显示和屏幕一样宽
    UIView *backGround = [[UIView alloc] initWithFrame:CGRectMake(-7, 1, 7, 150)];
    backGround.backgroundColor = [UIColor whiteColor];
    self.tableView.clipsToBounds = NO;
    
    UIView *backGroundTwo = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 7, 1, 7, 150)];
    backGroundTwo.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:backGround];
    [self.tableView addSubview:backGroundTwo];
    
}
- (void)creatBtn{
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0, ScreenHeight - 50 - NavigationBarHeight - StateBarHeight -42,ScreenWidth -135, 50);
    [sureBtn setTitle:@"即时发货" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:BGBlue];
    sureBtn.tag = 388;
    sureBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn = sureBtn;
    [self.view addSubview:sureBtn];
    
    UIButton *yueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yueBtn.frame = CGRectMake((ScreenWidth - 135), ScreenHeight - NavigationBarHeight - StateBarHeight- 50- 42, 135, 50);
    [yueBtn setTitle:@"预约" forState:UIControlStateNormal];
    yueBtn.tag = 389;
    yueBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:22];
    [yueBtn setBackgroundColor:RGBA(105,181 ,240, 1)];
    [yueBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置button正常状态下的图片
    [yueBtn setImage:[UIImage imageNamed:@"icon_yuyueshijian"] forState:UIControlStateNormal];
    //设置button高亮状态下的背景图
    //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
    yueBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 60);
    //button标题的偏移量，这个偏移量是相对于图片的
    yueBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    _yueBtn = yueBtn;
    [self.view addSubview:yueBtn];

}
- (void)presentChooseTime{
    
    XZPickView *vc = [[XZPickView alloc] initWithFrame:[UIScreen mainScreen].bounds title:@"请选择"];
    vc.delegate = self;
    [vc show];
    
}
- (void)getDataFromConfirmButtonClick:(NSString *)selectDate{
    
    _selectDate = selectDate;
    [self postRequestData];
    
}
- (void)imageAndContent:(NSNotification*)noti{
    
    _photoName = [NSMutableArray array];
    NSDictionary *dic = noti.userInfo;
    _photoArr = [dic objectForKey:@"bigImgArr"];
    _text = [dic objectForKey:@"text"];
    
    if (_photoArr.count > 0) {
        for (int i = 0; i < _photoArr.count;i++) {
            NSString * keyStr = [NSDate getnowDate:@"YYYYMMddhhmmss"];
            NSString *key = [NSString stringWithFormat:@"OrderPhoto%@%@%d",userPhone,keyStr,i];
            [_photoName addObject:key];
            
        }
    }
   
}



- (void)chooseItem:(UIButton *)btn{
    
    [self titleClick:btn];
}

- (void)sureBtnClick:(UIButton *)button{
   
    if (button.tag == 388) {
        _tag = 388;
    }else if (button.tag == 389){
        
        _tag = 389;
    }
    
    //获取服务详情和货物详情
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sureOrderOne" object:nil];
    
        if (_photoArr.count > 0) {
            [self getUpVoucher];
            [self judgeParameter];
    
    
        }else{
            [self judgeParameter];
        }
    
}
- (void)judgeParameter{
    
    NSString *name = self.name;
    NSString *amount = self.number;
    NSString *packing = self.package;
    NSString *cargoType = @"";
    NSString *volume = self.volume;
    NSString *weight = self.weight;
    
    if (_startChoose.length <= 0) {
        
        [MBProgressHUD showError:@"寄件人地址不能为空"];

    }else if (_endChoose.length <= 0){
        
        [MBProgressHUD showError:@"收件人地址不能为空"];
        
    }else if (name.length <= 0){
        
         [MBProgressHUD showError:@"货物名字不能为空"];
    }else if (volume.length <= 0){
        
         [MBProgressHUD showError:@"货物体积不能为空"];
    }else if (amount.length <= 0){
        
        [MBProgressHUD showError:@"货物数量不能为空"];

    }else if (weight.length <= 0){
        
        [MBProgressHUD showError:@"货物重量不能为空"];

    }else if (packing.length <= 0){
        
        [MBProgressHUD showError:@"货物包装不能为空"];

    }else{
 
        if (_tag == 388) {
            
            [self postRequestData];
        }
        if (_tag == 389) {
            [self presentChooseTime];
        }
       
        
    }
}

- (void)postRequestData{
    
    NSDictionary *orderDic = @{@"volume":_volume,
                               @"number":_number,
                               @"weight":_weight,
                               @"package":_package,
                               @"evulteStr":_evulteStr,
                               @"money":_money,
                               @"typeStr":@"",
                               @"name":_name,
                               @"evulteNum":@(_evulteNum),
                               @"PaymentNum":@(_PaymentNum),
                               };

    
    JYHomeRequestDate *manager  = [JYHomeRequestDate shareInstance];
    manager.delegate = self;
    NSString *serviceStr = [self.serviceArr componentsJoinedByString:@","];
    if (serviceStr == nil || [serviceStr isEqual:[NSNull null]]) {
        serviceStr = @"";
    }
    NSString *timeNow = [NSDate  getnowDate:@"yyyy-MM-dd HH:mm:ss"];
    int timeType = 0;
    NSString *time = @"";
    
    if (_tag == 389) {
        timeType = 1;
        time = self.selectDate;
    }if (_tag == 388) {
        time =timeNow;
    }
    NSString *photoName =  [_photoName componentsJoinedByString:@","];
    if (photoName == nil || [photoName isEqual:[NSNull null]]) {
        photoName = @"";
    }
    [manager requsetCommitDedicatedOrder:@"app/logisticsorder/commitDedicatedOrder" evlue:orderDic service:serviceStr addressStr:_addressStrDic addressEnd:_addressEndDic describeContent:_text photo:photoName time:time timeType:@(timeType) nowTime:timeNow];
}

- (void)requestCommitDedicatedOrderSuccess:(NSDictionary *)resultDic{
    
    
    NSString *meaasge = [resultDic objectForKey:@"message"];
    if ([meaasge isEqualToString:@"500"]) {
        
    }else{
        [_photoName removeAllObjects];
        [_photoArr removeAllObjects];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"imageOrder"];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"textOrder"];

        JYWaitingAnimationViewController *valuationVC = [[JYWaitingAnimationViewController alloc] init];
        valuationVC.orderID = meaasge;
        valuationVC.startProvice = _startChoose;
        valuationVC.endProvice = _endChoose;
        valuationVC.orderDetailType = @"animation";
        [self.navigationController pushViewController:valuationVC animated:YES];
        
    }
    
    
}
- (void)requestCommitDedicatedOrderFailed:(NSError *)error{
    
//    [_photoName removeAllObjects];
//    [_photoArr removeAllObjects];

}

//从服务器获取上传七牛的token
- (void)getUpVoucher{
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/user/getUpVoucher"];
    
    [[NetWorkHelper shareInstance]Get:urlStr parameter:nil success:^(id responseObj) {
        
        NSString *voucher = [responseObj objectForKey:@"voucher"];
        
        
            for (NSInteger i = 0; i < _photoArr.count; i ++) {
                
                [self updateheadimage:voucher index:i];


        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
//上传图片到七牛
- (void)updateheadimage:(NSString *)str index:(NSInteger)index{
    
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone0];
    }];

    NSString * token = str;
    NSString *key = _photoName[index];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    NSData *data = [NSData imageData:_photoArr[index]];
   
    [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {

        if (index == _photoArr.count - 1) {
            
//            [self judgeParameter];
        }
       
    } option:nil];
    
}

#pragma mark - PSCityPickerViewDelegate
- (void)cityPickerView:(PSCityPickerView *)picker finishPickProvince:(NSString *)province city:(NSString *)city district:(NSString *)district ProvinceID:(NSString *)provinceID cityID:(NSString *)cityID districtID:(NSString *)districtID
{
   
    
    if (_btntag == 100) {
        
        _startChoose = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
        
        _addressStrDic = @{@"provinceID":provinceID,
                           @"cityID": cityID,
                           @"startChoose":_startChoose};

    }else if(_btntag == 101){

        _endChoose = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
        
        _addressEndDic = @{@"provinceID":provinceID,
                           @"cityID": cityID,
                           @"endChoose":_endChoose};
        
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
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

-(void)titleClick:(UIButton *)sender
{
    
    if (sender.tag==10) {

        [self showToView:@"专线" secondTitle:@"" btn:sender];
        
    }else if (sender.tag == 11){
        
        [self showToView:@"香港" secondTitle:@"澳门" btn:sender];
    
    }else{
        [self changeBtnColor:sender];
        sender.selected = YES;
        [sender setTitleColor:BGBlue forState:(UIControlStateSelected)];
    }
    
}
- (void)showToView:(NSString*)titleFirst secondTitle:(NSString *)secondTitle btn:(UIButton*)btn{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:titleFirst style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
 
    btn.selected = YES;
    [btn setTitle:action.title forState:UIControlStateNormal];
    [btn setTitleColor:BGBlue forState:(UIControlStateSelected)];
    [self changeBtnColor:btn];


}];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:secondTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

    [btn setTitle:action.title forState:UIControlStateNormal];
    btn.selected = YES;
    [btn setTitleColor:BGBlue forState:(UIControlStateSelected)];
    [self changeBtnColor:btn];


}];

UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [firstAction setValue:BGBlue forKey:@"_titleTextColor"];
    [secondAction setValue:BGBlue forKey:@"_titleTextColor"];
    [cancelAction setValue:RGBA(228, 122, 109, 1) forKey:@"_titleTextColor"];
    
    if (secondTitle.length > 0) {
        [alert addAction:secondAction];
    }
    [alert addAction:firstAction];
    [alert addAction:cancelAction];

    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;

    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)changeBtnColor:(UIButton *)btn{
    
    NSDictionary *dic = @{@"sender":btn};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeItem" object:nil userInfo:dic];

}
- (void)lookAddressClick:(UIButton *)button{
    
    _btntag = button.tag;
    [self.cityPicker showPickView];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.hidden = NO;
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    

    
    JYShipBaseViewController *baseOrderVC =(JYShipBaseViewController *)self.parentViewController;
    if ([baseOrderVC isKindOfClass:[JYShipBaseViewController class]]) {
        
        if ([baseOrderVC.whichType isEqualToString:@"specialLine"]) {
            
            _startChoose = baseOrderVC.detailModel.originatingSite;
            _endChoose = baseOrderVC.detailModel.destination;
            
            _addressEndDic = @{@"provinceID":baseOrderVC.detailModel.destinationProvince,
                               @"cityID": baseOrderVC.detailModel.destinationCity,
                               @"endChoose":_endChoose};
            
            _addressStrDic = @{@"provinceID":baseOrderVC.detailModel.originatingProvince,
                               @"cityID":baseOrderVC.detailModel.originatingCity,
                               @"startChoose":_startChoose};
            


        }
      
    }

}


- (void)keyboardWillShow:(NSNotification *)Notification
{
    [UIView animateWithDuration:1 animations:^{
        self.view.frame = CGRectMake(0, -201, ScreenWidth, ScreenHeight);

    }];
}

- (void)keyboardWillHide:(NSNotification *)Notification
{
    [self.view endEditing:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            
        }];
        //刷新UI
    });

   
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //刷新UI
        
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            
        }];
    });


}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 8;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0 ||section == 1 ||section == 3) {
        return 1;
    }else if (section == 2){
        return 5;
    }else if (section == 4){
        return 4;
    }else if (section == 5){
        return _evulteNum;
    }else if (section == 6){
        return _PaymentNum;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 ||section == 2 ||section == 4) {
        return 1;
    }else{
        return 9;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 150;
    }else if (indexPath.section == 1){
        return 44;
    }else if (indexPath.section == 2){
        return 44;
    }else{
        return 50;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cellDef = [tableView dequeueReusableCellWithIdentifier:@"cl"];
    if (!cellDef) {
        cellDef = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cl"];
    }
    
    if (indexPath.section == 0) {
        JYShipLineTableViewCell *cellLine = [JYShipLineTableViewCell cellWithTableView:tableView];
        cellLine.frame = CGRectMake(0, 0, ScreenWidth, 150);
        cellLine.startLabel.hidden =YES;
        cellLine.endLabel.hidden = YES;
        [cellLine.startLocationBtn setImage:[UIImage imageNamed:@"icon_dingwei"] forState:(UIControlStateNormal)];
        cellLine.startLocationBtn.hidden = YES;
        cellLine.lookStartAddressBtn.tag = 110;
        cellLine.lookEndAddressBtn.tag = 111;
        
        if (_startChoose.length > 0) {
            
            cellLine.startPlaehoder.textColor = RGB(102, 102, 102);
            cellLine.startPlaehoder.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
            cellLine.startPlaehoder.text = _startChoose;
        }
        if (_endChoose.length > 0) {
            
            cellLine.endPlaceHoder.text = @"请输入收件人地址";
            cellLine.endPlaceHoder.textColor = RGB(102, 102, 102);
            cellLine.endPlaceHoder.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
            cellLine.endPlaceHoder.text = _endChoose;
        }
        
        
        [cellLine.lookStartAddressBtn addTarget:self action:@selector(lookAddressClick:) forControlEvents:UIControlEventTouchUpInside];
        cellLine.lookStartAddressBtn.tag = 100;
        cellLine.lookEndAddressBtn.tag = 101;
        
        [cellLine.lookEndAddressBtn addTarget:self action:@selector(lookAddressClick:) forControlEvents:UIControlEventTouchUpInside];
        return cellLine;
    }else if (indexPath.section == 1){
        
        JYDescripeTableViewCell *cellDes = [JYDescripeTableViewCell cellWithTableView:tableView];
        cellDes.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cellDes.imgView.hidden = YES;
        cellDes.naemLabel.text = @"货物详情";
        cellDes.naemLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
        return cellDes;
        
    }else if (indexPath.section == 2){
        JYShipOrderDetailTableViewCell *cellOrd = [JYShipOrderDetailTableViewCell cellWithTableView:tableView];
        cellOrd.textField.delegate = self;
        cellOrd.textField.returnKeyType = UIReturnKeyDone;
        cellOrd.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cellOrd.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        NSDictionary *dic = @{NSForegroundColorAttributeName:RGBA(204, 204, 204, 1),NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:14]};
        
        cellOrd.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:dic];
       if (indexPath.row == 0){
            cellOrd.nameLabel.text = @"货物名称";
            cellOrd.textField.placeholder = @"电脑桌";
            cellOrd.textField.text = _name;
            cellOrd.textField.tag = 401;
            return cellOrd;
        }else if (indexPath.row == 1){
            cellOrd.nameLabel.text = @"体积m³       ";
            cellOrd.textField.keyboardType = UIKeyboardTypeDecimalPad;
            cellOrd.textField.placeholder = @"长 * 宽 * 高";
            cellOrd.textField.tag = 402;
            cellOrd.textField.text = _volume;
            return cellOrd;
        }else if (indexPath.row == 2){
            
            cellOrd.nameLabel.text = @"数量(件)     ";
            cellOrd.textField.placeholder = @"1";
            cellOrd.textField.keyboardType = UIKeyboardTypeNumberPad;
            cellOrd.textField.tag = 403;
            cellOrd.textField.text = _number;
        }else if (indexPath.row == 3){
            cellOrd.nameLabel.text = @"重量(kg)       ";
            cellOrd.textField.placeholder = @"1";
            cellOrd.textField.keyboardType = UIKeyboardTypeDecimalPad;
            cellOrd.textField.tag = 404;
            cellOrd.textField.text = _weight;
            
        }else {
            
            cellOrd.nameLabel.text = @"包装类型       ";
            cellOrd.textField.placeholder = @"木箱";
            cellOrd.textField.tag = 405;
            cellOrd.textField.text = _package;
            
        }
        return cellOrd;
        
    }else if (indexPath.section == 3){
        
        JYDescripeTableViewCell *cellDes = [JYDescripeTableViewCell cellWithTableView:tableView];
        cellDes.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cellDes.imgView.hidden = YES;
        cellDes.naemLabel.text = @"服务详情";
        cellDes.naemLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
        return cellDes;
        
    }else if (indexPath.section == 4){
        
        
        JYShipServicesTabcell *cell = [JYShipServicesTabcell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.serviceRightBtn addTarget:self action:@selector(serviceRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.servicesLeftBtn addTarget:self action:@selector(serviceRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self ServiceTypeForCell:cell row:indexPath];
        
        return cell;
        
    }else if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            JYSwitchTableViewCell *cell = [JYSwitchTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
            cell.nameLabel.text = @"是否投保";
            cell.switchBtn.tag = 320;
            
            [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            
            if (_evulteNum == 1) {
                cell.switchBtn.on = NO;
                
            }else{
                cell.switchBtn.on = YES;
                
                
            }
            return cell;
            
        }else{
            JYSwitchEvulteTableViewCell *cell = [JYSwitchEvulteTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.delegate = self;
            cell.nameLabel.font =[UIFont fontWithName:Default_APP_Font_Regu size:16];
            cell.nameLabel.textColor = RGBA(102, 102, 102, 1);
            cell.nameLabel.text = @"货物价值(元)";
            cell.textField.tag = 406;
            cell.textField.text = _evulteStr;
            [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            //            cell.evulteLabel.text = _evulteMoney;
            _evuleteCell = cell;
            return cell;
        }
        
    }else if (indexPath.section == 6){
        
        if (indexPath.row == 0) {
            JYSwitchTableViewCell *cell = [JYSwitchTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLabel.font =  [UIFont fontWithName:Default_APP_Font_Regu size:18];
            cell.nameLabel.text = @"代收货款";

            cell.switchBtn.tag = 321;
            
            [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            
            if (_PaymentNum == 1) {
                cell.switchBtn.on = NO;
                
            }else{
                cell.switchBtn.on = YES;
                
            }
            return cell;
            
        }else{
            JYSwitchEvulteTableViewCell *cell = [JYSwitchEvulteTableViewCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.equalLabel.hidden = YES;
            cell.evulteLabel.hidden =YES;
            cell.nameLabel.font =[UIFont fontWithName:Default_APP_Font_Regu size:16];
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.delegate = self;
            cell.textField.tag = 407;
            cell.textField.text =  _money;
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            
            [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            cell.nameLabel.textColor = RGBA(102, 102, 102, 1);
            cell.nameLabel.text = @"代收金额(元)";
            
            return cell;
        }
        
        
    }else if (indexPath.section == 7){
        
        JYDescripeTableViewCell *cell = [JYDescripeTableViewCell cellWithTableView:tableView];
        return cell;
    }
    return nil;
    
}

- (void)ServiceTypeForCell:(JYShipServicesTabcell *)cell row:(NSIndexPath*)indexPath{
    if (indexPath.row == 0 ) {
        [cell.servicesLeftBtn setTitle:@"  现金付款" forState:(UIControlStateNormal)];
        [cell.servicesLeftBtn setTitleColor:BGBlue  forState:(UIControlStateSelected)];
        cell.servicesLeftBtn.tag = 301;
        
        [cell.servicesLeftBtn setImage:[UIImage imageNamed:@"icon_xianjinfukuang_yuan"] forState:(UIControlStateNormal)];
        [cell.servicesLeftBtn setImage:[UIImage imageNamed:@"icon_xianjinfukuang_lanse"] forState:(UIControlStateSelected)];
        
        [cell.serviceRightBtn setTitle:@"  货到付款" forState:(UIControlStateNormal)];
        [cell.serviceRightBtn setTitleColor:BGBlue  forState:(UIControlStateSelected)];
        cell.serviceRightBtn.tag = 302;
        
        [cell.serviceRightBtn setImage:[UIImage imageNamed:@"icon_huodaofukuan_yuan"] forState:(UIControlStateNormal)];
        [cell.serviceRightBtn setImage:[UIImage imageNamed:@"icon_huodaofukuan_yuan_lanse"] forState:(UIControlStateSelected)];
        
    }else if (indexPath.row == 1){
        [cell.servicesLeftBtn setTitle:@"  送货上门" forState:(UIControlStateNormal)];
        [cell.servicesLeftBtn setTitleColor:BGBlue  forState:(UIControlStateSelected)];
        
        [cell.servicesLeftBtn setImage:[UIImage imageNamed:@"icon_songhuoshangmen_yuan"] forState:(UIControlStateNormal)];
        [cell.servicesLeftBtn setImage:[UIImage imageNamed:@"icon_songhuoshangmen_yuan_lanse"] forState:(UIControlStateSelected)];
        cell.servicesLeftBtn.tag = 303;
        cell.serviceRightBtn.tag = 304;
        
        [cell.serviceRightBtn setTitle:@"  保险      " forState:(UIControlStateNormal)];
        [cell.serviceRightBtn setTitleColor:BGBlue  forState:(UIControlStateSelected)];
        
        [cell.serviceRightBtn setImage:[UIImage imageNamed:@"icon_baoxiang_yuan"] forState:(UIControlStateNormal)];
        [cell.serviceRightBtn setImage:[UIImage imageNamed:@"icon_baoxiang_yuan_lanse"] forState:(UIControlStateSelected)];
        
        
        
    }else if (indexPath.row == 2){
        [cell.servicesLeftBtn setTitle:@"  签回单   " forState:(UIControlStateNormal)];
        [cell.servicesLeftBtn setTitleColor:BGBlue  forState:(UIControlStateSelected)];
        
        [cell.servicesLeftBtn setImage:[UIImage imageNamed:@"icon_qianhuidan_yuan"] forState:(UIControlStateNormal)];
        [cell.servicesLeftBtn setImage:[UIImage imageNamed:@"icon_qianhuidan_yuan_lanse"] forState:(UIControlStateSelected)];
        cell.servicesLeftBtn.tag = 305;
        cell.serviceRightBtn.tag = 306;
        
        [cell.serviceRightBtn setTitle:@"  月结      " forState:(UIControlStateNormal)];
        [cell.serviceRightBtn setTitleColor:BGBlue  forState:(UIControlStateSelected)];
        
        [cell.serviceRightBtn setImage:[UIImage imageNamed:@"icon_yuejie_yuan"] forState:(UIControlStateNormal)];
        [cell.serviceRightBtn setImage:[UIImage imageNamed:@"icon_yuejie_yuan_lanse"] forState:UIControlStateSelected];
        
        
        
    }else if (indexPath.row == 3){
        [cell.servicesLeftBtn setTitle:@"  快运      " forState:(UIControlStateNormal)];
        [cell.servicesLeftBtn setTitleColor:BGBlue  forState:(UIControlStateSelected)];
        
        [cell.servicesLeftBtn setImage:[UIImage imageNamed:@"icon_kuaiyun_yuan"] forState:(UIControlStateNormal)];
        [cell.servicesLeftBtn setImage:[UIImage imageNamed:@"icon_kuaiyun_yuan_lanse"] forState:(UIControlStateSelected)];
        cell.servicesLeftBtn.tag = 307;
        
        cell.serviceRightBtn.tag = 308;
        
        [cell.serviceRightBtn setTitle:@"  普通货运" forState:(UIControlStateNormal)];
        [cell.serviceRightBtn setTitleColor:BGBlue  forState:(UIControlStateSelected)];
        
        [cell.serviceRightBtn setImage:[UIImage imageNamed:@"icon_putongfahuo"] forState:(UIControlStateNormal)];
        [cell.serviceRightBtn setImage:[UIImage imageNamed:@"icon_putongfahuo_lanse"] forState:(UIControlStateSelected)];
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 7) {
        
        JYSendDescriptionViewController *vc = [[JYSendDescriptionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }
}
- (void)textFieldDidChange:(UITextField *)textField{
    
    
    switch (textField.tag) {
            
        case 401:
            _name = textField.text;
            break;
        case 402:
            _volume = textField.text;
            break;
        case 403:
            _number = textField.text;
            
            break;
        case 404:
            _weight = textField.text;
            
            break;
        case 405:
            
            _package = textField.text;
            
            break;
        case 406:{
            
            _evulteStr = textField.text;
            double evulteNum = [_evulteStr doubleValue];
            double evulteMoney = evulteNum * 0.004;
            _evulteMoney = [NSString stringWithFormat:@"%.1f",evulteMoney];
            _evuleteCell.evulteLabel.text = _evulteMoney;
            
        }
            break;
        case 407:
            _money = textField.text;
            [self saveDateNickname:_money];
            
            break;
        default:
            break;
    }
    
    
}

- (void)serviceRightBtnClick:(UIButton *)button{
    
    button.selected = !button.selected;
    
    
    switch (button.tag) {
        case 301:
            
            [self selectWhichService:@"1" btn:button];
            
            break;
        case 302:
            [self selectWhichService:@"2" btn:button];
            
            break;
        case 303:
            [self selectWhichService:@"3" btn:button];
            
            break;
        case 304:
            [self selectWhichService:@"4" btn:button];
            
            break;
        case 305:
            [self selectWhichService:@"5" btn:button];
            
            break;
        case 306:
            [self selectWhichService:@"6" btn:button];
            
            break;
        case 307:
            [self selectWhichService:@"7" btn:button];
            
            break;
        case 308:
            [self selectWhichService:@"8" btn:button];
            
            break;
        default:
            break;
    }
    
}
- (void)selectWhichService:(NSString *)service btn:(UIButton *)button{
    
    if (button.selected) {
        [_serviceArr addObject:service];
    }else{
        [_serviceArr removeObject:service];
    }
    
}

-(void)switchAction:(UISwitch*)sender
{
    if (sender.tag == 320) {
        if (sender.on) {
            NSLog(@"开");
            _evulteNum = 2;
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:5];
            [indexPaths addObject: indexPath];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:5];
            [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
        }else {
            
            NSLog(@"关");
            _evulteNum = 1;
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:5];
            [indexPaths addObject: indexPath];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:5];
            
            [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
        }
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:5];
//        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
     

    }if (sender.tag == 321) {
        if (sender.on) {
            NSLog(@"开");
            _PaymentNum = 2;
            
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:6];
            [indexPaths addObject: indexPath];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:6];
            [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
        }else {
            
            NSLog(@"关");
            _PaymentNum = 1;
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:6];
            [indexPaths addObject: indexPath];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:6];
            
            [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
            
        }
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:6];
//        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}
- (BOOL)saveDateNickname:(NSString *)nickname {
    //    ^[0-9]+(.[0-9]{2})?$
    NSString *regex =@"^(([0-9]|([1-9][0-9]{0,9}))((\\.[0-9]{1,2})?))$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL  inputString = [predicate evaluateWithObject:nickname];
    return inputString;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 402 || textField.tag == 404 || textField.tag == 406 || textField.tag == 407) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        //首位不能为.号
        if (range.location == 0 && [string isEqualToString:@"."]) {
            return NO;
        }
        return [self isRightInPutOfString:textField.text withInputString:string range:range];
        return NO;
        
    }else if(textField.tag == 403){
        
        NSString *passWordRegex = @"^[0-9]*$";
        NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
        
        if (![passWordPredicate evaluateWithObject:string]) {
            return NO;
            
        }else{
            
            return YES;
        }
        
    }else{
        return YES;
    }
    
}
- (BOOL)isRightInPutOfString:(NSString *) string withInputString:(NSString *) inputString range:(NSRange) range{
    //判断只输出数字和.号
    NSString *passWordRegex = @"[0-9\\.]";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    if (![passWordPredicate evaluateWithObject:inputString]) {
        return NO;
    }
    //逻辑处理
    if ([string containsString:@"."]) {
        if ([inputString isEqualToString:@"."]) {
            return NO;
        }
        NSRange subRange = [string rangeOfString:@"."];
        if (range.location - subRange.location > 2) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (textField.tag == 406) {
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
    return YES;
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"keyBoardShow" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"keyBoardHide" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"imageAndContent" object:nil];



}
@end
