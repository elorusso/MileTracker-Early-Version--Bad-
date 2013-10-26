//
//  DetailViewController.m
//  MileTracker
//
//  Created by Emanuel on 9/20/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "DetailViewController.h"
#import "InfoViewController.h"
#import "TypeViewController.h"
#import "DateViewController.h"
#import "MapViewController.h"
#import "VehicleViewController.h"
#import "ExpensesViewController.h"
#import "NewTripData.h"

@interface DetailViewController () {
}

- (void)cancel_pressed;

- (void)pushView:(UIViewController *)view withIndexPath: (NSIndexPath *)indexPath;

- (void)savePressed;
@end

@implementation DetailViewController

@synthesize section_names = _section_names;
@synthesize detailTable = _detailTable, indexOfCellEditing = _indexOfCellEditing;
@synthesize data = _data;
@synthesize delegate = _delegate;
@synthesize bannerIsVisible = _bannerIsVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.indexOfCellEditing = nil;
        self.data = [[NewTripData alloc]init];
        
        //add cancel button to the navigation bar
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel_pressed)];
        self.navigationItem.leftBarButtonItem = cancel;
        
        //add save button to the navigation bar
        UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
        self.navigationItem.rightBarButtonItem = save;
        
        self.section_names = [[NSMutableArray alloc]initWithObjects:@"Date", @"Information", @"Tracking", nil]; //Naming the sections
    }
    return self;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cylcle

- (void)viewDidLoad
{
    [super viewDidLoad];
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.frame = CGRectOffset(adView.frame, 0, 499);
    [self.view addSubview:adView];
    adView.delegate = self;
    self.bannerIsVisible = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.detailTable reloadData];
}

- (void)viewDidUnload
{
    [self setDetailTable:nil];
    [self setSection_names:nil];
    [self setData:nil];
    [self setDelegate:nil];
    [self setIndexOfCellEditing:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - iAd banner methods

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        CGRect newrect = banner.frame;
        newrect.origin.y = self.view.frame.size.height - 50;
        banner.frame = newrect;
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
        CGRect rect = self.detailTable.frame;
        rect.size.height = self.view.frame.size.height - 50;
        self.detailTable.frame = rect;
    }
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        CGRect newrect = banner.frame;
        newrect.origin.y = 499;
        banner.frame = newrect;
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
        CGRect rect = self.detailTable.frame;
        rect.size.height = self.view.frame.size.height;
        self.detailTable.frame = rect;
    }
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    BOOL shouldExecuteAction  = YES;
    if (!willLeave && shouldExecuteAction) {
        //stop all interaction procces  in the app
        //[video pause];
        //[audio pause];
    }
    return shouldExecuteAction;
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner {
    //resume everything youʻve stoped
    //[video resume];
    //[audio resume];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - tableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.data.cells objectAtIndex:section]count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.section_names count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //create the cell
    static NSString *cellIdentifier = @"properties";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    //fill the cell with info
    cell.textLabel.text =[[[self.data.cells objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"title"];
    cell.detailTextLabel.text = [[[self.data.cells objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"detail"];
    
    //set the accessories
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([cell.textLabel.text isEqualToString:@"Savings"]) cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.data.cellCurrentlyEdited = indexPath;
    
    if ([[[self.data.cells objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"title"] == @"Type") {
        TypeViewController *type = [[TypeViewController alloc]init];
        type.delegate = self.data;
        [self pushView:type withIndexPath:indexPath];
    }
    else if ([[self.section_names objectAtIndex:indexPath.section] isEqualToString:@"Information"]) {
        InfoViewController *info = [[InfoViewController alloc]init];
        info.text = [[[self.data.cells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"detail"];
        info.delegate = self.data;
        [self pushView:info withIndexPath:indexPath];
    }
    else if ([self.section_names objectAtIndex:indexPath.section] == @"Date") {
        DateViewController *date = [[DateViewController alloc]init];
        date.delegate = self.data;
        [self pushView:date withIndexPath:indexPath];
    }
    else if ([[[self.data.cells objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"title"] == @"Map") {
        MapViewController *map = [[MapViewController alloc]init];
        map.delegate = self.data;
        map.miles = [[[[self.data.cells objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"detail"] floatValue];
        map.milesLabelText = [[[self.data.cells objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"detail"];
        [self pushView:map withIndexPath:indexPath];
    }
    else if ([[[self.data.cells objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"title"] == @"Vehicle") {
        VehicleViewController *vehicleView = [[VehicleViewController alloc]initWithNibName:@"TypeViewController" bundle:nil];
        vehicleView.vehicleDelegate = self.data;
        [self pushView:vehicleView withIndexPath:indexPath];
    }
    else if ([[[self.data.cells objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"title"] == @"Expenses"){
        ExpensesViewController *expenseView = [[ExpensesViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
        expenseView.expenseDelegate = self.data;
        expenseView.expense = [[[self.data.cells objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"detail"];
        [self pushView:expenseView withIndexPath:indexPath];
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - other methods

- (void)cancel_pressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushView:(UIViewController *)view withIndexPath:(NSIndexPath *)indexPath {
    view.title = [[[self.data.cells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectForKey:@"title"];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)savePressed {
    NSString *name = @"";
    NSString *type = @"";
    NSString *origin = @"";
    NSString *destination = @"";
    NSString *notes = @"...";
    NSString *startDate = @"";
    NSString *miles = @"";
    NSString *vehicle = @"";
    NSString *expense = @"";
    NSString *savings = @"";
    
    for (NSMutableArray *cell in self.data.cells) {
        for (NSMutableDictionary *trip in cell) {
            if ([[trip objectForKey:@"title"] isEqualToString:@"Date"]) {
                startDate = [trip objectForKey:@"detail"];
            }
            else if ([[trip objectForKey:@"title"] isEqualToString:@"Purpose"]) {
                name = [trip objectForKey:@"detail"];
            }
            else if ([[trip objectForKey:@"title"] isEqualToString:@"Type"]) {
                type = [trip objectForKey:@"detail"];
            }
            else if ([[trip objectForKey:@"title"] isEqualToString:@"Origin"]) {
                origin = [trip objectForKey:@"detail"];
            }
            else if ([[trip objectForKey:@"title"] isEqualToString:@"Destination"]) {
                destination = [trip objectForKey:@"detail"];
            }
            else if ([[trip objectForKey:@"title"] isEqualToString:@"Map"]) {
                if (![[trip objectForKey:@"detail"]isEqualToString:@"0.0"]) {
                    miles = [trip objectForKey:@"detail"];
                }
            }
            else if ([[trip objectForKey:@"title"] isEqualToString:@"Notes"]) {
                notes = [trip objectForKey:@"detail"];
            }
            else if ([[trip objectForKey:@"title"] isEqualToString:@"Vehicle"]) {
                vehicle = [trip objectForKey:@"detail"];
            }
            else if ([[trip objectForKey:@"title"] isEqualToString:@"Expenses"]) {
                expense = [trip objectForKey:@"detail"];
            }
            else if ([[trip objectForKey:@"title"] isEqualToString:@"Savings"]) {
                savings = [trip objectForKey:@"detail"];
            }
        }
    }
    
    if (type == @"" || name == @"") {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Incomplete Trip" message:@"Please set the Name and the Type of the Trip" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    }
    else {
        [self.delegate editTripAtIndexPath:self.indexOfCellEditing name:name type:type origin:origin destination:destination notes:notes startDate:startDate miles:miles andVehicle:vehicle expense:expense savings:savings];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@end
