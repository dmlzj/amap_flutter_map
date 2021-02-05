//
//  ClusterAnnotationView.m
//  officialDemo2D
//
//  Created by yi chen on 14-5-15.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "ClusterAnnotationView.h"
#import "ClusterAnnotation.h"


static CGFloat const ScaleFactorAlpha = 0.3;
static CGFloat const ScaleFactorBeta = 0.4;

/* 返回rect的中心. */
CGPoint RectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/* 返回中心为center，尺寸为rect.size的rect. */
CGRect CenterRect(CGRect rect, CGPoint center)
{
    CGRect r = CGRectMake(center.x - rect.size.width/2.0,
                          center.y - rect.size.height/2.0,
                          rect.size.width,
                          rect.size.height);
    return r;
}

/* 根据count计算annotation的scale. */
CGFloat ScaledValueForValue(CGFloat value)
{
    return 1.0 / (1.0 + expf(-1 * ScaleFactorAlpha * powf(value, ScaleFactorBeta)));
}

#pragma mark -

@interface ClusterAnnotationView ()

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *countImage;


@end

@implementation ClusterAnnotationView

#pragma mark Initialization

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self setupLabel];
        [self setCount:1];
    }
    
    return self;
}

#pragma mark Utility

- (void)setupLabel
{
    _countLabel = [[UILabel alloc] initWithFrame:self.frame];
//    _countLabel.backgroundColor = [UIColor blackColor];
    _countLabel.textColor       = [UIColor whiteColor];
    _countLabel.textAlignment   = NSTextAlignmentCenter;
    _countLabel.shadowColor     = [UIColor colorWithWhite:0.0 alpha:0.75];
    _countLabel.shadowOffset    = CGSizeMake(0, -1);
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.numberOfLines = 1;
    _countLabel.layer.cornerRadius = 20;
    //_countLabel.layer.backgroundColor =[UIColor colorWithRed:255 green:0 blue:0 alpha:.7].CGColor;
    _countLabel.font = [UIFont boldSystemFontOfSize:12];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _countLabel.hidden = YES;
    [self addSubview:_countLabel];
    
    
    _countImage  = [[UIImageView alloc]initWithFrame:self.frame];
    _countImage.hidden = YES;
    [self addSubview:_countImage];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSArray *subViews = self.subviews;
    if ([subViews count] > 1)
    {
        UIView *subview = [subViews objectAtIndex:1];
        if ([subview pointInside:[self convertPoint:point toView:subview] withEvent:event])
        {
            return YES;
        }
    }
    if (point.x > 0 && point.x < self.frame.size.width && point.y > 0 && point.y < self.frame.size.height)
    {
        return YES;
    }
    return NO;
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    
    /* 按count数目设置view的大小. */
    //CGRect newBounds = CGRectMake(0, 0, roundf(55 * ScaledValueForValue(count)), roundf(55 * ScaledValueForValue(count)));
    CGRect newBounds = CGRectMake(0, 0, 40, 40);
    self.frame = CenterRect(newBounds, self.center);
    
    CGRect newLabelBounds = CGRectMake(0, 0, 40, 40);
    self.countLabel.frame = CenterRect(newLabelBounds, RectCenter(newBounds));
    self.countLabel.text = [@(_count) stringValue];
    self.countImage.frame = CenterRect(newLabelBounds, RectCenter(newBounds));
    
    if (_count==1) {
        self.countLabel.hidden = YES;
        self.countImage.hidden = NO;
    }else{
        self.countLabel.hidden = NO;
        self.countImage.hidden = YES;
    }
    //self.countImage.image = [UIImage imageNamed:@"pointGreen"];
    [self setNeedsDisplay];
}

- (void)setHasWarning:(BOOL)hasWarning
{
    _hasWarning = hasWarning;
    if (_hasWarning) {
        _countLabel.layer.backgroundColor =[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:.7].CGColor;
        _countImage.image = [UIImage imageNamed:@"pointRed"];
    }else{
        _countLabel.layer.backgroundColor =[UIColor colorWithRed:17/255.0 green:192/255.0 blue:124/255.0 alpha:.7].CGColor;
        _countImage.image = [UIImage imageNamed:@"pointGreen"];
    }
}


#pragma mark - annimation

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self addBounceAnnimation];
}

- (void)addBounceAnnimation
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.values = @[@(0.05), @(1.1), @(0.9), @(1)];
    bounceAnimation.duration = 0.6;
    
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounceAnimation.values.count];
    for (NSUInteger i = 0; i < bounceAnimation.values.count; i++)
    {
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    [bounceAnimation setTimingFunctions:timingFunctions.copy];
    
    bounceAnimation.removedOnCompletion = NO;
    
    [self.layer addAnimation:bounceAnimation forKey:@"bounce"];
}

#pragma mark draw rect

- (void)drawRect:(CGRect)rect
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGContextSetAllowsAntialiasing(context, true);
//
//    UIColor *outerCircleStrokeColor = [UIColor colorWithWhite:0 alpha:0.25];
//    UIColor *innerCircleStrokeColor = [UIColor whiteColor];
//    UIColor *innerCircleFillColor = [UIColor clearColor];
//
//    CGRect circleFrame = CGRectInset(rect, 4, 4);
//
//    [outerCircleStrokeColor setStroke];
//    CGContextSetLineWidth(context, 5.0);
//    CGContextStrokeEllipseInRect(context, circleFrame);
//
//    [innerCircleStrokeColor setStroke];
//    CGContextSetLineWidth(context, 4);
//    CGContextStrokeEllipseInRect(context, circleFrame);
//
//    [innerCircleFillColor setFill];
//    CGContextFillEllipseInRect(context, circleFrame);
}

@end
