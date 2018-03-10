//
//  JYLookPhotoTableViewCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYLookPhotoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *photoSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoSuperViewConsHeight;


-(void)layoutPhotoView:(NSString *)content photo:(NSString *)photo;


@end
