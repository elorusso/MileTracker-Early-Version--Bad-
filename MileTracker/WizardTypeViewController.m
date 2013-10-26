//
//  WizardTypeViewController.m
//  MileTracker
//
//  Created by Emanuel on 10/6/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "WizardTypeViewController.h"
#import "WizardVehicleViewController.h"

@interface WizardTypeViewController ()

@end

@implementation WizardTypeViewController

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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Not Complete" message:@"Please select a type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        WizardVehicleViewController *vehicleView=[[WizardVehicleViewController alloc]initWithNibName:@"TypeViewController" bundle:nil];
        vehicleView.title = @"Vehicle";
        vehicleView.vehicleDelegate = self.nextDelegate;
        vehicleView.nextDelegate = self.nextDelegate;
        [self.delegate userDidSelectType:self.selectedCatagory];
        [self.navigationController pushViewController:vehicleView animated:YES];
    }
}

@end
