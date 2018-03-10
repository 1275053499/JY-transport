//
//  XGAnnotationView.m
//  地图的相关操作
//
//  Created by 小果 on 2016/11/20.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGAnnotationView.h"
#define kCalloutWidth       200.0
#define kCalloutHeight      70.0
@interface XGAnnotationView ()

@property (nonatomic, strong, readwrite) CustomCalloutView *calloutView;
@property (nonatomic,assign)int timeNum;
@property (nonatomic,assign)int driverNum;



@end

@implementation XGAnnotationView

+(instancetype)xg_annotationWithMapView:(BMKMapView *)mapView{
    // 实现重用
    static NSString *ID = @"annotation";
    XGAnnotationView *anV = (XGAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (nil == anV) {
        anV = [[XGAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        //anV.image = [UIImage imageNamed:@"destination"];
        // 设置标注
        anV.canShowCallout = YES;
       
    }
    return anV;
}

-(void)setAnnotation:(id<BMKAnnotation>)annotation{
    [super setAnnotation:annotation];
}

- (void)setAnationView{
    
    _driverNum = 1;
    _timeNum = 0;
    if (self.calloutView == nil)
    {
        self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
        self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                              -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
    }
    
    if ([_timeOrDistance isEqualToString:@"distance"]) {
        self.calloutView.title = _distanceStr;
    }else{
        //self.calloutView.image = [UIImage imageNamed:@"end"];
        //      self.calloutView.title = @"ddd";
        //      self.calloutView.subtitle =@"aaa";
        [self addNstimert];
        
    }
    [self addSubview:self.calloutView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
     [super setSelected:selected animated:animated];
   
    
}

- (void)addNstimert{
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeatTime) userInfo:nil repeats:YES];

    NSTimer *timeDriver = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(repeatDriverNum) userInfo:nil repeats:YES];

    [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:timeDriver forMode:NSRunLoopCommonModes];

}

- (void)repeatTime{
    int seconds = _timeNum % 60;
    int minutes = (_timeNum / 60) % 60;
    int hours = _timeNum / 3600;
    _timeNum++;
    self.calloutView.title =  [NSString stringWithFormat:@"已用时%02d:%02d:%02d",hours, minutes, seconds];
    
}

- (void)repeatDriverNum{
    
    self.calloutView.subtitle = [NSString stringWithFormat:@"已通知%d个司机",_driverNum++];;

}
@end
