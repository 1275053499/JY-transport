//
//  XZPickView.m
//  XZPickView
//
//  Created by 赵永杰 on 17/3/24.
//  Copyright © 2017年 zhaoyongjie. All rights reserved.
//

#import "XZPickView.h"
#import "UIView+Category.h"

// 屏幕宽度
#define kScreenW [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define XZColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]

@interface XZPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIView *naviContainView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIPickerView *pickView;

@property (nonatomic, strong) UIButton *bgBtn;

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic,strong)UIView *blackView;

@property (nonatomic,strong)UIView *blackVie;
@property (nonatomic,copy) NSDictionary * dateDic;
@property (nonatomic,copy) NSString * weekStr;
@property (nonatomic,copy) NSString * timeStr;
@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic, assign) NSInteger currentSelectDay;
//@property (nonatomic,strong)UILabel *yearLabel;
@property (nonatomic,strong)NSDate *selectDateTime;
@end

@implementation XZPickView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildViews];
        self.titleLabel.text = title;
    }
    return self;
}

- (void)setupChildViews {
    
    [self addSubview:self.bgBtn];
    [self addSubview:self.mainView];
    
    [self.naviContainView addSubview:self.cancelBtn];
    [self.naviContainView addSubview:self.titleLabel];
    [self.naviContainView addSubview:self.confirmBtn];
    [self.pickView addSubview:self.blackView];
    [self.pickView addSubview:self.blackVie];
    self.pickView.backgroundColor = [UIColor clearColor];
    //  [self.mainView addSubview:self.yearLabel];
    [self.mainView addSubview:self.naviContainView];
    [self.mainView addSubview:self.pickView];
    
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.mainView setFrame:CGRectMake(8, kScreenH, kScreenW -16, 220)];
    
    //    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(12);
    //        make.right.mas_equalTo(-12);
    //        make.height.mas_equalTo(220);
    //        make.bottom.mas_equalTo(self.bottom).mas_offset(-5);
    //    }];
    [_mainView rounded:5.0];
    
    
    [self.naviContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.mainView);
        make.height.mas_equalTo(45);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(self.naviContainView);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(45);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.naviContainView);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(self.naviContainView);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(45);
        
    }];
    
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviContainView.bottom +30);
        make.left.right.bottom.equalTo(self.mainView);
    }];
    
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-112.5);
        make.height.mas_equalTo(@0.5);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    [self.blackVie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-77);
        make.height.mas_equalTo(@0.5);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    //    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.mas_equalTo(0);
    //        make.top.mas_equalTo(self.naviContainView.bottom + 25);
    //        make.left.mas_equalTo(0);
    //        make.right.mas_equalTo(0);
    //    }];
    
    
    
}

#pragma mark - private methods

- (void)cancelAction:(UIButton *)btn {
    [self dismiss:btn];
    
}

- (void)confirmAction:(UIButton *)btn {
    [self dismiss:btn];
    
//    NSInteger left = [_pickView selectedRowInComponent:0];
//    NSInteger right = [_pickView selectedRowInComponent:1];
//    self.selectDate = [[self.dateDic[@"time"] objectAtIndex:left] objectAtIndex:right];
      NSString *selectDateStr = [self XZGetTimeStringWithDate:self.selectDateTime dateFormatStr:@"yyyy-MM-dd HH:mm:ss"];
    if ([self.delegate respondsToSelector:@selector(getDataFromConfirmButtonClick:)]) {
        [self.delegate getDataFromConfirmButtonClick:selectDateStr];
        
        NSLog(@"select date = %@",selectDateStr);
    }
}

#pragma mark - public methods

- (void)show {
    _currentSelectDay = 0;
    NSLog(@"%s",__func__);
    self.dateDic = [self LHGetStartTime];
    self.weekStr = self.dateDic[@"week"][0];
    NSDate *date  = [[self.dateDic[@"time"] objectAtIndex:0] objectAtIndex:0];
    _selectDateTime = date;
    
    self.timeStr = [self XZGetTimeStringWithDate:date dateFormatStr:@"HH:mm"];
    [self.pickView reloadAllComponents];
    //[self.userNumPickView selectRow:0 inComponent:0 animated:NO];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    self.bgBtn.alpha = 0.3;
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.y = kScreenH - 225;
    }];
}

- (void)dismiss:(UIButton *)btn {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.y = kScreenH;
        self.bgBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self.pickView removeFromSuperview];
        self.pickView = nil;
        [self removeFromSuperview];
    }];
}

