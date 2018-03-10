//
//  PSCityPickerView.m
//  Diamond
//
//  Created by Pan on 15/8/12.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PSCityPickerView.h"

#define PS_CITY_PICKER_COMPONENTS 2
#define PROVINCE_COMPONENT        0
#define CITY_COMPONENT            1
#define DISCTRCT_COMPONENT        2

#define FIRST_INDEX               0


#define COMPONENT_WIDTH 160 //每一列的宽度

@interface PSCityPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic, copy, readwrite) NSString *province;
@property (nonatomic, copy, readwrite) NSString *city;
@property (nonatomic, copy, readwrite) NSString *district;


@property (nonatomic, copy) NSArray *provinceArr;/**< 省名称数组*/
@property (nonatomic, copy) NSArray *cityArr;/**< 市名称数组*/
@property (nonatomic, copy) NSArray *districtArr;/**< 区名称数组*/


@property (nonatomic, copy) NSDictionary *currentProvinceDic;
@property (nonatomic, copy) NSDictionary *currentCityDic;

@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *mainView;


@property (nonatomic,strong)NSArray *allProvinceInfo;
@property (nonatomic,strong)NSArray *allCityArr;

@property (nonatomic,strong)NSString  *provinceID;
@property (nonatomic,strong)NSString  *cityID;
@property (nonatomic,strong)NSString *districtID;

@end

@implementation PSCityPickerView

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
    if (_ComponentNum == 0 ) {
        _ComponentNum = 2;
    }
    
    self.province = @"北京";
    self.city = @"北京";
    self.district = @"东城区";
    
    self.provinceID = @"2";
    self.cityID = @"33";
    self.districtID = @"378";
    self.bgBtn.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.bgBtn addSubview:self.mainView];
    
    
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
    
    if ([self.cityPickerDelegate respondsToSelector:@selector(cityPickerView:finishPickProvince:city:district:ProvinceID:cityID:districtID:)])
    {
        [self.cityPickerDelegate cityPickerView:self finishPickProvince:self.province city:self.city district:self.district ProvinceID:self.provinceID cityID:self.cityID districtID:self.districtID];
        
        NSLog(@"province=====%@       city=====%@       district=====%@",self.province,self.city,self.district);
        NSLog(@"provinceID=====%@     cityID=====%@       districtID=====%@",self.provinceID,self.cityID,self.districtID);
        
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
    return _ComponentNum;
}

//该方法返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{ switch (component)
    {
        case 0:     return [self.provinceArr count];
        case 1:     return [self.cityArr count];
        case 2:     return [self.districtArr count];
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
        NSDictionary *provinceDic = [self provinceDicAtIndex:row];
        NSArray *cityNames = [self cityNamesInProvinceDic:provinceDic];
        _currentProvinceDic = provinceDic;
        self.cityArr = cityNames;
        NSDictionary *cityDic = [self provinceDic:provinceDic cityDicAtIndex:0];
        _currentCityDic = cityDic;

        NSArray *districtNames = [self districtArrayInCityDic:cityDic];

        
        self.province = [self provinceNameWithPrivinceDic:provinceDic];
        self.city = [[self cityNamesInProvinceDic:provinceDic] firstObject];
        

        
        self.provinceID = [self provinceIDWithPrivinceDic:provinceDic];
        self.cityID = [self cityidWithCityDic:self.currentCityDic];
        
        if (_ComponentNum == 3) {
            self.districtArr = districtNames;
            self.district = [self.districtArr firstObject];
            NSArray *distrctArr = [self.currentCityDic objectForKey:@"nodesList"];
            NSDictionary *distrcDic = distrctArr[0];
            self.districtID = [distrcDic objectForKey:@"regionId"];
            
            [pickerView selectRow:FIRST_INDEX inComponent:2 animated:NO];

        }
        
        
        
        [pickerView selectRow:FIRST_INDEX inComponent:1 animated:NO];

        
        [pickerView reloadAllComponents];

        
    }else if (component == 1){
        
    
        NSDictionary *cityDic = [self provinceDic:self.currentProvinceDic cityDicAtIndex:row];
        self.currentCityDic = cityDic;
        
        self.province = [self provinceNameWithPrivinceDic:self.currentProvinceDic];
        
        self.city = [self cityNameWithCityDic:cityDic];
        
        self.provinceID = [self provinceIDWithPrivinceDic:self.currentProvinceDic];
        
        self.cityID = [self cityidWithCityDic:cityDic];
        
        if (_ComponentNum == 3) {
            
            NSArray *distrctArr = [cityDic objectForKey:@"nodesList"];
            NSDictionary *distrcDic = distrctArr[0];
            self.districtID = [distrcDic objectForKey:@"regionId"];
            
            self.districtArr = [self districtArrayInCityDic:cityDic];
            self.district = [self.districtArr firstObject];
            
            [pickerView selectRow:FIRST_INDEX inComponent:2 animated:NO];
            
        }
        

        [pickerView reloadAllComponents];
        
        
        
    }else if (component == 2)
    {
        self.province = [self provinceNameWithPrivinceDic:self.currentProvinceDic];
        
        self.city = [self cityNameWithCityDic:self.currentCityDic];
        
        
        if (_ComponentNum == 3) {
            
            self.district = [self.districtArr objectAtIndex:row];
            self.districtID = [self cityidWithCityDic:self.currentCityDic];
            
            NSArray *distrctArr = [ self.currentCityDic objectForKey:@"nodesList"];
            NSDictionary *distrcDic = distrctArr[row];
            self.districtID = [distrcDic objectForKey:@"regionId"];
            
        }

        
    }
    
}


