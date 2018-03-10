//
//  returnCarWoringView.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/7.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "returnCarWoringView.h"
@interface returnCarWoringView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@end
@implementation returnCarWoringView

- ( instancetype )initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 243, 120)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled =NO;
        [self addSubview:self.tableView];
        self.tableView.layer.cornerRadius = 10;
        self.layer.cornerRadius = 10;
        self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
        
        self.tableView.backgroundColor = [UIColor greenColor];
        
        
  
        
        
        
    }
    return self;
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"SetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
  
    cell.textLabel.font = [UIFont fontWithName:Default_APP_Font size:12];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    if (indexPath.row ==0) {
 
        cell.textLabel.text=@"非同城，回程车不提供包车服务";
    }else if (indexPath.row == 1){

        cell.textLabel.text=@"包半天：4小时";
    }else if (indexPath.row == 2){
    
        cell.textLabel.text=@"包全日：8小时";
    }else{
    
        cell.textLabel.text=@"夜间服务：10元／小时（21:00-6:00）";
        
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}









@end
