//
//  LookEvaluteTableViewCell.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/19.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "LookEvaluteTableViewCell.h"
#import "HCSStarRatingView.h"
#import <UIImageView+WebCache.h>
#import "UserInfoModel.h"
@interface LookEvaluteTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *evaluteContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *creatDate;
@property (weak, nonatomic) IBOutlet UILabel *userEvalute;
@property (weak, nonatomic) IBOutlet UILabel *evPoint;
@property (weak, nonatomic) IBOutlet UIImageView *certificateImg;

@end
@implementation LookEvaluteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LookEvaluteTableViewCell";
    LookEvaluteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}
- (void)setEvaluateodel:(EvaluateModel *)evaluateodel{
    
    _evaluateodel  = evaluateodel;
    
    _evaluteContentLabel.lineBreakMode = UILineBreakModeWordWrap;
    _evaluteContentLabel.numberOfLines = 0;
    _evaluteContentLabel.text =  _evaluateodel.evComment;
    
    _userEvalute.text = [NSString stringWithFormat:@"%@分",_evaluateodel.evGrade];
    _evPoint.text = [NSString stringWithFormat:@"%@分",_evaluateodel.evPotin];
    
    
    NSString *QiNiuBaseURL = QiNiu_DownLoadImageUrl;
    NSString *drIcon = self.evaluateodel.jyUserinfo.icon;
    NSLog(@"%@",drIcon);
    NSString *url = [NSString stringWithFormat:@"%@%@",QiNiuBaseURL,drIcon];
    NSURL *URL = [NSURL URLWithString:url];
    if (drIcon == nil) {
        URL = nil;
    }
    self.userIcon.layer.cornerRadius = (self.userIcon.frame.size.width)/2;
    self.userIcon.layer.masksToBounds = YES;
    _userName.text =  self.evaluateodel.jyUserinfo.nickname;
    [self.userIcon sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"default_avatar"]];

    long time = [self.evaluateodel.createDate longLongValue];
    NSString *str = [self timestampSwitchTime:(time/1000)];
    _creatDate.text = str;
    
//    if ([_evaluateodel.isAuthentication isEqualToString:@"1"]) {
//        self.certificateImg.image = [UIImage imageNamed:@"driver_head_certification_highlight"];
//
//    }else{
//        self.certificateImg.image = [UIImage imageNamed:@"driver_head_certification_normal"];
//
//    }
    
}

- (void)setJyevaluateodel:(JYEvaluateModel *)jyevaluateodel{
    
    _jyevaluateodel = jyevaluateodel;
    
    _evaluteContentLabel.lineBreakMode = UILineBreakModeWordWrap;
    _evaluteContentLabel.numberOfLines = 0;
    _evaluteContentLabel.text =  _jyevaluateodel.evComment;
    
    _userEvalute.text = [NSString stringWithFormat:@"%@分",_jyevaluateodel.attitudeScore];
    _evPoint.text = [NSString stringWithFormat:@"%@分",_jyevaluateodel.speedScore];
    
    
    NSString *QiNiuBaseURL = QiNiu_DownLoadImageUrl;
    NSString *drIcon = _jyevaluateodel.appraiserIcon;
    NSLog(@"%@",drIcon);
    NSString *url = [NSString stringWithFormat:@"%@%@",QiNiuBaseURL,drIcon];
    NSURL *URL = [NSURL URLWithString:url];
    if (drIcon == nil) {
        URL = nil;
    }
    NSString *name = [_jyevaluateodel.appraiser stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];

    _userName.text =  name;
    
    [self.userIcon sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    _creatDate.text = _jyevaluateodel.createString;

}
    
- (NSString *)timestampSwitchTime:(NSInteger)timestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd  hh:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
