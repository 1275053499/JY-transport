//
//  SearchOrderView.m
//  JY-transport
//
//  Created by 闫振 on 2017/12/6.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "SearchOrderView.h"
#import "SearchOrderViewCell.h"
#import "DatePickerSelectView.h"
#import "OrderModel.h"
#import "MessageViewController.h"
#import "SearchLookCarOrderVC.h"
@interface SearchOrderView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DatePickerSelectViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)NSString *startDate;
@property (nonatomic,strong)NSString *endDate;
@property (nonatomic,assign)NSInteger select;
@property (nonatomic,strong)UIButton *finishBtn;
@property (nonatomic,strong)NSString *orderNum;
@property (nonatomic,strong)NSMutableArray *serviceArr;
@property (nonatomic,strong)MessageViewController *messageVc;
@end

@implementation SearchOrderView

- (instancetype)initWithFrame:(CGRect)frame viewController:(MessageViewController *)vc{

    self = [super initWithFrame:frame];
    if (self) {
        _messageVc = vc;
        [self commonInit];
    }
    return self;
}
- (void)commonInit{
    _startDate = @"";
    _endDate = @"";
    _orderNum = @"";
    _select = 0;
    _serviceArr = [NSMutableArray array];
    
    UIButton *bottomBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    bottomBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:bottomBtn];
    _bottomBtn = bottomBtn;

   
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(95 *HOR_SCALE, 0, ScreenWidth - (95 *HOR_SCALE),0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }
    [bottomBtn addSubview:self.tableView];

    [self creatFinishBtn];

}
- (void)layoutSubviews{
    
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);

    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomBtn.mas_left).mas_offset(95 * HOR_SCALE);
        make.right.mas_equalTo(_bottomBtn.mas_right).mas_offset(0);
        make.top.mas_equalTo(_bottomBtn.mas_top);
        make.bottom.mas_equalTo(_bottomBtn.mas_bottom);

    }];
    
    [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(_tableView.mas_width);
        make.left.mas_equalTo(_tableView.mas_left);
        make.bottom.mas_equalTo(_bottomBtn.mas_bottom).mas_offset(0);

     
    }];
    
}
- (void)bottomBtnClick:(UIButton *)btn{
    
    [self changeBottomViewFrame];
   
}
- (void)changeBottomViewFrame{
    
    _bottomBtn.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
   CGRect frame =  _tableView.frame;
    frame.origin.x = ScreenWidth;
    
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomBtn.mas_left).mas_offset(ScreenWidth);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [_bottomBtn layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [_tableView removeFromSuperview];
        [_bottomBtn removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}
- (void)creatFinishBtn{
    
    UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    finishBtn.backgroundColor = BGBlue;
    [finishBtn setTitle:@"完成" forState:(UIControlStateNormal)];

    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [_tableView addSubview:finishBtn];
    _finishBtn = finishBtn;
}
- (void)finishBtnClick:(UIButton *)btn{
    
//    [self changeBottomViewFrame];
//    NSString *serviceStr = @"";
//    if (_serviceArr.count > 0) {
//
//        serviceStr = [self.serviceArr componentsJoinedByString:@","];
//
//    }
//    NSDictionary *dic = @{@"startDate":_startDate,
//                          @"endDate":_endDate,
//                          @"orderNo":_orderNum,
//                          @"service":serviceStr};
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"getByConditionUser" object:nil userInfo:dic];
    [self getResultByPost];
  
}

