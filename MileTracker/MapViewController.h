//
//  MapViewController.h
//  MileTracker
//
//  Created by Emanuel on 9/24/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol MapViewControllerDelegate <NSObject>
- (void)userDidTrackMiles:(NSString *)miles;
@end

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *trackToggle;
@property (weak, nonatomic) IBOutlet UILabel *milesLabel;
@property (weak, nonatomic) IBOutlet UIButton *followToggle;
@property (nonatomic) float miles;
@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;
@property (nonatomic) BOOL tracking;
@property (nonatomic, retain) CLLocation *oldLocation;
@property (nonatomic, retain) NSString *milesLabelText;

- (void)back;
- (void)savePressed;

- (IBAction)mapType:(UIBarButtonItem *)sender;
- (IBAction)toggleTracking:(UIBarButtonItem *)sender;
- (IBAction)toggleFollowing:(UIButton *)sender;
- (IBAction)resetMiles:(UIBarButtonItem *)sender;

@end
