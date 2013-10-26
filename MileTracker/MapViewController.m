//
//  MapViewController.m
//  MileTracker
//
//  Created by Emanuel on 9/24/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize locationManager = _locationManager, oldLocation = _oldLocation;
@synthesize trackToggle = _trackToggle, tracking = _tracking, miles = _miles;
@synthesize milesLabel = _milesLabel;
@synthesize followToggle = _followToggle;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
        self.navigationItem.rightBarButtonItem = save;
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
        [self.navigationItem setLeftBarButtonItem:backButton];
        
        self.tracking = NO;
        self.miles = 0;
    }
    return self;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle
- (void)viewDidLoad
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor,
                                [UIColor clearColor ], UITextAttributeTextShadowColor, nil];
    [self.trackToggle setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.trackToggle.tintColor = [UIColor colorWithRed:0 green:.76 blue:0 alpha:1];
    
    CGRect newframe = self.followToggle.frame;
    newframe.origin.y = self.view.frame.size.height - (44 + self.followToggle.frame.size.height);
    self.followToggle.frame = newframe;
    
    MKCoordinateRegion region;
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.latitudeDelta = .01f;
    region.span.longitudeDelta = .01f;
    [self.mapView setRegion:region animated:YES];
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 13.0;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    self.oldLocation = self.locationManager.location;
    self.milesLabel.text = self.milesLabelText;
    self.miles = [self.milesLabelText floatValue];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setTrackToggle:nil];
    [self setMilesLabel:nil];
    [self setFollowToggle:nil];
    [self setLocationManager:nil];
    [self setDelegate:nil];
    [self setOldLocation:nil];
    [self setMilesLabelText:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - map and location methods
- (IBAction)mapType:(UIBarButtonItem *)sender {
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            self.milesLabel.textColor = [UIColor blackColor];
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            self.milesLabel.textColor = [UIColor whiteColor];
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            self.milesLabel.textColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
}

- (IBAction)toggleTracking:(UIBarButtonItem *)sender {
    if (!self.tracking) {
        self.tracking = YES;
        sender.title = @"Pause";
        sender.tintColor = [UIColor colorWithRed:.9 green:0 blue:0 alpha:1];
    }
    else {
        self.tracking = NO;
        sender.title = @"Resume";
        sender.tintColor = [UIColor colorWithRed:0 green:.76 blue:0 alpha:1];
    }
}

- (IBAction)toggleFollowing:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
    else {
        sender.selected = NO;
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (self.tracking) {
        CLLocation *newLocation = [locations objectAtIndex:locations.count - 1];  //get the newest location
        float new_distance = [newLocation distanceFromLocation:self.oldLocation] / 1000; //kilometers
        if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"units"]isEqualToString:@" mi"]) {
            new_distance = new_distance * 0.621371192; //convert to miles
        }
        NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
        format.maximumFractionDigits = 2;
        format.minimumFractionDigits = 1;
        format.minimumIntegerDigits = 1;
        format.roundingMode = NSRoundUp;
        self.miles = self.miles + new_distance;   
        NSString *new = [format stringFromNumber:[NSNumber numberWithFloat:self.miles]];
        new = [new stringByAppendingString:[[NSUserDefaults standardUserDefaults]stringForKey:@"units"]];
        self.milesLabel.text = new;
        self.oldLocation = newLocation;
    }
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (self.followToggle.selected == YES) {
        CGPoint center = [self.mapView convertCoordinate:self.mapView.centerCoordinate toPointToView:self.view];
        CGPoint user = [self.mapView convertCoordinate:self.mapView.userLocation.coordinate toPointToView:self.view];
        float x_difference = center.x - user.x;
        float y_difference = center.y - user.y;
        if (fabsf(x_difference) >= 10 || fabsf(y_difference) >= 10) {
            self.followToggle.selected = NO;
            [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
        }
        else {
            self.followToggle.selected = YES;
            [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
        }
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - other methods
-(void)back {
    if ([self.milesLabel.text isEqualToString:[@"0.0" stringByAppendingString:[[NSUserDefaults standardUserDefaults] stringForKey:@"units"]]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Conformation" message:@"Are you sure you want to exit without saving?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && [alertView.title isEqualToString:@"Conformation"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (buttonIndex == 1 && [alertView.title isEqualToString:@"Reset"]) {
        self.miles = 0.0;
        self.milesLabel.text = @"0.0 mi";
    }
}

- (IBAction)resetMiles:(UIBarButtonItem *)sender {
    UIAlertView *reset_alert = [[UIAlertView alloc] initWithTitle:@"Reset" message:@"Are you sure you want to reset the distance recorded? All the progress made will be lost." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [reset_alert show];
}

- (void)savePressed {
    [self.delegate userDidTrackMiles:self.milesLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
