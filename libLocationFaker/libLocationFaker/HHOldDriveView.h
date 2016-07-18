//
//  HHOldDriveView.h
//  TestDylib
//
//  Created by Herui on 15/7/2016.
//  Copyright © 2016 hirain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat x;
    CGFloat y;
} HHLocationCoordinate2D;

@protocol HHOldDriveViewDelegate;
@interface HHOldDriveView : UIView

+ (HHOldDriveView *)ordDriverView;

@property (nonatomic, weak) id <HHOldDriveViewDelegate> delegate;

@property (nonatomic) CGFloat xIncreaseSteps;
@property (nonatomic) CGFloat yIncreaseSteps;

@end

@protocol HHOldDriveViewDelegate <NSObject>

@optional
- (void)oldDriveView:(HHOldDriveView *)oldDriveView didDriveToLocation:(HHLocationCoordinate2D)location;

- (void)oldDriveViewDidClickDriveButton:(HHOldDriveView *)oldDriveView;


@end
