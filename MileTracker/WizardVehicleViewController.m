//
//  WizardVehicleViewController.m
//  MileTracker
//
//  Created by Emanuel on 10/18/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "WizardVehicleViewController.h"
#import "WizardMapViewController.h"

@interface WizardVehicleViewController ()

@end

@implementation WizardVehicleViewController

@synthesize nextDelegate = _nextDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(save_pressed)];
        self.navigationItem.rightBarButtonItem = save;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload {
    [self setNextDelegate:nil];
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save_pressed {
    if (!self.selectedCatagory) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Not Complete" message:@"Please select a vehicle." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        WizardMapViewController *mapView =[[WizardMapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
        mapView.title = @"Map";
        mapView.delegate1 = self.nextDelegate;
        mapView.nextDelegate= self.nextDelegate;
        [self.vehicleDelegate userDidSelectVehicle:self.selectedCatagory];
        [self.navigationController pushViewController:mapView animated:YES];
    }
}

@end
