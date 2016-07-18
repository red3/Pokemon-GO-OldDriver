//
//  ViewController.m
//  TestDylib
//
//  Created by Herui on 14/7/2016.
//  Copyright © 2016 hirain. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <objc/runtime.h>



@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.mapView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"c" style:UIBarButtonItemStyleDone target:self action:@selector(itemClicked:)];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)itemClicked:(UIBarButtonItem *)item {
    static BOOL enabel = YES;
    if (enabel) {
        [self.locationManager stopUpdatingLocation];
    } else {
        [self.locationManager startUpdatingLocation];
    }
    enabel = !enabel;
}



- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *loc = locations[0];
    CLLocationCoordinate2D coor = loc.coordinate;
    NSLog(@"lai : %f, long : %f", coor.latitude, coor.longitude);
    
    double miles = 0.1;
    double scalingFactor = ABS( (cos(2 * M_PI * loc.coordinate.latitude / 360.0) ));
    
    MKCoordinateSpan span;
    
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    
    self.mapView.region = MKCoordinateRegionMake(loc.coordinate, span);
    self.mapView.centerCoordinate = coor;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error  {
    NSLog(@"error");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
