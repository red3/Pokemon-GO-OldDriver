//
//  HHLocationService.m
//  TestDylib
//
//  Created by Herui on 15/7/2016.
//  Copyright © 2016 hirain. All rights reserved.
//

#import "HHLocationService.h"

@implementation HHLocationService

+ (HHLocationService *)shareService {
    static dispatch_once_t onceToken;
    static HHLocationService *service;
    dispatch_once(&onceToken, ^{
        service = [[HHLocationService alloc] init];
    });
    return service;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _step = 0.00002;
    return self;
}

#pragma mark - Delegate
- (void)oldDriveViewDidClickDriveButton:(HHOldDriveView *)oldDriveView {
    if (self.holderLocationManager) {
        [self.holderLocationManager stopUpdatingLocation];
        [self.holderLocationManager startUpdatingLocation];
    }
}

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * 180.0 / M_PI)

+ (float)headingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = degreesToRadians(fromLoc.latitude);
    float fLng = degreesToRadians(fromLoc.longitude);
    float tLat = degreesToRadians(toLoc.latitude);
    float tLng = degreesToRadians(toLoc.longitude);
    
    float degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return degree;
    } else {
        return 360+degree;
    }
}

+ (CLLocationDistance)distanceForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc {
    
    CLLocation *fromL = [[CLLocation alloc] initWithLatitude:fromLoc.latitude longitude:fromLoc.longitude];
    CLLocation *toL = [[CLLocation alloc] initWithLatitude:toLoc.latitude longitude:toLoc.longitude];
    
    return [toL distanceFromLocation:fromL];
    
}





@end
