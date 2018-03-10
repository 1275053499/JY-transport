//
//  EmptyTableView.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/12/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyTableView : UITableView


- (void)tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger)rowCount frame:(CGRect)frame;
@end
