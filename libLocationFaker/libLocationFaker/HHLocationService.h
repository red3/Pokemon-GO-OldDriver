//
//  HHLocationService.h
//  TestDylib
//
//  Created by Herui on 15/7/2016.
//  Copyright © 2016 hirain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "HHOldDriveView.h"

@interface HHLocationService : NSObject <HHOldDriveViewDelegate>

+ (HHLocationService *)shareService;
@property (nonatomic) CLLocationCoordinate2D previousLocation;
// default to be 0.00002
@property (nonatomic) float step;


@property (nonatomic, strong) HHOldDriveView *holderDriveView;
@property (nonatomic, weak) CLLocationManager *holderLocationManager;


+ (float)headingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc;
+ (CLLocationDistance)distanceForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc;



@end