- (NSDictionary *)LHGetStartTime {
    // 获取当前date
    NSDate *date = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDictionary *weekDict = @{@"2" : @"周一", @"3" : @"周二", @"4" : @"周三", @"5" : @"周四", @"6" : @"周五", @"7" : @"周六", @"1" : @"周日"};
    // 日期格式
    NSDateFormatter *fullFormatter = [[NSDateFormatter alloc] init];
    fullFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    // 获取当前几时(晚上23点要把今天的时间做处理)
    NSInteger currentHour = [calendar component:NSCalendarUnitHour fromDate:date];
    // 存放周几和时间的数组
    NSMutableArray *weekStrArr = [NSMutableArray array];
    NSMutableArray *detailTimeArr = [NSMutableArray array];
    // 设置合适的时间
    for (int i = 0; i < 3; i++) {
        NSDate *new = [calendar dateByAddingUnit:NSCalendarUnitDay value:i toDate:date options:NSCalendarMatchStrictly];
        NSInteger week = [calendar component:NSCalendarUnitWeekday fromDate:new];
        // 周几
        NSString *weekStr = weekDict[[NSString stringWithFormat:@"%ld",week]];
        NSString *todayOrOther = @"";
        if (i == 0) {
            todayOrOther = @"今天";
        }else if (i == 1) {
            todayOrOther = @"明天";
        }else if (i == 2){
            todayOrOther = @"后天";
        }
        
        NSInteger year = [calendar component:NSCalendarUnitYear fromDate:new];
        NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:new];
        NSInteger day = [calendar component:NSCalendarUnitDay fromDate:new];
        //       NSString *yserStr = [NSString stringWithFormat:@"%ld",year];
        //        self.yearLabel.text = yserStr;
        
        // 今天周几 明天周几 后天周几
        NSString *resultWeekStr = [NSString stringWithFormat:@"%ld月%ld日 %@",(long)month,(long)day,todayOrOther];
        if (i != 0) {
            
            resultWeekStr = [NSString stringWithFormat:@"%ld月%ld日 %@",(long)month,(long)day,weekStr];
            
        }
        [weekStrArr addObject:resultWeekStr];
        
        // 把符合条件的时间筛选出来
        NSMutableArray *smallArr = [NSMutableArray array];
        for (int hour = 0; hour < 24; hour++) {
            for (int min = 0; min < 60; min ++) {
                if (min % 15 == 0) {
                    NSString *tempDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld %d:%d",year,month,day,hour,min];
                    
                    NSDate *tempDate = [fullFormatter dateFromString:tempDateStr];
                    // 今天 之后的时间段
                    if (i == 0) {
                        if ([calendar compareDate:tempDate toDate:date toUnitGranularity:NSCalendarUnitMinute] == 1 || [calendar compareDate:tempDate toDate:date toUnitGranularity:NSCalendarUnitMinute] == 0) {
                            [smallArr addObject:tempDate];
                        }
                    }else{
                        [smallArr addObject:tempDate];
                    }
                }
            }
        }
        [detailTimeArr addObject:smallArr];
    }
    // 晚上23点把今天对应的周几和今天的时间空数组去掉
    if (currentHour == 23) {
        [weekStrArr removeObjectAtIndex:0];
        [detailTimeArr removeObjectAtIndex:0];
    }
    NSDictionary *resultDic = @{@"week" : weekStrArr , @"time" : detailTimeArr};
    return resultDic;
}
- (NSString *)XZGetTimeStringWithDate:(NSDate *)date dateFormatStr:(NSString *)dateFormatStr {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = dateFormatStr;
    return [format stringFromDate:date];
}

#pragma mark - UIPickViewDelegate, UIPickViewDataSource
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    //时间
    if (component == 0) {
        return [self.dateDic[@"week"] count];
    }else{
        NSInteger whichWeek = [pickerView selectedRowInComponent:0];
        return [[self.dateDic[@"time"] objectAtIndex:whichWeek] count];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(component == 0){
        self.currentSelectDay = [pickerView selectedRowInComponent:0];
        [pickerView reloadComponent:1];
        self.weekStr = self.dateDic[@"week"][row];
        NSArray *arr = [[self.dateDic objectForKey:@"time"] objectAtIndex:self.currentSelectDay];
        NSDate *date = arr[0];
        _selectDateTime = date;
        self.timeStr = [self XZGetTimeStringWithDate:date dateFormatStr:@"HH:mm"];
        NSLog(@"%@----time2---%@",self.timeStr,self.weekStr);
        [self.pickView selectRow:0 inComponent:1 animated:NO];
        
        [self.pickView reloadAllComponents];
    }else{
        NSInteger whichWeek = [pickerView selectedRowInComponent:0];
        NSDate *date = [[self.dateDic[@"time"] objectAtIndex:whichWeek] objectAtIndex:row];
        self.timeStr = [self XZGetTimeStringWithDate:date dateFormatStr:@"HH:mm"];
        NSLog(@"%@----time2---",self.timeStr);
        _selectDateTime = date;


    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(component == 0){
        return self.dateDic[@"week"][row];
        
    }else{
        
        NSArray *arr = [[self.dateDic objectForKey:@"time"] objectAtIndex:self.currentSelectDay];
        NSDate *date = [arr objectAtIndex:row];
        NSString *str = [self XZGetTimeStringWithDate:date dateFormatStr:@"HH:mm"];
        return str;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 33;
}

#pragma mark - getter methods
- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [[UIView alloc] init];
        _blackView.backgroundColor = XZColor(238, 238, 238);
    }
    return _blackView;
}
- (UIView *)blackVie {
    if (!_blackVie) {
        _blackVie = [[UIView alloc] init];
        _blackVie.backgroundColor = XZColor(238, 238, 238);
    }
    return _blackVie;
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

- (UIView *)naviContainView {
    if (!_naviContainView) {
        
        _naviContainView = [[UIView alloc] init];
        _naviContainView.backgroundColor = [UIColor whiteColor];
    }
    return _naviContainView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"title";
        _titleLabel.textColor = RGB(51, 51, 51);
        _titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    }
    return _titleLabel;
}

- (UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] init];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

- (UIButton *)bgBtn {
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] init];
        _bgBtn.backgroundColor = [UIColor blackColor];
        _bgBtn.alpha = 0.3;
        [_bgBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
    }
    return _mainView;
}

-(void)pickReloadComponent:(NSInteger)component{
    [self.pickView reloadComponent:component];
}

-(void)reloadData{
    [self.pickView reloadAllComponents];
}
//- (UILabel *)yearLabel{
//    if (!_yearLabel) {
//        _yearLabel = [[UILabel alloc] init];
//        _yearLabel.backgroundColor = [UIColor whiteColor];
//        _yearLabel.font = [UIFont systemFontOfSize:110];
//        _yearLabel.textColor = RGB(233, 237, 242);
//        _yearLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _yearLabel;
//    
//}

@end