- (void)getResultByPost{
    
    NSString *phoneNumber = userPhone;
    NSString *baseStr = base_url;
    NSString *urlStr = [baseStr stringByAppendingString:@"app/chartered/getByConditionUser"];
    
    if (_startDate == nil || [_startDate isEqual:[NSNull null]]) {
        _startDate = @"";
    }else if (_endDate == nil || [_endDate isEqual:[NSNull null]])  {
        _endDate = @"";
    }
    
    NSString *serviceStr = @"";

    if (_serviceArr.count > 0) {
        
        serviceStr = [self.serviceArr componentsJoinedByString:@","];
        
    }
    NSDictionary *dic = @{@"orderNo":_orderNum,
                          @"service":serviceStr,
                          @"startDate":_startDate,
                          @"endDate":_endDate,
                          @"phone":phoneNumber
                          };
    
    [[NetWorkHelper shareInstance]Post:urlStr parameter:dic success:^(id responseObj) {
        
        
        NSMutableArray *inquireArr = [OrderModel mj_objectArrayWithKeyValuesArray:responseObj];
        NSArray *arr = inquireArr;
        SearchLookCarOrderVC *vc = [[SearchLookCarOrderVC alloc] init];
        vc.inquireArr = arr;
        [_messageVc.navigationController pushViewController:vc animated:YES];
        
        [_tableView removeFromSuperview];
        [_bottomBtn removeFromSuperview];
        [self removeFromSuperview];
    }failure:^(NSError *error) {
        [_tableView removeFromSuperview];
        [_bottomBtn removeFromSuperview];
        [self removeFromSuperview];
        
    }];
    
}
- (void)datePickerViewSelect:(NSString *)dateStr{
    
    if (_select == 20017) {
        _startDate = dateStr;
        
 
    }else if (_select == 20018){
        
        _endDate = dateStr;
    }
    [self.tableView reloadData];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 35;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 35;
        }
    }else{
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 90;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchOrderViewCell *cell = [SearchOrderViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    cell.nameLabel.textColor = RGB(153, 153, 153);
    
    if(indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            cell.nameLabel.text = @"订单编号";
        }else{
            
            cell.nameLabel.hidden = YES;
            [cell.contentView addSubview:[self creatTextField]];
            
        }
        return cell;

    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
            cell.nameLabel.text = @"时间";

        }else{
            
            [cell.contentView addSubview:[self creatTimeTextField]];

        }
        
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            
            cell.nameLabel.text = @"服务详情";
            
        }else{
            [cell.contentView addSubview:[self creatServiceBtn]];

        }
        
        return cell;
        
    }
   
    return cell;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
    [self.tableView endEditing:YES];
}
- (UIView *)creatTimeTextField{
    
    CGFloat tabWeight = self.tableView.frame.size.width;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, tabWeight - 30, 30)];

    UIButton *btnleft = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnleft.frame = CGRectMake(0,0 ,100 * HOR_SCALE, 30);
    [bottomView addSubview:btnleft];
    btnleft.backgroundColor = RGB(238, 238, 238);
    [btnleft setTitleColor:RGB(204, 204, 204) forState:(UIControlStateNormal)];
    [btnleft setTitle:@"输入时间" forState:(UIControlStateNormal)];
    if (_startDate.length > 0) {
    
        [btnleft setTitle:_startDate forState:(UIControlStateNormal)];
        [btnleft setTitleColor:RGB(51, 51, 51) forState:(UIControlStateNormal)];

    }
    btnleft.tag = 20017;
    [btnleft addTarget:self action:@selector(seledtDateClick:) forControlEvents:(UIControlEventTouchUpInside)];
    btnleft.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
    [btnleft rounded:2.0];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(btnleft.frame.size.width + 15, 0, 15, 30)];
    lab.textColor = RGB(51, 51, 51);
    lab.text =  @"至";
    [bottomView addSubview:lab];

    CGFloat labX = lab.frame.origin.x + lab.frame.size.width + 15;
    UIButton *btnright = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnright.frame = CGRectMake(labX,0 ,100 * HOR_SCALE, 30);
    btnright.backgroundColor = RGB(238, 238, 238);
    [btnright setTitleColor:RGB(204, 204, 204) forState:(UIControlStateNormal)];
    [btnright setTitle:@"输入时间" forState:(UIControlStateNormal)];
    btnright.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
    btnright.tag = 20018;
    [btnright addTarget:self action:@selector(seledtDateClick:) forControlEvents:(UIControlEventTouchUpInside)];
    if (_endDate.length > 0) {
        
        [btnright setTitle:_endDate forState:(UIControlStateNormal)];
        [btnright setTitleColor:RGB(51, 51, 51) forState:(UIControlStateNormal)];
        
    }
    [btnright rounded:2.0];

    [bottomView addSubview:btnright];
   
    return bottomView;
    
}

