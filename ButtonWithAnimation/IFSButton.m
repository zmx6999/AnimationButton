//
//  IFSButton.m
//  ButtonWithAnimation
//
//  Created by zmx on 16/3/19.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "IFSButton.h"
#import "MMMaterialDesignSpinner.h"

#define scale 1.2
#define originCornerRadius 3

#define w (self.frame.size.width)
#define h (self.frame.size.height)
#define btnW (w / scale)
#define btnH (h / scale)

@interface IFSButton ()

@property (weak, nonatomic) UIButton *button;
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) MMMaterialDesignSpinner *spinner;
@property (nonatomic, weak) UILabel *textLabel;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation IFSButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIButton *button = [[UIButton alloc] init];
    self.button = button;
    [self addSubview:self.button];
    [self.button addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    self.bgView.backgroundColor = [UIColor colorWithRed:1.0 green:0.7 blue:0.3 alpha:1.0];
    [self.button addSubview:self.bgView];
    self.bgView.layer.cornerRadius = originCornerRadius;
    self.bgView.userInteractionEnabled = NO;
    
    MMMaterialDesignSpinner *spinner = [[MMMaterialDesignSpinner alloc] init];
    self.spinner = spinner;
    [self.button addSubview:self.spinner];
    self.spinner.lineWidth = 2;
    self.spinner.tintColor = [UIColor whiteColor];
    self.spinner.hidesWhenStopped = YES;
    
    UILabel *textLabel = [[UILabel alloc] init];
    self.textLabel = textLabel;
    [self.button addSubview:self.textLabel];
    self.textLabel.text = @"发送验证码";
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)onClick {
    self.button.userInteractionEnabled = NO;
    [self startSend];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.button.bounds = CGRectMake(0, 0, btnW, btnH);
    self.button.center = CGPointMake(w * 0.5, h * 0.5);
    
    self.bgView.frame = self.button.bounds;
    
    self.spinner.bounds = CGRectMake(0, 0, btnH, btnH);
    self.spinner.center = CGPointMake(btnW * 0.5, btnH * 0.5);
    
    self.textLabel.frame = self.button.bounds;
}

- (void)startSend {
    CABasicAnimation *anim = [[CABasicAnimation alloc] init];
    anim.keyPath = @"cornerRadius";
    anim.fromValue = @(originCornerRadius);
    anim.toValue = @(btnH * scale * 0.5);
    anim.duration = 0.3;
    [self.bgView.layer addAnimation:anim forKey:nil];
    self.bgView.layer.cornerRadius = [anim.toValue doubleValue];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:6 options:UIViewAnimationOptionCurveLinear animations:^{
        self.bgView.layer.bounds = CGRectMake(0, 0, btnW * scale, btnH * scale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.textLabel.text = nil;
            self.bgView.layer.bounds = CGRectMake(0, 0, btnH * scale, btnH * scale);
        } completion:^(BOOL finished) {
            [self.spinner startAnimating];
            [self addTimer];
        }];
    }];
}

- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)updateTimer {
    static int n = 20;
    
    if (n > 0) {
        self.textLabel.text = [NSString stringWithFormat:@"%d", n--];
    } else {
        self.textLabel.text = nil;
        [self.spinner stopAnimating];
        [self removeTimer];
        [self endSend];
        n = 20;
    }
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)endSend {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.layer.bounds = CGRectMake(0, 0, btnW * scale, btnH * scale);
    } completion:^(BOOL finished) {
        self.textLabel.text = @"发送验证码";
        
        CABasicAnimation *anim = [[CABasicAnimation alloc] init];
        anim.keyPath = @"cornerRadius";
        anim.fromValue = @(btnH * scale * 0.5);
        anim.toValue = @(originCornerRadius);
        anim.duration = 0.3;
        [self.bgView.layer addAnimation:anim forKey:nil];
        self.bgView.layer.cornerRadius = [anim.toValue doubleValue];
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:6 options:UIViewAnimationOptionCurveLinear animations:^{
            self.bgView.layer.bounds = CGRectMake(0, 0, btnW, btnH);
        } completion:^(BOOL finished) {
            self.button.userInteractionEnabled = YES;
        }];
    }];
}

@end
