//
//  ReceiveCouponsTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2018/1/3.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "ReceiveCouponsTableViewCell.h"

@interface  ReceiveCouponsTableViewCell ()
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *moneyLabel;

@end
@implementation ReceiveCouponsTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    
    return self;
}
- (void)commonInit{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setBackgroundImage:[UIImage imageNamed:@"activity_coupons"] forState:(UIControlStateNormal)];
    [self.contentView addSubview:btn];
    _receiveBtn = btn;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
    titleLabel.textColor = RGB(204, 204, 204);
    titleLabel.text = @"点击领取优惠券";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel = titleLabel;
    [self.contentView addSubview:_titleLabel];

    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    _moneyLabel.textColor = [UIColor whiteColor];
    [_receiveBtn addSubview:_moneyLabel];
    
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@"30"];
    
    NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:30],NSForegroundColorAttributeName:RGB(255, 255, 255),};
    [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
    
    NSMutableAttributedString * secondPart = [[NSMutableAttributedString alloc] initWithString:@"元找车券"];
    
    NSDictionary * secondAttributes = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:15],NSForegroundColorAttributeName:RGB(255, 255, 255),};
    [secondPart setAttributes:secondAttributes range:NSMakeRange(0,1)];
    
    NSDictionary * thirdAttDic = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:15],NSForegroundColorAttributeName:RGB(255, 255, 255),};
    [secondPart setAttributes:thirdAttDic range:NSMakeRange(1,secondPart.length -1)];
    
    [firstPart appendAttributedString:secondPart];
    _moneyLabel.attributedText = firstPart;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        
    }];
    [_receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(320 * HOR_SCALE);
        make.height.mas_equalTo(70 * HOR_SCALE);
        
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.receiveBtn.mas_centerY).mas_offset(-5);
        make.left.equalTo(self.receiveBtn.mas_left).offset(80);
        
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
