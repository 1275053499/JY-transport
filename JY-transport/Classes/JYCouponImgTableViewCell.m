//
//  JYCouponImgTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2018/1/3.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "JYCouponImgTableViewCell.h"
#import "CouponModel.h"
#import <UIImageView+WebCache.h>
@interface  JYCouponImgTableViewCell()
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UILabel *contentLabel;
@end
@implementation JYCouponImgTableViewCell

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
    UIImageView *imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:imgView];
    _imgView = imgView;

    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
    contentLabel.textColor = RGB(51, 51, 51);
    _contentLabel = contentLabel;
    
    [self.contentView addSubview:_contentLabel];
}
- (void)setModel:(CouponModel *)model{
    _model = model;
    NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
    NSString *urlStr = [url stringByAppendingString:model.picture];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"activity_img_welfare"]];
    _contentLabel.text = _model.content;
    [self updateFrame];

}
- (void)updateFrame{

    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.height.mas_equalTo(170 * HOR_SCALE);
        if ([_model.picture isEqualToString:@""] || _model.picture == nil || [_model isEqual:[NSNull null]]) {
            
            make.height.mas_equalTo(0);
        }
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
   
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView.mas_bottom).offset(15);
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
