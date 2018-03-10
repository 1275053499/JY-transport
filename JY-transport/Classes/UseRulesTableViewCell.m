//
//  UseRulesTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2018/1/4.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "UseRulesTableViewCell.h"
#import "CouponModel.h"
@interface UseRulesTableViewCell ()
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *rulesLabel;
@end
@implementation UseRulesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self commonInit];
        [self updateFrame];
    }
    return self;
}

- (void)commonInit{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"使用规则";
    label.font = [UIFont fontWithName:Default_APP_Font_Regu size:15];
    label.textColor = RGB(51, 51, 51);
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    _nameLabel = label;
    
    UILabel *rulesLabel = [[UILabel alloc] init];
    rulesLabel.textAlignment = NSTextAlignmentLeft;
    rulesLabel.numberOfLines = 0;
    [self.contentView addSubview:rulesLabel];
    _rulesLabel = rulesLabel;

    
}
- (void)setModel:(CouponModel *)model{
    _model = model;

    NSString *str =  [NSString stringWithFormat:@"%@",[_model.cpContent stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r\n"]];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5; //设置行间距
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:Default_APP_Font_Regu size:14], NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:RGB(51, 51, 51)};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    _rulesLabel.attributedText = attributeStr;
    
}
- (void)updateFrame{
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        
        
    }];
    [_rulesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
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
