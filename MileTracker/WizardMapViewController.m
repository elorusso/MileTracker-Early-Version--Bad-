//
//  WizardMapViewController.m
//  MileTracker
//
//  Created by Emanuel on 10/6/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "WizardMapViewController.h"
#import "WizardExpenseViewController.h"

@interface WizardMapViewController ()

-(void)reverseGeocode;
-(void)countDown;
-(void)findDestination;

@end

@implementation WizardMapViewController

@synthesize delegate1 = _delegate1;
@synthesize dateString = _dateString;
@synthesize address = _address;
@synthesize countDownLabel = _countDownLabel;
@synthesize activityIndicator = _activityIndicator;
@synthesize errorCount = _errorCount;
@synthesize nextDelegate = _nextDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        [self.activityIndicator startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.activityIndicator];
        
        self.errorCount = 0;
    }
    return self;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.trackToggle.title = @"Pause";
    self.trackToggle.tintColor = [UIColor colorWithRed:.9 green:0 blue:0 alpha:1];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    
    self.miles = 0.0;
    self.milesLabel.text = @"0.0 mi";
    
    self.mapView.hidden = YES;
    self.followToggle.hidden = YES;
    self.milesLabel.hidden = YES;
    
    [self countDown];
}

- (void)viewDidUnload {
    [self setDelegate1:nil];
    [self setDateString:nil];
    [self setAddress:nil];
    [self setCountDownLabel:nil];
    [self setActivityIndicator:nil];
    [self setNextDelegate: nil];
    
    [super viewDidUnload];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - other methods

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

- (void)savePressed {
    self.tracking = NO;
    [self.activityIndicator startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.activityIndicator];
    
    [self findDestination];
    
    
}

-(void)reverseGeocode {
    //get current location and find the address
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];   
    [geocoder reverseGeocodeLocation: self.locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         if (!error) {
             self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(savePressed)];
             
             self.mapView.hidden = NO;
             self.followToggle.hidden = NO;
             self.milesLabel.hidden = NO;
             self.tracking  = YES; //start tracking
             self.countDownLabel.hidden = YES;  //hide count down
             self.oldLocation = nil;
             
             //Get address
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             //String to address
             self.address = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"]componentsJoinedByString:@", "];
             
         }
         
         else {
             self.errorCount++;
             if (self.errorCount == 2) {
                 self.errorCount = 0;
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error finding origin" message:@"Please enter the origin of the trip." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                 [alert textFieldAtIndex:0].enablesReturnKeyAutomatically = YES;
                 [alert textFieldAtIndex:0].delegate = self;
                 [alert textFieldAtIndex:0].placeholder = @"Origin";
                 [alert show];
                 
             }
             else {
                 [self reverseGeocode];
             }         }
     }];
}

-(void)findDestination {
    NSString *origin = [[NSString alloc]initWithString:self.address];
    
    //get current location and find the address
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation: self.locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         if (!error) {             
             //Get address
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             //String to address
             self.address = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"]componentsJoinedByString:@", "];
             
             [self.delegate1 addMiles: self.milesLabel.text date:self.dateString origin:origin destination:self.address];
             WizardExpenseViewController *notes = [[WizardExpenseViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
             notes.expenseDelegate = self.nextDelegate;
             notes.nextDelegate = self.nextDelegate;
             notes.title = @"Expenses ($)";
             [self.navigationController pushViewController:notes animated:YES];
         }
         
         else {
             self.errorCount++;
             if (self.errorCount == 2) {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error finding destination" message:@"Please enter the destination of the trip." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                 [alert textFieldAtIndex:0].enablesReturnKeyAutomatically = YES;
                 [alert textFieldAtIndex:0].delegate = self;
                 [alert textFieldAtIndex:0].placeholder = @"Destination";
                 [alert show];
                 
             }
             else {
                 [self findDestination];
             }
         }
     }];
}
////////////////////////////////////////////////////////////////////////////////////
#pragma mark - countdown methods

-(void)countDown {
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 150, 250, 50)];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.font = [UIFont systemFontOfSize:17];
    countLabel.text = @"Finding Current Location...";
    [self.view addSubview:countLabel];
    self.countDownLabel = countLabel;
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reverseGeocode) userInfo:nil repeats:NO];
}
////////////////////////////////////////////////////////////////////////////////////
#pragma mark - delegate methods

-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.address = textField.text;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if ([alertView.title isEqualToString:@"Error finding origin"]) {
        [[alertView textFieldAtIndex:0]endEditing:YES];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
        
        self.mapView.hidden = NO;
        self.followToggle.hidden = NO;
        self.milesLabel.hidden = NO;
        self.tracking  = YES; //start tracking
        self.countDownLabel.hidden = YES;
    }
    else if ([alertView.title isEqualToString:@"Error finding destination"]) {
        NSString *origin = self.address;
        [[alertView textFieldAtIndex:0]endEditing:YES];
        [self.delegate1 addMiles:self.milesLabel.text date:self.dateString origin:origin destination:self.address];
        WizardExpenseViewController *notes = [[WizardExpenseViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
        notes.expenseDelegate = self.nextDelegate;
        notes.nextDelegate = self.nextDelegate;
        notes.title = @"Expenses ($)";
        [self.navigationController pushViewController:notes animated:YES];
    }
}
@end
