//
//  NewTripData.h
//  MileTracker
//
//  Created by Emanuel on 10/6/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoViewController.h"
#import "TypeViewController.h"
#import "DateViewController.h"
#import "MapViewController.h"
#import "WizardMapViewController.h"
#import "WizardInfoViewController.h"
#import "VehicleViewController.h"
#import "WizardNotesViewController.h"
#import "ExpensesViewController.h"

@protocol NewTripDataDelegate <NSObject>
@required
- (void)addTrip:(NSMutableDictionary *)trip;
@end

@interface NewTripData : NSObject <InfoViewControllerDelegate, VehicleViewControllerDelegate, TypeViewControllerDelegate, DateViewControllerDelegate, MapViewControllerDelegate, WizardDelegate, WizardNotesDelegate, ExpenseDelegate> {
}

@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, retain) NSIndexPath *cellCurrentlyEdited;
@property (nonatomic, strong) id <NewTripDataDelegate> delegate;

@end
