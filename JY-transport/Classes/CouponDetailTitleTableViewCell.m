//
//  CouponDetailTitleTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2018/1/3.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "CouponDetailTitleTableViewCell.h"
#import "CouponModel.h"
@interface  CouponDetailTitleTableViewCell()
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@end

@implementation CouponDetailTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self commonInit];
        
    }
    return self;
    
}
- (void)commonInit{
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.numberOfLines = 0;
    _titleLabel = titleLabel;
    _titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:18];
    _titleLabel.textColor = RGB(51, 51, 51);
    [self.contentView addSubview:_titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    _timeLabel = timeLabel;
    timeLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:11];
    timeLabel.textColor = RGB(102, 102, 102);
    [self.contentView addSubview:_timeLabel];
    [self updateFrame];
}
- (void)setModel:(CouponModel *)model{
   
    _model = model;
    _titleLabel.text =  model.title;
    _timeLabel.text = model.deliveryTime;

}
- (void)updateFrame{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
