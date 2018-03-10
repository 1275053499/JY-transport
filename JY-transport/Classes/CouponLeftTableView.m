//
//  CouponLeftTableView.m
//  JY-transport
//
//  Created by 闫振 on 2017/12/13.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "CouponLeftTableView.h"
#import "CouponTableViewCell.h"
#import "MineCouponModel.h"
@interface  CouponLeftTableView()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation CouponLeftTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        [self creatTableView];
    }
    return self;
    
}

- (void)creatTableView{
    
    _leftRight = @"left";
    self.delegate = self;
    self.dataSource = self;
    self.scrollEnabled = YES;
    self.tableFooterView = [[UIView alloc]init];
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.backgroundColor = BgColorOfUIView;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (@available(iOS 11.0, *)) {
        self.estimatedRowHeight = 140;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.estimatedRowHeight = 140;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineCouponModel *model = _dataArr[indexPath.section];
    
    CouponTableViewCell *cell = [CouponTableViewCell cellWithTableView:tableView];
    [cell setMineCouponModel:model type: self.leftRight];

    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 9)];
    v.backgroundColor = BgColorOfUIView;
    return v;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.leftRight isEqualToString:@"JYPayCouponViewController"]) {
        MineCouponModel *model = _dataArr[indexPath.section];

        if (_BlockMineCoupon) {
            
            _BlockMineCoupon(model);
        }
    }
   
   
}
@end