- (void)seledtDateClick:(UIButton *)btn{
    [self endEditing:YES];
    if (btn.tag == 20017) {
        _select = 20017;
    }else{
        _select = 20018;
    }
    DatePickerSelectView *datePickView = [[DatePickerSelectView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 220, ScreenWidth , 220)];
    datePickView.datePickerDelegate = self;
    [datePickView showPickView];
}
- (UIView *)creatTextField{
    
    CGFloat tabWeight = self.tableView.frame.size.width;
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(15,0 ,tabWeight - 30, 30)];
    text.placeholder = @"请输入订单编号";
    text.text = _orderNum;
    text.delegate = self;
    text.returnKeyType = UIReturnKeyDone;
    [text addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    text.backgroundColor = RGB(238, 238, 238);
    text.textColor = RGB(51, 51, 51);
    text.layer.cornerRadius =2;
    
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,20,26)];
    leftView.backgroundColor = [UIColor clearColor];
    text.leftView = leftView;
    text.leftViewMode = UITextFieldViewModeAlways;
    text.layer.masksToBounds = YES;
    
    return text;
    
}
- (UIView *)creatServiceBtn{
    
    CGFloat tabWeight = self.tableView.frame.size.width - 20;
    NSInteger klineCount = 3;
    NSInteger kimageEdge = 5;
    NSInteger kimageEdgeH = 10;

    CGFloat kbtnHeight = 30;
    CGFloat kimageWidth = (tabWeight - (klineCount + 1) * kimageEdge) / klineCount;
    
    
    NSArray *arr = @[@"签回单",@"月结",@"收货人付款",@"代收货款"];//456 10
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, tabWeight - 30, 90)];
    
    for (int i = 0; i < arr.count; i++) {
        //计算View的位置
        CGFloat imageViewX = i % klineCount * kimageWidth + ((i % klineCount)+1) * kimageEdge;
        CGFloat imageViewY = i / klineCount * kbtnHeight + ((i / klineCount)+1) *kimageEdgeH;
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
        btn.backgroundColor = RGB(242, 242, 242);
        [btn setTitleColor:RGB(102, 102, 102) forState:(UIControlStateNormal)];
        [btn setTitleColor:BGBlue forState:(UIControlStateSelected)];

        btn.userInteractionEnabled  = YES;
        btn.tag = 200 + i;
        [btn addTarget:self action:@selector(selectServiceClick:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.frame = CGRectMake(imageViewX, imageViewY, kimageWidth, kbtnHeight);
        [btn rounded:2.0];
        
        [bottomView addSubview:btn];
        
    }
    
    return bottomView;
    
}
- (void)selectServiceClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.backgroundColor = RGB(226, 242, 255);
        NSInteger num = [self changeServiewNum:btn.tag -200];
        [_serviceArr addObject:@(num)];
    }else{
        btn.backgroundColor = RGB(238, 238, 238);
        NSInteger num = [self changeServiewNum:btn.tag -200];

        [_serviceArr removeObject:@(num)];

    }
    NSLog(@"%@",_serviceArr);
}

- (NSInteger )changeServiewNum:(NSInteger)tag{
    
    if (tag == 0) {
        return 4;
    }else if (tag == 1){
        return 5;
    }else if (tag == 2){
        return 6;
    }else{
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    v.backgroundColor = BgColorOfUIView;

    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self endEditing:YES];
    
    return YES;
}
- (void)textFieldDidChange:(UITextField *)text{
    
    _orderNum = text.text;
}
@end
