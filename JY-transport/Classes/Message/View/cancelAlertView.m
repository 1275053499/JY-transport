//
//  cancelAlertView.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/22.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "cancelAlertView.h"
#import "cancelTableCell.h"
@interface cancelAlertView()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)UIButton *lastbutton;
@property (nonatomic,strong)NSString *selectReason;
@property (nonatomic,assign)NSInteger selectIndex;
@end

@implementation cancelAlertView


+(id)GlodeBottomView{
    return [[self alloc] init];
}

-(void)show{
    UIWindow *current = [UIApplication sharedApplication].keyWindow;
    self.backgroundColor = RGBA(0, 0, 0, 0.6);
       [current addSubview:self];

    
        _selectIndex = 0;
        [self creatTableView];
        [UIView animateWithDuration:0.3 animations:^{
            
        [UIView setAnimationCurve:(UIViewAnimationCurveEaseOut)];
        self.backView.frame = CGRectMake(50, ScreenHeight/2-100, ScreenWidth-100, 160+48+50);
            
    }];
}

#pragma mark - 懒加载
-(UIView*)backView{
    
    if (_backView == nil) {
        
        self.backView = [UIView new];
        self.backView.backgroundColor = [UIColor whiteColor];
        _backView.bounds = CGRectMake(50, 0, ScreenWidth-100, 160+48+50);
        _backView.layer.cornerRadius = 10;
        [self addSubview:_backView];
        
    }
    return _backView;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dissMIssView];
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    self.frame = [UIScreen mainScreen].bounds;
    [self setUpCellSeparatorInset];
}
- (void)setUpCellSeparatorInset
{
    //    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    //        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    //    }
    //    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    //        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    //    }
}

-(void)dissMIssView{
    
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:(UIViewAnimationCurveEaseIn)];
        self.backView.frame = CGRectMake(50, ScreenHeight, ScreenWidth-100,160+48+50);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


-(void)creatTableView
{

    self.dataArr = self.titleArray;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(50, 0, self.backView.bounds.size.width, self.backView.bounds.size.height-40) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.cornerRadius = 5;
    self.tableView.scrollEnabled =NO;
    [self.backView addSubview:self.tableView];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    
    UIButton *sureButton = [[UIButton alloc] init];
    
    [sureButton setTitle:@"确定" forState:(UIControlStateNormal)];
    sureButton.backgroundColor = [UIColor whiteColor];
    [sureButton setTitleColor:BGBlue forState:(UIControlStateNormal)];
    [sureButton addTarget:self action:@selector(sureCancelButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    sureButton.frame = CGRectMake((ScreenWidth-100)/2+50, self.backView.bounds.size.height-48,(ScreenWidth-100)/2, 48);
    [sureButton round:5.0 RectCorners: UIRectCornerBottomRight];

    [self.backView addSubview:sureButton];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitleColor:RGB(51, 51, 51) forState:(UIControlStateNormal)];
    [cancelButton addTarget:self action:@selector(BT:) forControlEvents:(UIControlEventTouchUpInside)];
    cancelButton.frame = CGRectMake(50, self.backView.bounds.size.height-48, (ScreenWidth-100)/2, 48);
    [cancelButton round:5.0 RectCorners:UIRectCornerBottomLeft];
    [self.backView addSubview:cancelButton];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(1, 4, 1, 40)];
    view.backgroundColor = RGB(238, 238, 238);
    [sureButton addSubview:view];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(50, self.backView.bounds.size.height-48, (ScreenWidth-100), 1)];
    viewLine.backgroundColor = RGB(238, 238, 238);
    [self.backView  addSubview:viewLine];

    


    
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    cancelTableCell *cell = [cancelTableCell cellWithOrderTableView:tableView];
    cell.titleLabel.text = self.dataArr[indexPath.row];
    cell.seleImage.tag = indexPath.row+900;
    [cell.seleImage setImage:[UIImage imageNamed:@"icon_weixuanzhong"] forState:UIControlStateNormal];
     [cell.seleImage setImage:[UIImage imageNamed:@"icon_xuanzhong"] forState:UIControlStateSelected];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = BGBlue;
    lab.text = @"请选择取消订单的原因";
    lab.textAlignment = NSTextAlignmentCenter;
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, (ScreenWidth-100), 1)];
    viewLine.backgroundColor = RGB(238, 238, 238);
    [lab addSubview:viewLine];
    return lab;

}



-(void)BT:(UIButton*)bt{
    [self dissMIssView];
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if ([self.delegate respondsToSelector:@selector(clickButton:)]) {
//        [self.delegate clickButton:indexPath.row];
//    }
    
//    if (self.GlodeBottomView) {
//        self.GlodeBottomView(indexPath.row,self.titleArray[indexPath.row]);
//    }
    
    _selectReason = self.titleArray[indexPath.row];
    _selectIndex = indexPath.row;
    
    UIButton *button = [tableView viewWithTag:indexPath.row+900];

    
   
    if (button.selected) {
        button.selected = YES;
        
    }else{
        
        self.lastbutton.selected = NO;
    
        button.selected = YES;
        self.lastbutton= button;
    
    }
    

    
    //[self dissMIssView];
}
-(void)sureCancelButtonClick:(UIButton *)button
{
    if (_GlodeBottomView) {
        
        _GlodeBottomView(_selectIndex,_selectReason);
    }
    
    if ([self.delegate respondsToSelector:@selector(cancelReasonButtonClick:content:)]) {
        
        [self.delegate cancelReasonButtonClick:_selectIndex content:_selectReason];
     
    }
    
}
@end