//指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // 宽度
    return _ComponentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return _ComponentRowheight;
}
#pragma mark - Private
- (UILabel *)labelForPickerView
{
    UILabel *label = [[UILabel alloc] init];
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
        case 0: return [self.provinceArr objectAtIndex:row];
        case 1: return [self.cityArr objectAtIndex:row];
        case 2: return [self.districtArr objectAtIndex:row];
    }
    return @"";
    
}

/**
 *  获取省级字典
 *
 *  @param index
 *
 *  @return 省级字典
 */
- (NSDictionary *)provinceDicAtIndex:(NSUInteger)index;
{
    
    NSDictionary *dic = self.allProvinceInfo[index];
    
    return dic;
}

/**
 *  返回省级字典的名字
 *
 *  @param privinceDic 省级字典
 *
 *  @return NSString
 */
- (NSString *)provinceNameWithPrivinceDic:(NSDictionary *)provinceDic
{
    return [provinceDic objectForKey:@"regionName"];
}
//返回省级字典ID

- (NSString *)provinceIDWithPrivinceDic:(NSDictionary *)provinceDic
{
    NSNumber *proviceID = [provinceDic objectForKey:@"regionId"];
    NSString *str = [NSString stringWithFormat:@"%@",proviceID];
    return str;
}


/**
 *  返回省级字典下面的市名称数组
 *
 *  @param privinceDic 省级字典
 *
 *  @return NSArray<NSString>
 */
- (NSArray *)cityNamesInProvinceDic:(NSDictionary *)provinceDic
{
    //市的数组
    NSArray *city = [provinceDic objectForKey:@"nodesList"];
    NSMutableArray *cityArr = [NSMutableArray array];
    
    for (NSDictionary *dic in city) {
        
        NSString *cityStr = [dic objectForKey:@"regionName"];
        [cityArr addObject:cityStr];
    }
    _cityArr = cityArr;
    
    
    return _cityArr;
}

/**
 *  获取省级字典下的市级字典
 *
 *  @param privinceDic 省级字典
 *  @param index
 *
 *  @return 市级字典
 */
- (NSDictionary *)provinceDic:(NSDictionary *)provinceDic cityDicAtIndex:(NSUInteger)index;
{
    //市的数组
    NSArray *city = [provinceDic objectForKey:@"nodesList"];
    
    NSDictionary *cityDicInProvince = city[index];
    
    return cityDicInProvince;
}

/**
 *  返回市级字典的市名称
 *
 *  @param cityDic 市级字典
 *
 *  @return NSSting
 */
- (NSString *)cityNameWithCityDic:(NSDictionary *)cityDic
{
    return  [cityDic objectForKey:@"regionName"];
}

- (NSString *)cityidWithCityDic:(NSDictionary *)cityDic
{
    return  [cityDic objectForKey:@"regionId"];
}
/**
 *  返回市级字典下的区/县信息
 *
 *  @param cityDic 市级字典
 *
 *  @return NSArray<NSString>
 */
- (NSArray *)districtArrayInCityDic:(NSDictionary *)cityDic
{
    
    NSArray *distrctArr = [cityDic objectForKey:@"nodesList"];
    NSMutableArray *cityArr = [NSMutableArray array];
    
    for (NSDictionary *dic in distrctArr) {
        
        NSString *cityStr = [dic objectForKey:@"regionName"];
        [cityArr addObject:cityStr];
    }
    _districtArr = cityArr;
    
    return _districtArr;
}

#pragma mark - Getter and Setter
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
//省名称数组
- (NSArray *)provinceArr
{
    if (!_provinceArr)
    {
        NSMutableArray *temp = [NSMutableArray array];
        for (NSInteger i = 0 ; i < self.allProvinceInfo.count; i++)
        {
            NSDictionary *provenceDic = self.allProvinceInfo [i];
            NSString *regionName = [provenceDic objectForKey:@"regionName"];
            [temp addObject:regionName];
            
        }
        _provinceArr = temp;
    }
    return _provinceArr;
}
//市名称数组
- (NSArray *)cityArr
{
    if (!_cityArr)
    {
        NSDictionary *provinceDic = [self provinceDicAtIndex:FIRST_INDEX];
        _cityArr = [self cityNamesInProvinceDic:provinceDic];
        
    }
    return _cityArr;
    
}
- (NSArray *)districtArr
{
    if (!_districtArr)
    {
        NSDictionary *cityDic = [self provinceDic:[self provinceDicAtIndex:FIRST_INDEX] cityDicAtIndex:FIRST_INDEX];
        _districtArr = [self districtArrayInCityDic:cityDic];
    }
    return _districtArr;
}
- (NSDictionary *)currentProvinceDic
{
    if (!_currentProvinceDic) {
        _currentProvinceDic = [self provinceDicAtIndex:FIRST_INDEX];
    }
    return _currentProvinceDic;
}

- (NSDictionary *)currentCityDic
{
    if (!_currentCityDic) {
        _currentCityDic = [self provinceDic:self.currentProvinceDic cityDicAtIndex:FIRST_INDEX];
    }
    return _currentCityDic;
}
@end
