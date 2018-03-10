//
//  DatePickerSelectView.m
//  JY-transport
//
//  Created by 闫振 on 2017/12/7.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "DatePickerSelectView.h"
#import "NSDate+Date.h"

@interface DatePickerSelectView () <UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIView *mainView;


//设置日期最大最小年限
@property(nonatomic,assign) NSInteger maxYear;
@property(nonatomic,assign) NSInteger minYear;
//数据源数组
@property (strong, nonatomic) NSMutableArray *yearArray;//年
@property (strong, nonatomic) NSMutableArray *monthArray;//月
@property (strong, nonatomic) NSMutableArray *dayArray;//日
//记录位置
@property (assign, nonatomic)NSInteger yearIndex;
@property (assign, nonatomic)NSInteger monthIndex;
@property (assign, nonatomic)NSInteger dayIndex;
//当前年月日
@property (copy, nonatomic) NSString *currentYear;
@property (copy, nonatomic) NSString *currentMonth;
@property (copy, nonatomic) NSString *currentDay;
@property (nonatomic,strong)NSString *nowDay;
@property (nonatomic,strong)NSString *nowMonth;

@end

@implementation DatePickerSelectView

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
    
    [self initData];// 初始化数据
    [self showCurrentDate];// 显示当前日期
    
}

- (void)showPickView{
    
    [self reloadAllComponents];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgBtn];
    
    [UIView animateWithDuration:0.45 animations:^{
        
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
    
    if ([self.datePickerDelegate respondsToSelector:@selector(datePickerViewSelect:)]) {
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",_currentYear,_currentMonth,_currentDay];
        [self.datePickerDelegate datePickerViewSelect:dateStr];
    }
    
}
- (void)dismiss:(UIButton *)btn {
//    _bgBtn.alpha = 1;
    [UIView animateWithDuration:0.45 animations:^{
        
        _bgBtn.alpha = 0;
        
    } completion:^(BOOL finished) {
        [_bgBtn removeFromSuperview];
        
    }];
}
- (UIButton *)bgBtn {
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] init];
        _bgBtn.backgroundColor = [UIColor blackColor];
        _bgBtn.backgroundColor = RGBA(0, 0, 0, 0.2);
        [_bgBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}
#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 3;
}

//该方法返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component){
        case 0:     return [self.yearArray count];
        case 1:     return [self.monthArray count];
        case 2:     return [self.dayArray count];
    }
    return 0;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
        UILabel* pickerLabel = (UILabel*)view;
        if (!pickerLabel){
            pickerLabel = [[UILabel alloc] init];
            pickerLabel.adjustsFontSizeToFitWidth = YES;
            pickerLabel.textAlignment = NSTextAlignmentCenter;
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            pickerLabel.textColor =  [UIColor colorWithRed:85/255 green:85/255 blue:85/255 alpha:1];
            [pickerLabel setFont:[UIFont fontWithName:Default_APP_Font_Regu size:17]];
        }
        pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        return pickerLabel;
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component)
    {
        case 0:     return self.yearArray[row];
        case 1:     return self.monthArray[row];
        case 2:     return self.dayArray[row];
    }
    return 0;
}

//选择指定列、指定列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _yearIndex = row;
        self.currentYear = [self.yearArray objectAtIndex:row];
    }
    if (component == 1) {
        _monthIndex = row;
        self.currentMonth = [self.monthArray objectAtIndex:row];
    }
    if (component == 2) {
        _dayIndex = row;
        self.currentDay = [self.dayArray objectAtIndex:row];
    }
    
    if (component == 0 || component == 1){
        // 根据年月 确定天数
        [self daysfromYear:[_yearArray[_yearIndex] integerValue] andMonth:[_monthArray[_monthIndex] integerValue]];
        
        if ([_currentMonth isEqualToString: _nowMonth]) {
            [self setdayArray:[_nowDay integerValue]];
        }
        
        // 刷新天数列表
        [self reloadComponent:2];
        // 由于天数是变动的，需刷新当前天数保存在_currentDay中
        NSInteger dayIndex = [self selectedRowInComponent:2];
        self.currentDay = self.dayArray[dayIndex];
    }
    
}


//指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // 宽度
    return (ScreenWidth -50)/3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 40;
}
#pragma mark - Private

-(void)initData{
    self.maxYear = [[self getCurrentYear] integerValue];
    self.minYear = 2017;
    
    self.yearArray = [[NSMutableArray alloc] init];
    self.monthArray = [[NSMutableArray alloc] init];
    self.dayArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = _minYear; i < _maxYear + 1; i++) {
        NSString *num = [NSString stringWithFormat:@"%zd",i];
        [_yearArray addObject:num];
    }
    for (int i=0; i<30; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (i>0 && i<=12) [_monthArray addObject:num];
        if (i>0) {
            [_dayArray addObject:num];
        }
    }
}

/** 获取当前年 */
- (NSString *)getCurrentYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:[NSDate date]];
    return year;
}


/** 显示当前日期 */
-(void)showCurrentDate{
    
    NSString *date = [NSDate stringWithDate:[NSDate date]];
    NSString *dateStr = [date substringToIndex:10];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    self.currentYear = dateArr[0];
    self.currentMonth = dateArr[1];
    self.currentDay = dateArr[2];
    _nowMonth =  dateArr[1];
    _nowDay = dateArr[2];
    // 确定年 和 月
    _yearIndex= [self.yearArray indexOfObject:self.currentYear];
    _monthIndex = [self.monthArray indexOfObject:self.currentMonth];
    // 根据当前年月确定天数
    //    NSInteger currentMonthDays =  [self daysfromYear:[_yearArray[_yearIndex] integerValue] andMonth:[_monthArray[_monthIndex] integerValue]];
    [self setdayArray:[self.currentDay integerValue]];
    _dayIndex = [self.dayArray indexOfObject:self.currentDay];
    // 滚动到当前日期
    [self selectRow:_yearIndex inComponent:0 animated:YES];
    [self selectRow:_monthIndex inComponent:1 animated:YES];
    [self selectRow:_dayIndex inComponent:2 animated:YES];
    // 刷新天数
    [self reloadComponent:2];
}

/** 通过年月求每月天数 */
- (NSInteger)daysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
        }
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

/** 设置每月的天数数组 */
- (void)setdayArray:(NSInteger)num
{
    [_dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}


@end
