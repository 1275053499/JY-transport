//
//  JYLookPhotoTableViewCell.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/9/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYLookPhotoTableViewCell.h"

#import "SDPhotoBrowser.h"
#import "YZTapGesturRecongnizer.h"
#import "UIImageView+WebCache.h"

#define kimageEdge  8
#define klineCount  3
#define kscreenW    [UIScreen mainScreen].bounds.size.width - 14
#define kimageWidth (kscreenW - (klineCount + 1) *kimageEdge) / klineCount


@interface JYLookPhotoTableViewCell ()<SDPhotoBrowserDelegate>

@property (nonatomic,strong)NSArray *originalImageUrls;
@end

@implementation JYLookPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutPhotoView:(NSString *)content photo:(NSString *)photo{
    
    if (content.length <= 0 || content == nil || [content isEqual:[NSNull null]]) {
        content = @"";
    }
    _originalImageUrls = [NSMutableArray array];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _contentLabel.text = content;
    _contentLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:16];
    
    if (photo.length <= 0) {
        return;
    }
    _originalImageUrls = [photo componentsSeparatedByString:@","];
    

    NSInteger height = [self imageContentViewHeight:_originalImageUrls];
    _photoSuperViewConsHeight.constant = height;
    
    //添加新的imageView
    for (int i = 0; i < _originalImageUrls.count; i++) {
        //计算imageView的位置
        

        CGFloat imageViewX = i % klineCount * kimageWidth + ((i % klineCount)+1) * kimageEdge;
        CGFloat imageViewY = i / klineCount * kimageWidth + ((i / klineCount)+1) *kimageEdge;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, kimageWidth, kimageWidth)];
        imageView.layer.cornerRadius = 2;
        imageView.layer.masksToBounds = YES;
        [_photoSuperView addSubview:imageView];
        //取图片的url地址
        NSString *urlString = _originalImageUrls[i];
        //设置图片
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        
        YZTapGesturRecongnizer *singleTap =[[YZTapGesturRecongnizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:singleTap];
        imageView.tag = i;
        singleTap.tag = i;

        NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
        NSString *urlstr = [NSString stringWithFormat:@"%@%@",url,urlString];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        
        
    }


}
//图片视图的高度
-(CGFloat)imageContentViewHeight:(NSArray *)arr{
    //图片的个数
    NSInteger imageCount = arr.count;
    
    //图片显示的行数
    NSInteger line = (imageCount - 1) / klineCount + 1;
    //图片显示的高度
    return (line * kimageWidth + (line + 1) *kimageEdge);
}


#pragma mark - 图片浏览器
//返回临时图片
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
//    //确定父视图，根据是否有子视图
    NSArray *subView = _photoSuperView.subviews;
    UIImageView *view = subView[index];
    //取出button设置的图片返回
    return view.image;
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{

    NSString *urlStrting = _originalImageUrls[index];
    NSString *url  = @"http://ory7digfv.bkt.clouddn.com/";
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",url,urlStrting];
    
    return [NSURL URLWithString:urlstr];

}
- (void)singleTapAction:(YZTapGesturRecongnizer *)sender{
    
    NSInteger index = [sender tag];
    
    NSArray *subView = self.photoSuperView.subviews;
    UIImageView *view = subView[index];
    SDPhotoBrowser *photo = [[SDPhotoBrowser alloc] init];
    photo.currentImageIndex = (int)index;//当前图片的索引
    photo.sourceImagesContainerView = [view superview];//所有图片的父视图
    photo.imageCount = [view superview].subviews.count;//图片的总数量
    photo.delegate = self;
    [photo show];//展示
    
}


@end
