//
//  OrderDetailFourCell.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "OrderDetailFourCell.h"

#define kimageEdge  15
#define klineCount  4
#define kscreenW    [UIScreen mainScreen].bounds.size.width - 14
#define kimageWidth (kscreenW - (klineCount + 1) *kimageEdge) / klineCount

#define kbtnHeight 31


@interface OrderDetailFourCell ()
@property (weak, nonatomic) IBOutlet UIView *serviceSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serviceSuperConsHeight;

@end

@implementation OrderDetailFourCell

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderDetailFourCell";
    OrderDetailFourCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
        
    }
    return cell;
}
-(void)layoutServiceView:(OrderModel *)model{
    
    NSArray *arr = [NSArray array];
    if (model.service == nil || [model.service isEqualToString:@""]) {
        
    }else{
       
        arr = [model.service componentsSeparatedByString:@","];
        
    }
    
    NSInteger height = [self imageContentViewHeight:arr];
    _serviceSuperConsHeight.constant = height;
    [self layoutIfNeeded];
    
    //添加新的View
    for (int i = 0; i < arr.count; i++) {
        //计算View的位置
        
        CGFloat imageViewX = i % klineCount * kimageWidth + ((i % klineCount)+1) * kimageEdge;
        CGFloat imageViewY = i / klineCount * kbtnHeight + ((i / klineCount)+1) *kimageEdge;
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        NSString *title = [self servicename:arr[i]];
        [btn setTitle:title forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:12];
        btn.backgroundColor = RGB(242, 242, 242);
        [btn setTitleColor:RGB(102, 102, 102) forState:(UIControlStateNormal)];
        btn.userInteractionEnabled  = NO;
        btn.frame = CGRectMake(imageViewX, imageViewY, kimageWidth, kbtnHeight);
        [btn rounded:2.0];
        
        [_serviceSuperView addSubview:btn];
        
        
    }
}

- (NSString *)servicename:(NSString *)str{
    
    if ([str isEqualToString:@"1"]) {
        return @"高速";
    }else if ([str isEqualToString:@"2"]){
        return @"手推车";
    }else if ([str isEqualToString:@"3"]){
        return @"搬运";
    }else if ([str isEqualToString:@"4"]){
        return @"签回单";
    }else if ([str isEqualToString:@"5"]){
        return @"月结";
    }else if ([str isEqualToString:@"6"]){
        return @"收货人付款";
    }else if ([str isEqualToString:@"7"]){
        return @"尾板车";
    }else if ([str isEqualToString:@"8"]){
        return @"厢式车";
    }else{
        return @"";
    }
}
//图片视图的高度
-(CGFloat)imageContentViewHeight:(NSArray *)arr{
    if (arr.count == 0) {
        return 0;
    }
    
    //图片的个数
    NSInteger imageCount = arr.count ;
    
    //图片显示的行数
    NSInteger line = (imageCount - 1) / klineCount + 1;
    //图片显示的高度
    return (line * kbtnHeight + (line + 1) *kimageEdge);
}


@end
