//
//  MyiconImageView.h
//  JY-transport
//
//  Created by 闫振 on 2017/12/1.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoModel;
@interface MyiconImageView : UIImageView

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *phoneLabel;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UserInfoModel *userModel;
@property (nonatomic,strong)UIButton *chooseIconBtn;
@end
