//
//  VehicleViewController.m
//  MileTracker
//
//  Created by Emanuel on 10/17/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "VehicleViewController.h"

@interface VehicleViewController ()

-(NSString *)dataFilePath;
-(NSMutableArray *)readVehiclesFromPlist;

@end

@implementation VehicleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.catagories = [self readVehiclesFromPlist];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - plist methods
-(NSString *)dataFilePath {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"Data.plist"];
}

- (NSMutableArray *)readVehiclesFromPlist {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:[self dataFilePath]];
        return [[array objectAtIndex:1]mutableCopy];
    }
    return nil;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - other methods

- (void)save_pressed {
    if (!self.selectedCatagory) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Not Complete" message:@"Please select a vehicle." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [self.vehicleDelegate userDidSelectVehicle:self.selectedCatagory];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
