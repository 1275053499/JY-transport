//
//  EditPersonalSexView.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/7/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QYChangeLabelValue <NSObject>

-(void)changeLabelValue:(NSString *)value;

@end
@interface EditPersonalSexView : UIView
@property (weak, nonatomic) IBOutlet UILabel *sexHeadLabel;
@property (nonatomic,strong)NSArray *dataArr;
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (nonatomic, assign) id <QYChangeLabelValue> delegate;
-(void)dissMIssSexView;
- (void)showSexView;
@end
