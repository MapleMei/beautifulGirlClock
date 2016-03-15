//
//  ViewController.m
//  模拟时钟
//
//  Created by 侯玉昆 on 16/1/8.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
@interface ViewController ()
{
    UIView *_sencend;
    UIImageView *_minite;
    UIImageView *_hour;
    CGFloat _angle;
    NSInteger _hh;
    NSInteger _mm;
    NSInteger _ss;
}
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self star];

    _timeLabel.transform = CGAffineTransformMakeRotation(M_2_PI);

    self.view.backgroundColor = [UIColor blackColor];
    /**************************************************************
     *  动态修改datepicker字体颜色
     **************************************************************/
    unsigned  outcount;
    
    int i;
    
    objc_property_t *property = class_copyPropertyList([UIDatePicker class], &outcount);
    
    for (i = outcount -1; i>=0; i--) {
        
        NSString *getPropertyName = [NSString stringWithCString:property_getName(property[i]) encoding:NSUTF8StringEncoding];
        
        NSString *getPropertyNameStr = [NSString stringWithCString:property_getAttributes(property[i]) encoding:NSUTF8StringEncoding];
        
        if ([getPropertyName isEqualToString:@"textColor"]) {
            
            [_datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
        }
        
        NSLog(@"%@-------%@",getPropertyName,getPropertyNameStr);
    
    }
    
    SEL selector = NSSelectorFromString(@"setHighlightsToday:");
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
    
    BOOL no = NO;
    
    [invocation setSelector:selector];
    
    [invocation setArgument:&no atIndex:2];
    
    [invocation invokeWithTarget:_datePicker];
    
    /**************************************************************
     *  动态修改datepicker字体颜色
     **************************************************************/
    
    
#pragma mark 创建表盘
    
    UIView *clock = [[UIView alloc]initWithFrame:CGRectMake(35, 30, 300, 300)];
    
    clock.layer.contents = (id)[UIImage imageNamed:@"clock2"].CGImage;
    
    [self.view addSubview:clock];
    
#pragma mark 创建秒针
    
    UIView *sencend = [[UIView alloc]initWithFrame:CGRectMake(0,0,2, clock.bounds.size.height*.5)];
   
    sencend.center = CGPointMake(clock.bounds.size.height*.5, clock.bounds.size.height*.5);
    
    sencend.backgroundColor = [UIColor redColor];
    
    sencend.layer.anchorPoint = CGPointMake(.5,.75);
    
    [clock addSubview:sencend];
    
    _sencend = sencend;
    
    [[CADisplayLink displayLinkWithTarget:self selector:@selector(sencendRoate)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    
#pragma mark 创建分针
    
    UIImageView *minite = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12, clock.bounds.size.height*.3)];
                           
    minite.center = CGPointMake(clock.bounds.size.height*.5, clock.bounds.size.height*.5);
    
    minite.image = [UIImage imageNamed:@"minite"];
    
    minite.layer.anchorPoint = CGPointMake(.5,.93);
    
    [clock addSubview:minite];
    
    _minite = minite;
    
    [[CADisplayLink displayLinkWithTarget:self selector:@selector(miniteRoate)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
#pragma mark 创建时针
    
    UIImageView *hour = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12, clock.bounds.size.height*.2)];
    
    hour.center = CGPointMake(clock.bounds.size.height*.5, clock.bounds.size.height*.5);
    
    hour.image = [UIImage imageNamed:@"hour"];
    
    hour.layer.anchorPoint = CGPointMake(.5,.92);
    
    [clock addSubview:hour];
    
    _hour = hour;
    
    [[CADisplayLink displayLinkWithTarget:self selector:@selector(hourRoate)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
#pragma mark label刷新
    [[CADisplayLink displayLinkWithTarget:self selector:@selector(label)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}


- (void)label {

_timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",_hh,_mm,_ss];

}

- (void)sencendRoate {
    
    CGFloat angle = M_PI *2 / 60;
    
    _ss = [[NSCalendar currentCalendar] component:NSCalendarUnitSecond fromDate:[NSDate date]];
    
    _sencend.transform = CGAffineTransformMakeRotation(_ss * angle);

}

- (void)miniteRoate {

    CGFloat angle = M_PI *2 / 60;
    
    _mm = [[NSCalendar currentCalendar] component:NSCalendarUnitMinute fromDate:[NSDate date]];
    
    
    _minite.transform = CGAffineTransformMakeRotation(angle + _mm * angle);
    
    _angle = angle + _mm * angle;
}

- (void)hourRoate {
    //实时弧度
    CGFloat currenAngle = (M_PI/360) * (_angle /(M_PI/30));
    //当前弧度
    CGFloat angle = M_PI * 2 / 12;

   _hh =[[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:[NSDate date]];
    
    _hour.transform = CGAffineTransformMakeRotation(currenAngle + _hh * angle);
}


- (void)star {
    
    for (int i=0; i<80; i++) {
        
        NSInteger width = arc4random_uniform(32);
        
        UIImageView *star = [[UIImageView alloc]initWithFrame:CGRectMake(arc4random_uniform(375), arc4random_uniform(667), width, width)];
        
        star.image = [UIImage imageNamed:[NSString stringWithFormat:@"spark_%d",arc4random_uniform(6)]];
        
        [self.view addSubview:star];
    }
    
}

@end
