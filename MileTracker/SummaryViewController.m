//
//  SummaryViewController.m
//  MileTracker
//
//  Created by Emanuel on 9/17/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "SummaryViewController.h"

@interface SummaryViewController () {
    NSNumberFormatter *format;
    NSNumberFormatter *moneyFormat;
}

- (NSMutableArray *)findTotalMiles:(NSString *)key fromIndex:(NSUInteger)index;
- (NSMutableArray *)findAverageMiles:(NSString *)key fromIndex:(NSUInteger)index;
- (NSMutableArray *)findTripsCount;

@end

@implementation SummaryViewController

@synthesize scrollview = _scrollview;
@synthesize catagoriesBubble = _catagoriesBubble;
@synthesize pageControl = _pageControl;
@synthesize totalMilesLabels = _totalMilesLabels;
@synthesize averageMilesLabels = _averageMilesLabels;
@synthesize tripsCountLabels = _tripsCountLabels;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Summary", @"Summary");
        
        format = [[NSNumberFormatter alloc] init];
        format.maximumFractionDigits = 2;
        format.minimumFractionDigits = 1;
        format.minimumIntegerDigits = 1;
        format.roundingMode = NSRoundUp;
        
        moneyFormat = [[NSNumberFormatter alloc]init];
        moneyFormat.maximumFractionDigits = 2;
        moneyFormat.minimumIntegerDigits = 1;
        moneyFormat.minimumFractionDigits = 2;
    }
    return self;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollview.contentSize = CGSizeMake(1600, 347);
    
    for (UIButton *bubble in self.catagoriesBubble) {
        [[bubble layer] setCornerRadius:6];
        [[bubble layer] setMasksToBounds:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.tripsList = [self readTripsFromPlist];
    
    for (UILabel *label in self.totalMilesLabels) {
        NSNumber *total = [[self findTotalMiles:@"trip miles" fromIndex:0] objectAtIndex:[self.totalMilesLabels indexOfObject:label]];
        label.text = [format stringFromNumber:total];
    }
    
    for (UILabel *label in self.averageMilesLabels) {
        NSNumber *average = [[self findAverageMiles:@"trip miles"fromIndex:0] objectAtIndex:[self.averageMilesLabels indexOfObject:label]];
        label.text = [format stringFromNumber:average];
    }
    
    for (UILabel *label in self.tripsCountLabels) {
        label.text = [[self findTripsCount] objectAtIndex:[self.tripsCountLabels indexOfObject:label]];
    }
    
    for (UILabel *label in self.expenseTotalLabels) {
        NSNumber *total = [[self findTotalMiles:@"trip expenses"fromIndex:1]objectAtIndex:[self.expenseTotalLabels indexOfObject:label]];
        label.text = [@"$" stringByAppendingString:[moneyFormat stringFromNumber:total]];
    }
    
    for (UILabel *label in self.averageExpenseLabels) {
        NSNumber *average = [[self findAverageMiles:@"trip expenses"fromIndex:1]objectAtIndex:[self.averageExpenseLabels indexOfObject:label]];
        label.text = [@"$" stringByAppendingString:[moneyFormat stringFromNumber:average]];
    }
    
}

- (void)viewDidUnload
{
    [self setScrollview:nil];
    [self setCatagoriesBubble:nil];
    [self setPageControl:nil];
    [self setTotalMilesLabels:nil];
    [self setAverageMilesLabels:nil];
    [self setTripsCountLabels:nil];
    
    [self setExpenseTotalLabels:nil];
    [self setAverageExpenseLabels:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - delegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x/320;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - plist methods

-(NSString *)dataFilePath {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"Data.plist"];
}

- (NSArray *)readTripsFromPlist {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:[self dataFilePath]];
        return [[array objectAtIndex:0]mutableCopy];
    }
    return nil;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - other methods

- (NSMutableArray *)findTotalMiles:(NSString *)key fromIndex:(NSUInteger)index{
    NSMutableArray *catTotMiles = [[NSMutableArray alloc]init];
    
    for (NSArray *catagory in self.tripsList) {
        double totalMiles = 0;
        for (NSDictionary *trip in catagory) {
            totalMiles += [[[trip objectForKey:key] substringFromIndex:index] doubleValue];
        }
        [catTotMiles addObject:[NSNumber numberWithDouble:totalMiles]];
    }
    return catTotMiles;
}

- (NSMutableArray *)findAverageMiles:(NSString *)key fromIndex:(NSUInteger)index{
    NSMutableArray *averages = [[NSMutableArray alloc]init];
    
    for (NSNumber *total in [self findTotalMiles:key fromIndex:index]) {
        double totalDouble = [total doubleValue];
        int tripCount = [[[self findTripsCount] objectAtIndex:[[self findTotalMiles:key fromIndex:index] indexOfObject:total]] integerValue];
        double average = 0;
        if (tripCount != 0) {
            average = totalDouble/tripCount;
        }
        
        [averages addObject:[NSNumber numberWithDouble:average]];
    }
    return averages;
}

- (NSMutableArray *)findTripsCount {
    NSMutableArray *counts = [[NSMutableArray alloc]init];
    
    for (NSArray *catagory in self.tripsList) {
        int count = 0;
        for (NSDictionary *trip in catagory) {
            if ([trip objectForKey:@"trip type"]) {
                count++;
            }
        }
        [counts addObject:[NSString stringWithFormat:@"%i", count]];
    }
    return counts;
}
@end
