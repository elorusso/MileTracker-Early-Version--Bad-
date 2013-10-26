//
//  TripsViewController.m
//  MileTracker
//
//  Created by Emanuel on 9/17/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "TripsViewController.h"
#import "TripCell.h"
#import "WizardInfoViewController.h"


@interface TripsViewController () {
    NSNumberFormatter *moneyFormat;
}

- (void)resetTripsList;

@end

@implementation TripsViewController

@synthesize catagory_names = _catagory_names;
@synthesize trips_list = _trips_list;
@synthesize tripsTable = _tripsTable;
@synthesize bannerIsVisible = _bannerIsVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Trips", @"Trips");
        
        self.catagory_names = [[NSMutableArray alloc]initWithObjects:@"Business", @"Personal", @"Charity", @"Medical", @"Other", nil];
        
        self.trips_list = [[NSMutableArray alloc]init];
        
        self.trips_list = [self readTripsFromPlist];      //revert to saved trips
        
        if (self.trips_list == nil) {                      //if the list is empty reset it
            [self resetTripsList];
            [self writeToPlist];
        }
        
        //set up formater
        moneyFormat = [[NSNumberFormatter alloc]init];
        moneyFormat.maximumFractionDigits = 2;
        moneyFormat.minimumFractionDigits = 2;
        moneyFormat.minimumIntegerDigits = 1;
    }
    return self;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.frame = CGRectOffset(adView.frame, 0, 499);
    [self.view addSubview:adView];
    adView.delegate = self;
    self.bannerIsVisible = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tripsTable reloadData];
}

