//
//  TypeViewController.m
//  MileTracker
//
//  Created by Emanuel on 9/23/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "TypeViewController.h"

@interface TypeViewController () {
}

- (void)save_pressed;

@end

@implementation TypeViewController

@synthesize catagories = _catagories;
@synthesize selectedCatagory = _selectedCatagory;
@synthesize delegate = _delegate;
@synthesize bannerIsVisible = _bannerIsVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //nameing the cells
        self.catagories = [[NSMutableArray alloc]initWithObjects:@"Business", @"Personal", @"Charity", @"Medical", @"Other", nil];
        //add save button to top right corner
        UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save_pressed)];
        self.navigationItem.rightBarButtonItem = save;
    }
    return self;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.frame = CGRectOffset(adView.frame, 0, 504);
    [self.view addSubview:adView];
    adView.delegate = self;
    self.bannerIsVisible = NO;
}

- (void)viewDidUnload
{
    [self setCatagories:nil];
    [self setSelectedCatagory:nil];
    [self setDelegate:nil];
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
    }
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        CGRect newrect = banner.frame;
        newrect.origin.y = 504;
        banner.frame = newrect;
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - tableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.catagories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"typeCell";
    //creating the cell
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //filling the cell with info
    cell.textLabel.text = [self.catagories objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //remove checkmark from other cells and add it to the selected cell
    for (UITableViewCell *cell in [tableView visibleCells]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedCatagory = [self.catagories objectAtIndex:indexPath.row];
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - other methods

- (void)save_pressed {
    if (!self.selectedCatagory) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Not Complete" message:@"Please select a type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [self.delegate userDidSelectType:self.selectedCatagory];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
