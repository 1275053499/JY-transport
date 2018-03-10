//
//  platformBidView.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/8.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "platformBidView.h"

@interface platformBidView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@end
@implementation platformBidView

- ( instancetype )initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 312, 250)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled =NO;
        [self addSubview:self.tableView];
        self.tableView.layer.cornerRadius = 5;
        self.layer.cornerRadius = 5;
        self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
//      self.tableView.backgroundColor = [UIColor greenColor];
        [self creatTapView];
        
        
    }
    return self;
    
}
//创建顶部试图
-(void)creatTapView
{
    
    UIView *tapView = [[UIView alloc]init];
    tapView.backgroundColor = [UIColor whiteColor];
    tapView.frame = CGRectMake(0, 0, 0, 49);
    self.tableView.tableHeaderView = tapView;
    
    UILabel *taplabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 312, 20)];
    taplabel.text = @"价格明细";
    taplabel.textAlignment = NSTextAlignmentCenter;
    taplabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
    taplabel.textColor = BGBlue;
    [tapView addSubview:taplabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 312, 1)];
//    UIImageView *lineIamgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"thread"]];
    [tapView addSubview:lineView];
    lineView.backgroundColor = RGB(238, 238, 238);
    
    

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"SetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
    cell.detailTextLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
    cell.textLabel.textColor = RGB(51, 51, 51);
    cell.detailTextLabel.textColor = RGB(51, 51, 51);
    
        if (indexPath.row ==0) {
            
            cell.textLabel.text=@"车型";
            cell.detailTextLabel.text = self.carType;
            
        }else if (indexPath.row == 1){
            
            cell.textLabel.text=@"起步价";
            
            if ([self.carType isEqualToString:@"微面"]) {
                cell.detailTextLabel.text = @"30（元／10公里)";
            }else if ([self.carType isEqualToString:@"大型面包车"]){
            cell.detailTextLabel.text = @"50（元／10公里)";
            }else if ([self.carType isEqualToString:@"依维柯"]){
                cell.detailTextLabel.text = @"80（元／10公里)";
                
            }else if ([self.carType isEqualToString:@"微型货车"]){
                cell.detailTextLabel.text = @"80（元／10公里)";
                
            }else if ([self.carType isEqualToString:@"小型货车"]){
                cell.detailTextLabel.text = @"80（元／10公里)";
                
                
            }else if ([self.carType isEqualToString:@"中型货车"]){
                cell.detailTextLabel.text = @"300（元／10公里)";
                
                
            }else{
                cell.detailTextLabel.text = @"120（元／10公里)";
                
            }
            
            
            
        }else if (indexPath.row == 2){
            
            cell.textLabel.text=@"超过单价";
            
            if ([self.carType isEqualToString:@"微面"]) {
                    cell.detailTextLabel.text = @"3（元／公里)";
            }else if ([self.carType isEqualToString:@"大面包车"]){
                    cell.detailTextLabel.text = @"3.5（元／公里)";
                
            }else if ([self.carType isEqualToString:@"依维柯"]){
                    cell.detailTextLabel.text = @"5（元／公里)";
                
            }else if ([self.carType isEqualToString:@"微型货车"]){
                
                    cell.detailTextLabel.text = @"3.5（元／公里)";
            }else if ([self.carType isEqualToString:@"小型货车"]){
                    cell.detailTextLabel.text = @"5（元／公里)";
                
            }else if ([self.carType isEqualToString:@"中型货车"]){
                cell.detailTextLabel.text = @"7（元／公里)";
                
            }else{
                    cell.detailTextLabel.text = @"6（元／公里)";
                
            }
        
        }else if (indexPath.row == 3){
            
            cell.textLabel.text=@"公里数";
            cell.detailTextLabel.text = [[NSString stringWithFormat:@"%.2f",self.savedistance] stringByAppendingString:@"公里"];
        }else{
            cell.textLabel.text=@"大约价格";
            cell.detailTextLabel.text = [self.money stringByAppendingString:@"元"];
        }
           return cell;
        
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}



@end
