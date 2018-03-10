//
//  AdBannerView.h
//  ERAPP
//
//  Created by PeterZhang on 15/12/8.
//  Copyright © 2015年 PeterZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdBannerView : UIView

@property (nonatomic,strong)UIImageView *currentImageView;
@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)NSArray *carName;
- (void)initWithImage:(NSArray *)paraArray;//初始化数据


- (void)liftButtonClick;
-(void)rightButtonClick;



@end

