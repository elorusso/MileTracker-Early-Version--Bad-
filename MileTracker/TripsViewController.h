//
//  TripsViewController.h
//  MileTracker
//
//  Created by Emanuel on 9/17/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "DetailViewController.h"
#import "NewTripData.h"

@class DetailViewController;
@class NewTripData;

@interface TripsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DetailViewControllerDelegate, NewTripDataDelegate, ADBannerViewDelegate> {
    ADBannerView *adView;
}

@property (nonatomic, retain) NSMutableArray *catagory_names;
@property (nonatomic, retain) NSMutableArray *trips_list;
@property (strong, nonatomic) IBOutlet UITableView *tripsTable;
@property (nonatomic) BOOL bannerIsVisible;

- (IBAction)edit_pressed:(UIBarButtonItem *)sender;
- (IBAction)add_pressed:(UIBarButtonItem *)sender;

- (NSString *) dataFilePath;
- (void)writeToPlist;
- (NSMutableArray *)readTripsFromPlist;
@end
