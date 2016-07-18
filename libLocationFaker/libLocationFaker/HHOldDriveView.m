//
//  HHOldDriveView.m
//  TestDylib
//
//  Created by Herui on 15/7/2016.
//  Copyright © 2016 hirain. All rights reserved.
//

#import "HHOldDriveView.h"

@interface HHOldDriveView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIButton *up;
@property (nonatomic, strong) UIButton *down;
@property (nonatomic, strong) UIButton *left;
@property (nonatomic, strong) UIButton *right;

@property (nonatomic, weak) UIButton *longPressButton;

@end

@implementation HHOldDriveView

- (void)dealloc {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

+ (HHOldDriveView *)ordDriverView {
    return [[HHOldDriveView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self customizeSubView];
    return self;
}

#pragma mark - Func

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

#pragma mark - Event
- (void)buttonClicked:(UIButton *)button {
    
    CGFloat step = 1;
    CGFloat rotationDegree = 0.0;
    
    if (button == self.up) {
        rotationDegree = 0;
    }
    if (button == self.down) {
        rotationDegree = 180;
    }
    if (button == self.left) {
        rotationDegree = 270;
    }
    if (button == self.right) {
        rotationDegree = 90;
    }
    
    
    CGAffineTransform currentTransform = self.transform;
    CGFloat radians = atan2f(currentTransform.b, currentTransform.a);
    
    CGFloat degrees = radians * (180 / M_PI);
    degrees += rotationDegree;
    
    radians = degrees / (180 / M_PI);
    CGFloat x = step * sin(radians);
    CGFloat y = step * cos(radians);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(oldDriveView:didDriveToLocation:)]) {
        HHLocationCoordinate2D loc;
        loc.x = x;
        loc.y = y;
        [self.delegate oldDriveView:self didDriveToLocation:loc];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(oldDriveViewDidClickDriveButton:)]) {
        [self.delegate oldDriveViewDidClickDriveButton:self];
    }
    
    self.xIncreaseSteps += x;
    self.yIncreaseSteps += y;

}

- (void)longPress:(UILongPressGestureRecognizer *)recongizer {
    UIGestureRecognizerState state = recongizer.state;
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        
        UIButton *button = (UIButton *)recongizer.view;
        self.longPressButton = button;
        if (![_timer.fireDate isEqualToDate:[NSDate distantPast]]) {
            [_timer setFireDate:[NSDate distantPast]];
        }
    } else {
        self.longPressButton = nil;
        [_timer setFireDate:[NSDate distantFuture]];
    }
    
}

- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer {
    
    UIGestureRecognizerState state = [gestureRecognizer state];
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        CGFloat rotation = [gestureRecognizer rotation];
        [gestureRecognizer.view setTransform:CGAffineTransformRotate(gestureRecognizer.view.transform, rotation)];
        [gestureRecognizer setRotation:0];
    }
   
}

- (void)move:(UIPanGestureRecognizer *)sender {
    
    UIGestureRecognizerState state = [sender state];
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:sender.view];
        [sender.view setTransform:CGAffineTransformTranslate(sender.view.transform, translation.x, translation.y)];
        [sender setTranslation:CGPointZero inView:sender.view];
    }
}

- (void)startTimer {
    
    [self buttonClicked:self.longPressButton];
    
}

#pragma mark - Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}

#pragma mark - Setter && Getter
- (void)customizeSubView {
    
    NSArray *titles = @[@"N", @"W", @"S", @"E"];
    NSMutableArray *buttons = @[].mutableCopy;
    for (NSString *title in titles) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.delegate = self;
        [button addGestureRecognizer:longPress];
        
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 1.5;
        
        [self addSubview:button];
        [buttons addObject:button];
    }
    self.up = buttons[0];;
    self.up.frame = CGRectMake(40, 0, 40, 40);
    self.down = buttons[2];;
    self.down.frame = CGRectMake(40, 80, 40, 40);
    self.left = buttons[1];;
    self.left.frame = CGRectMake(0, 40, 40, 40);
    self.right = buttons[3];
    self.right.frame = CGRectMake(80, 40, 40, 40);
    
    // rotation
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    [self addGestureRecognizer:rotationGesture];
    
    // pan
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [self addGestureRecognizer:pan];
    
    // timer
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer setFireDate:[NSDate distantFuture]];
    
}





@end
