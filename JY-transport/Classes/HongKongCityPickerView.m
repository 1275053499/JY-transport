//
//  HongKongCityPickerView.m
//  JY-transport
//
//  Created by 闫振 on 2017/10/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "HongKongCityPickerView.h"


#define PS_CITY_PICKER_COMPONENTS 2
#define PROVINCE_COMPONENT        0
#define CITY_COMPONENT            1
#define DISCTRCT_COMPONENT        2

#define FIRST_INDEX               0


#define COMPONENT_WIDTH 160 //每一列的宽度

@interface HongKongCityPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic, copy, readwrite) NSString *province;
@property (nonatomic, copy, readwrite) NSString *city;
@property (nonatomic, copy, readwrite) NSString *district;

@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *mainView;


@property (nonatomic,strong)NSArray *allProvinceInfo;

@property (nonatomic,strong)NSString  *provinceID;
@property (nonatomic,strong)NSString  *cityID;
@property (nonatomic,strong)NSString *districtID;
@property (nonatomic,strong)NSArray *arrayCity;

@end

@implementation HongKongCityPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.mainView.frame = frame;
        
        self.frame = CGRectMake(12, 50,frame.size.width - 24 , frame.size.height - 50);
        self.delegate = self;
        self.dataSource = self;
        [self setupChildViews];
        
    }
    return self;
}

- (void)setupChildViews {
   
    
//    self.province = @"北京";
//    self.city = @"北京";
//    self.district = @"东城区";
//
//    self.provinceID = @"2";
//    self.cityID = @"33";
//    self.districtID = @"378";
    self.bgBtn.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.bgBtn addSubview:self.mainView];
    
    _arrayCity = @[@"九龙",@"新界",@"港岛"];
    [self.mainView addSubview:self];
    self.cancelBtn.frame = CGRectMake(12, 0, 50, 50);
    self.confirmBtn.frame = CGRectMake(ScreenWidth -86,0 ,50 ,50);
    [self.mainView addSubview:self.cancelBtn];
    [self.mainView addSubview:self.confirmBtn];
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.mainView.bounds cornerRadius:5];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.mainView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.mainView.layer.mask = maskLayer;
    
    [self selectRow:0 inComponent:0 animated:YES];
    [self pickerView:self didSelectRow:0 inComponent:0];

}

- (void)showPickView{
    
    [self reloadAllComponents];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgBtn];
    
    [UIView animateWithDuration:0.6 animations:^{
        
        _bgBtn.alpha = 1;
        
        
    }];
    
    
}
- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
    }
    return _mainView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:BGBlue forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn sizeToFit];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:BGBlue forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_confirmBtn sizeToFit];
        
    }
    return _confirmBtn;
}
- (void)cancelAction:(UIButton *)btn {
    [self dismiss:btn];
    
}

- (void)confirmAction:(UIButton *)btn {
    [self dismiss:btn];
    
    if ([self.hongkongDelegate respondsToSelector:@selector(HongKongCityPickerView:finishPickProvince:city:)]) {
        [self.hongkongDelegate HongKongCityPickerView:self finishPickProvince:self.province city:self.city];
    }
}
- (void)dismiss:(UIButton *)btn {
    _bgBtn.alpha = 1;
    [UIView animateWithDuration:0.6 animations:^{
        
        _bgBtn.alpha = 0;
        
    } completion:^(BOOL finished) {
        [_bgBtn removeFromSuperview];
        
    }];
}
- (UIButton *)bgBtn {
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] init];
        _bgBtn.backgroundColor = [UIColor blackColor];
        _bgBtn.backgroundColor = RGBA(0, 0, 0, 0.3);
        [_bgBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}
#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    //包含2列
    return 2;
}

//该方法返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{ switch (component)
    {
        case 0:     return 1;
        case 1:     return _arrayCity.count;
        case 2:     return 1;
    }
    return 0;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLabel = (UILabel *)view;
    if (!titleLabel)
    {
        titleLabel = [self labelForPickerView];
    }
    titleLabel.text = [self titleForComponent:component row:row];
    return titleLabel;
    
}

//选择指定列、指定列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0){
       
        self.province = @"香港特别行政区";
        self.city = _arrayCity[0];
        [pickerView selectRow:FIRST_INDEX inComponent:1 animated:NO];
        [pickerView reloadAllComponents];
        
        
    }else {
        
        self.province = @"香港特别行政区";
        self.city = _arrayCity[row];
    }
    
}

//指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // 宽度
    return (ScreenWidth - 50)/3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 40;
}
#pragma mark - Private
- (UILabel *)labelForPickerView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    label.textColor = [UIColor colorWithRed:85/255 green:85/255 blue:85/255 alpha:1];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}

- (NSString *)titleForComponent:(NSInteger)component row:(NSInteger)row;
{
    
    switch (component)
    {
        case 0: return @"香港特别行政区";
        case 1: return _arrayCity[row];
        case 2: return @"";
    }
    return @"";
    
}


// 获取所有省份的数组
- (NSArray *)allProvinceInfo
{
    if (!_allProvinceInfo)
    {
        NSBundle *bundle=[NSBundle mainBundle];
        NSString *path=[bundle pathForResource:@"allCitoy" ofType:@"plist"];
        _allProvinceInfo = [[NSArray alloc]initWithContentsOfFile:path];
        
    }
    return _allProvinceInfo;
}

@end

