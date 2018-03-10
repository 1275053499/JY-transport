//
//  TMRouteInquiryTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2018/2/1.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "TMRouteInquiryTableViewCell.h"

@interface  TMRouteInquiryTableViewCell()
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UIView *startLineView;
@property (nonatomic,strong)UIView *endlineView;
@end
@implementation TMRouteInquiryTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self commonInit];
    }
    return self;
}



- (void)commonInit{
    _imgView = [[UIImageView alloc] init];
    _imgView.image = [UIImage imageNamed:@"img_chaxun"];
    [self.contentView addSubview:_imgView];
    
    _startbtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _startbtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
    [_startbtn setTitle:@"始发地" forState:(UIControlStateNormal)];
    [_startbtn setTitleColor:RGB(196, 196, 196) forState:(UIControlStateNormal)];
    _startbtn.tag = 1113;
    [self.contentView addSubview:_startbtn];
    
    _endBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _endBtn.titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
    [_endBtn setTitle:@"目的地" forState:(UIControlStateNormal)];
    _endBtn.tag = 1114;

    [_endBtn setTitleColor:RGB(196, 196, 196) forState:(UIControlStateNormal)];
    [self.contentView addSubview:_endBtn];
    
    _startLineView = [[UIView alloc] init];
    _startLineView.backgroundColor = RGB(200, 200, 200);
    [self.contentView addSubview:_startLineView];
    
    _endlineView = [[UIView alloc] init];
    _endlineView.backgroundColor = RGB(200, 200, 200);
    [self.contentView addSubview:_endlineView];
    
    [self updateViewsFrame];
    
}
- (void)updateViewsFrame{
    
    CGFloat spaceW = (ScreenWidth - 54 -120 -120)/4;

    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.center.mas_equalTo(self);
        make.width.height.mas_equalTo(54);
        make.height.mas_equalTo(40);


    }];
    
    [_startbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.imgView.mas_left).mas_offset(-spaceW);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        
    }];
    
    [_startLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_startbtn.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(1);
        make.centerX.mas_equalTo(_startbtn);
        
    }];

    [_endBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.imgView.mas_right).mas_offset(spaceW);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);

    }];


    [_endlineView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(_endBtn.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(1);
        make.centerX.mas_equalTo(_endBtn);

    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