- (void)viewDidUnload {
    [self setTripsTable:nil];
    [self setTrips_list:nil];
    [self setCatagory_names:nil];
    
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
        CGRect rect = self.tripsTable.frame;
        rect.size.height = self.view.frame.size.height - 50;
        self.tripsTable.frame = rect;
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
        CGRect rect = self.tripsTable.frame;
        rect.size.height = self.view.frame.size.height;
        self.tripsTable.frame = rect;
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
    return [[self.trips_list objectAtIndex:section]count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.catagory_names objectAtIndex:section];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.catagory_names count];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = [[[self.trips_list objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"trip type"];
    if (!type) {
        return NO;
    }
    else {
        return YES;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //create the cell
    TripCell *cell = (TripCell *)[tableView dequeueReusableCellWithIdentifier:@"Trip"];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TripCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[TripCell class]]) {
                cell = (TripCell *)currentObject;
                break;
            }
        }
    }
    
    NSDictionary *trip = [[self.trips_list objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    //fill the cell with info
    cell.name.text =[trip objectForKey:@"trip name"];
    cell.notes.text = [trip objectForKey:@"trip vehicle"];
    cell.from_to.text = [trip objectForKey:@"trip origin"];
    cell.miles.text = [trip objectForKey:@"trip miles"];
    cell.date.text = [trip objectForKey:@"trip start date"];
    double totalSavings = 0;
    cell.savingsLabel.text = @"";
    if (![[trip objectForKey:@"trip type"] isEqualToString:@"Personal"] && ![[trip objectForKey:@"trip type"] isEqualToString:@"Other"] && [trip objectForKey:@"trip type"]) {
        totalSavings = [[[trip objectForKey:@"trip expenses"] substringFromIndex:1] doubleValue] + [[trip objectForKey:@"trip savings"]doubleValue];
    }
    
    //set the accessories
    if (![[[self.trips_list objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"trip type"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.savingsLabel.text = [@"$" stringByAppendingString:[moneyFormat stringFromNumber:[NSNumber numberWithDouble:totalSavings]]];
    }
    return cell;
}
    

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[self.trips_list objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([[self.trips_list objectAtIndex:indexPath.section] count] == 0) {
            [[self.trips_list objectAtIndex:indexPath.section] addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"No Trips", @"trip name", nil]];
            [self.tripsTable reloadData];
        }
    }
    [self writeToPlist];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[[self.trips_list objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"trip type"] != nil) {
        DetailViewController *view = [[DetailViewController alloc] init];
        
        NSArray *keys = [[NSArray alloc]initWithObjects:@"trip start date", @"trip name", @"trip type", @"trip origin", @"trip destination", @"trip notes", @"trip vehicle", @"trip miles", @"trip expenses", @"trip savings", nil]; //list of all the keys to the data in order that they appear on the next view
        NSMutableDictionary *trip = [[self.trips_list objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        
        view.title = @"Edit Trip";
        view.indexOfCellEditing = indexPath;
        view.delegate = self;
        
        int index = 0;
        
        for (NSMutableArray *sections in view.data.cells) {
            for (NSMutableDictionary *detail in sections) {    //for each detail
                  //set the detail to the object with the corresponding key
                [detail setObject:[trip objectForKey:[keys objectAtIndex:index]] forKey:@"detail"];
                index++;  //increment index
                
            }
        }
        
        UINavigationController *navigationController = [[UINavigationController alloc]init];
        
        navigationController.viewControllers = @[ view ];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - delegate methods

- (void)addTrip:(NSMutableDictionary *)trip {
    for (NSString *catagory in self.catagory_names) {
        if ([catagory isEqualToString:[trip objectForKey:@"trip type"]]) {
            if ([[[self.trips_list objectAtIndex:[self.catagory_names indexOfObject:catagory]]objectAtIndex:0]objectForKey:@"trip type"] == nil) {
                [[self.trips_list objectAtIndex:[self.catagory_names indexOfObject:catagory]]setObject:trip atIndex:0];
            }
            else {
                [[self.trips_list objectAtIndex:[self.catagory_names indexOfObject:catagory]]insertObject:trip atIndex:0];
            }
        }
    }
    [self writeToPlist];
}

- (void)editTripAtIndexPath:(NSIndexPath *)indexPath name:(NSString *)name type:(NSString *)type origin:(NSString *)origin destination:(NSString *)destination notes:(NSString *)notes startDate:(NSString *)startDate miles:(NSString *)miles andVehicle:(NSString *)vehicle expense:(NSString *)expense savings:(NSString *)savings
{
    NSArray *details = [[NSArray alloc]initWithObjects:name, type, origin, destination, notes, startDate, miles, vehicle, expense, savings, nil];
    NSArray *keys = [[NSArray alloc]initWithObjects:@"trip name", @"trip type", @"trip origin", @"trip destination", @"trip notes", @"trip start date", @"trip miles", @"trip vehicle", @"trip expenses", @"trip savings", nil];
    NSMutableDictionary *trip = [[NSMutableDictionary alloc]initWithObjects:details forKeys:keys];
    
    //if the type changed move the trip to a different catagory
    if (![[[[self.trips_list objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"trip type"]isEqualToString:type]) {
        for (NSString *catagory in self.catagory_names) {
            if ([catagory isEqualToString:type]) {
                if ([[[self.trips_list objectAtIndex:[self.catagory_names indexOfObject:catagory]]objectAtIndex:0]objectForKey:@"trip type"] == nil) {
                    [[self.trips_list objectAtIndex:[self.catagory_names indexOfObject:catagory]]setObject:trip atIndex:0];
                }
                
                else {
                    [[self.trips_list objectAtIndex:[self.catagory_names indexOfObject:catagory]]insertObject:trip atIndex:0];
                }
                
                [[self.trips_list objectAtIndex:indexPath.section]removeObjectAtIndex:indexPath.row];
                
                if ([[self.trips_list objectAtIndex:indexPath.section]count] == 0) {
                    [[self.trips_list objectAtIndex:indexPath.section] addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"No Trips", @"trip name", nil]];
                }
            }
        }
    }
    else {
        [[self.trips_list objectAtIndex:indexPath.section]replaceObjectAtIndex:indexPath.row withObject:trip];
    }
    
    [self.tripsTable reloadData];
    [self writeToPlist];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - plist methods
-(NSString *)dataFilePath {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"Data.plist"];
}

- (void)writeToPlist {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        NSMutableArray *array = [[[NSArray alloc]initWithContentsOfFile:[self dataFilePath]]mutableCopy];
        [array replaceObjectAtIndex:0 withObject:self.trips_list];
        [array writeToFile:[self dataFilePath] atomically:YES];
    }
    else {
        NSArray *data = self.trips_list;
        NSArray *vehicles = [[NSArray alloc]initWithObjects:@"Vehicle #1", nil];
        NSArray *file = [[NSArray alloc] initWithObjects:data, vehicles, nil];
        [file writeToFile:[self dataFilePath] atomically:YES];
    }
}

- (NSMutableArray *)readTripsFromPlist {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:[self dataFilePath]];
        return [[array objectAtIndex:0]mutableCopy];
    }
    return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - other methods

- (void)resetTripsList {
    self.trips_list = [[NSMutableArray alloc]init];
    for (NSString *catagory in self.catagory_names) {
        [self.trips_list addObject:[[NSMutableArray alloc]initWithObjects:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"No Trips", @"trip name", nil], nil]];
    }
}
- (IBAction)edit_pressed:(UIBarButtonItem *)sender {
    if(self.tripsTable.editing == YES)
    {
        [self.tripsTable setEditing:NO animated:YES];
        sender.style = UIBarButtonItemStyleBordered;
    }
    else
    {
        [self.tripsTable setEditing:YES animated:YES];
        sender.style = UIBarButtonItemStyleDone;
    }
}

- (IBAction)add_pressed:(UIBarButtonItem *)sender {
    UINavigationController *navigationController = [[UINavigationController alloc]init];
    WizardInfoViewController *view = [[WizardInfoViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
    NewTripData *data = [[NewTripData alloc]init];
    data.delegate = self;
    view.title = @"Purpose";
    view.delegate = data;
    view.nextDelegate = data;
    navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController.viewControllers = @[ view ];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
