//
//  CLLocationManager+Fake.m
//  FakeLib
//
//  Created by Herui on 15/7/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>
#import "HHLocationService.h"

@interface CLLocationManager (Fake)

@end

@implementation CLLocationManager (Fake)

+ (void)load {
    Method m1 = class_getInstanceMethod(self, @selector(setDelegate:));
    Method m2 = class_getInstanceMethod(self, @selector(setDelegate_:));
    
    method_exchangeImplementations(m1, m2);
    
}

- (void)setDelegate_:(id<CLLocationManagerDelegate>)delegate {
    
    [HHLocationService shareService].holderLocationManager = self;
    NSLog(@"hold manager : %@, and his delegate is %@", self, delegate);
    [self setDelegate_:delegate];
}

@end
