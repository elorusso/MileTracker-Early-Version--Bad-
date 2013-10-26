//
//  WizardMapViewController.h
//  MileTracker
//
//  Created by Emanuel on 10/6/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>



@protocol WizardDelegate <NSObject>
- (void)addMiles:(NSString *)miles date:(NSString *)date origin:(NSString *)origin destination:(NSString *)destination;
@end

@interface WizardMapViewController : MapViewController <UITextFieldDelegate>

@property (nonatomic, strong) id <WizardDelegate> delegate1;
@property (strong, nonatomic) id nextDelegate;
@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) UILabel *countDownLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) int errorCount;

@end
