//
//  CLLocation+Fake.m
//  TestDylib
//
//  Created by Herui on 15/7/2016.
//  Copyright © 2016 hirain. All rights reserved.
//

// CaptainHook by Ryan Petrich
// see https://github.com/rpetrich/CaptainHook/

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>
#import "HHLocationService.h"
#import "HHOldDriveView.h"



@interface CLLocation(Swizzle)

@end

@implementation CLLocation(Swizzle)

static float x = -1;
static float y = -1;

+ (void)load {
    Method m1 = class_getInstanceMethod(self, @selector(coordinate));
    Method m2 = class_getInstanceMethod(self, @selector(coordinate_));
    
    method_exchangeImplementations(m1, m2);
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"_fake_x"]) {
        x = [[[NSUserDefaults standardUserDefaults] valueForKey:@"_fake_x"] floatValue];
    };
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"_fake_y"]) {
        y = [[[NSUserDefaults standardUserDefaults] valueForKey:@"_fake_y"] floatValue];
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        HHOldDriveView *view = [HHOldDriveView ordDriverView];
        view.delegate = [HHLocationService shareService];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window bringSubviewToFront:view];
        [window addSubview:view];
        
        [HHLocationService shareService].holderDriveView = view;
    });
}

- (CLLocationCoordinate2D) coordinate_ {
    
    CLLocationCoordinate2D pos = [self coordinate_];
    
    //[HHLocationService shareService].previousLocation = pos;
    
    // 算与联合广场的坐标偏移量
    if (x == -1 && y == -1) {
        x = pos.latitude - 37.7883923;
        y = pos.longitude - (-122.4076413);
        
        [[NSUserDefaults standardUserDefaults] setValue:@(x) forKey:@"_fake_x"];
        [[NSUserDefaults standardUserDefaults] setValue:@(y) forKey:@"_fake_y"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    // simulate offset of latitude and longitude
    NSLog(@"### start location req ###");
    NSLog(@"origin latitude : %f, origin longitude : %f", pos.latitude, pos.longitude);
    
    HHOldDriveView *driver = [HHLocationService shareService].holderDriveView;
    CGFloat step = [HHLocationService shareService].step;
    NSLog(@"simulate start and step is : %f", step);
    
    NSLog(@"X up : %f, Y up : %f", driver.xIncreaseSteps, driver.yIncreaseSteps);
    
    pos.longitude += step * driver.xIncreaseSteps;
    pos.latitude += step * driver.yIncreaseSteps;
    NSLog(@"simulate end");
    
    NSLog(@"fake latitude : %f, fake longitude : %f", pos.latitude-x, pos.longitude-y);
    NSLog(@"### end location req ###");
    
    return CLLocationCoordinate2DMake(pos.latitude-x, pos.longitude-y);
}

@end

