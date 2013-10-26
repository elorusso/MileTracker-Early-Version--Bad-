//
//  DetailViewController.h
//  MileTracker
//
//  Created by Emanuel on 9/20/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class NewTripData;

@protocol DetailViewControllerDelegate <NSObject>
- (void)editTripAtIndexPath:(NSIndexPath *)indexPath name:(NSString *)name type:(NSString *)type origin:(NSString *)origin destination:(NSString *)destination notes:(NSString *)notes startDate:(NSString *)startDate miles:(NSString *)miles andVehicle:(NSString *)vehicle expense:(NSString *)expense savings:(NSString *)savings;
@end

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate> {
    ADBannerView *adView;
}

@property (nonatomic, retain) NSMutableArray *section_names;
@property (strong, nonatomic) IBOutlet UITableView *detailTable;
@property (nonatomic, retain) NSIndexPath *indexOfCellEditing;
@property (weak, nonatomic) id <DetailViewControllerDelegate> delegate;
@property (nonatomic, retain) NewTripData *data;
@property (nonatomic) BOOL bannerIsVisible;

@end
