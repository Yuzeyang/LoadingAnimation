//
//  LoadingView.m
//  LoadingAnimation
//
//  Created by 宫城 on 15/12/16.
//  Copyright © 2015年 宫城. All rights reserved.
//

#import "LoadingView.h"

static int loadingViewWidth = 150;
static int lineViewWidth = 150;
static int lineViewHeight = 30;

@interface LoadingView ()

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) double add;

@end

@implementation LoadingView

- (void)layoutIfNeeded {
    self.isLoading = NO;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLoading:)];
    [self addGestureRecognizer:tapGes];
}

- (void)tapLoading:(UITapGestureRecognizer *)tapGes {
    self.originFrame = self.frame;
    
    if (self.isLoading) {
        return;
    }
    
    for (CALayer *sublayer in self.layer.sublayers) {
        [sublayer removeFromSuperlayer];
    }
    
    self.isLoading = YES;
    
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    self.layer.cornerRadius = lineViewHeight/2;
    
    CABasicAnimation *radiusAni = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    radiusAni.delegate = self;
    radiusAni.fromValue = @(self.originFrame.size.height/2);
    radiusAni.duration = 0.2f;
    radiusAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:radiusAni forKey:@"roundToLineAni"];
}

- (void)animationDidStart:(CAAnimation *)anim {
    if ([[self.layer animationForKey:@"roundToLineAni"] isEqual:anim]) {
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bounds = CGRectMake(0, 0, lineViewWidth, lineViewHeight);
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self progressAnimation];
        }];
    }else if ([[self.layer animationForKey:@"lineToRoundAni"] isEqual:anim]) {
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bounds = CGRectMake(0, 0, loadingViewWidth, loadingViewWidth);
            self.backgroundColor = [UIColor colorWithRed:0.1803921568627451 green:0.8 blue:0.44313725490196076 alpha:1.0];
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self checkAnimation];
            
            self.isLoading = NO;
        }];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"animationName"] isEqual:@"progressAni"]) {
        [UIView animateWithDuration:0.3f animations:^{
            for (CALayer *sublayer in self.layer.sublayers) {
                sublayer.opacity = 0.0f;
            }
        } completion:^(BOOL finished) {
            if (finished) {
                for (CALayer *layer in self.layer.sublayers) {
                    [layer removeFromSuperlayer];
                }
                
                self.layer.cornerRadius = loadingViewWidth/2;
                CABasicAnimation *radiusAni = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
                radiusAni.delegate = self;
                radiusAni.fromValue = @(lineViewHeight/2);
                radiusAni.duration = 0.2f;
                radiusAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                [self.layer addAnimation:radiusAni forKey:@"lineToRoundAni"];
            }
        }];
    }
}

- (void)progressAnimation {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(lineViewHeight/2, lineViewHeight/2)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width - lineViewHeight/2, lineViewHeight/2)];
    
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = lineViewHeight - 6;
    shapeLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:shapeLayer];
    
    CABasicAnimation *progressAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    progressAni.delegate = self;
    progressAni.fromValue = @(0.0);
    progressAni.toValue = @(1.0);
    progressAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    progressAni.duration = 2.0f;
    [progressAni setValue:@"progressAni" forKey:@"animationName"];
    [shapeLayer addAnimation:progressAni forKey:nil];
}

- (void)checkAnimation {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    CGRect rectInRound = CGRectInset(self.bounds, loadingViewWidth*(1-1/sqrt(2.0))/2, loadingViewWidth*(1-1/sqrt(2.0))/2);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rectInRound.origin.x + rectInRound.size.width/9, rectInRound.origin.y + rectInRound.size.height*2/3)];
    [path addLineToPoint:CGPointMake(rectInRound.origin.x + rectInRound.size.width/3, rectInRound.origin.y + rectInRound.size.height*9/10)];
    [path addLineToPoint:CGPointMake(rectInRound.origin.x + rectInRound.size.width*8/10, rectInRound.origin.y + rectInRound.size.height*2/10)];
    
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = 10;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:shapeLayer];
    
    CABasicAnimation *tickAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tickAni.delegate = self;
    tickAni.fromValue = @(0.0);
    tickAni.toValue = @(1.0);
    tickAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    tickAni.duration = 0.3f;
    [shapeLayer addAnimation:tickAni forKey:@"tickAni"];
}

- (void)addStroke {
    CAShapeLayer *shapeLayer = [CAShapeLayer  layer];
    for (CALayer *sublayer in self.layer.sublayers) {
        if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
            shapeLayer = (CAShapeLayer *)sublayer;
        }
    }
    
    shapeLayer.strokeStart+=_add;
    shapeLayer.strokeEnd+=_add;
    
    if (shapeLayer.strokeEnd == 1.0) {
        [_timer invalidate];
        _timer =nil;
        [UIView animateWithDuration:0.3f animations:^{
            for (CALayer *sublayer in self.layer.sublayers) {
                sublayer.opacity = 0.0f;
            }
        } completion:^(BOOL finished) {
            if (finished) {
                for (CALayer *layer in self.layer.sublayers) {
                    [layer removeFromSuperlayer];
                }
                
                self.layer.cornerRadius = loadingViewWidth/2;
                CABasicAnimation *radiusAni = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
                radiusAni.delegate = self;
                radiusAni.fromValue = @(lineViewHeight/2);
                radiusAni.duration = 0.2f;
                radiusAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                [self.layer addAnimation:radiusAni forKey:@"lineToRoundAni"];
            }
        }];
    }
}

@end
