//
//  SummaryViewController.h
//  MileTracker
//
//  Created by Emanuel on 9/17/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SummaryViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSMutableArray *catagoriesBubble;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *totalMilesLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *averageMilesLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *tripsCountLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *expenseTotalLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *averageExpenseLabels;

@property (weak, nonatomic) NSArray *tripsList;

- (NSArray *)readTripsFromPlist;
- (NSString *) dataFilePath;
@end
