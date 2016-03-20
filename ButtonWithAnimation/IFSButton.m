//
//  IFSButton.m
//  ButtonWithAnimation
//
//  Created by zmx on 16/3/19.
//  Copyright © 2016年 zmx. All rights reserved.
//

#import "IFSButton.h"
#import "MMMaterialDesignSpinner.h"

#define originCornerR 3
#define scale 1.2

#define viewW (self.frame.size.width)
#define viewH (self.frame.size.height)
#define btnW (viewW / scale)
#define btnH (viewH / scale)

@interface IFSButton ()

@property (nonatomic, weak) UIButton *button;
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) MMMaterialDesignSpinner *spinner;
@property (nonatomic, weak) UILabel *label;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation IFSButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIButton *button = [[UIButton alloc] init];
    [self addSubview:button];
    self.button = button;
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc] init];
    [self.button addSubview:bgView];
    self.bgView = bgView;
    bgView.backgroundColor = [UIColor greenColor];
    bgView.layer.cornerRadius = originCornerR;
    bgView.userInteractionEnabled = NO;
    
    MMMaterialDesignSpinner *spinner = [[MMMaterialDesignSpinner alloc] init];
    [self.button addSubview:spinner];
    self.spinner = spinner;
    spinner.lineWidth = 2;
    spinner.tintColor = [UIColor whiteColor];
    spinner.hidesWhenStopped = YES;
    
    UILabel *label = [[UILabel alloc] init];
    [self.button addSubview:label];
    self.label = label;
    self.label.text = @"发送验证码";
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.textAlignment = NSTextAlignmentCenter;
}

- (void)onClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [self startSend];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.button.center = CGPointMake(viewW * 0.5, viewH * 0.5);
    self.button.bounds = CGRectMake(0, 0, btnW, btnH);
    
    self.bgView.frame = self.button.bounds;
    
    self.spinner.center = CGPointMake(btnW * 0.5, btnH * 0.5);
    self.spinner.bounds = CGRectMake(0, 0, btnH, btnH);
    
    self.label.frame = self.button.bounds;
}

- (void)startSend {
    CABasicAnimation *anim = [[CABasicAnimation alloc] init];
    anim.keyPath = @"cornerRadius";
    anim.fromValue = @(originCornerR);
    anim.toValue = @(btnH * scale * 0.5);
    anim.duration = 0.3;
    [self.bgView.layer addAnimation:anim forKey:nil];
    self.bgView.layer.cornerRadius = [anim.toValue doubleValue];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:6 options:UIViewAnimationOptionCurveLinear animations:^{
        self.bgView.layer.bounds = CGRectMake(0, 0, btnW * scale, btnH * scale);
    } completion:^(BOOL finished) {
        self.label.text = nil;
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.layer.bounds = CGRectMake(0, 0, btnH * scale, btnH * scale);
        } completion:^(BOOL finished) {
            [self setupTimer];
            [self.spinner startAnimating];
        }];
    }];
}

- (void)setupTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)updateTimer {
    static int n = 20;
    
    if (n > 0) {
        self.label.text = [NSString stringWithFormat:@"%d", n--];
    } else {
        self.label.text = nil;
        [self removeTimer];
        [self.spinner stopAnimating];
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
        self.label.text = @"发送验证码";
        
        CABasicAnimation *anim = [[CABasicAnimation alloc] init];
        anim.keyPath = @"cornerRadius";
        anim.fromValue = @(btnH * scale * 0.5);
        anim.toValue = @(originCornerR);
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