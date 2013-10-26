//
//  WizardInfoViewController.h
//  MileTracker
//
//  Created by Emanuel on 11/9/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "InfoViewController.h"

@interface WizardInfoViewController : InfoViewController  <UIAlertViewDelegate>

@property (nonatomic, retain) UITextField *textField;
@property (strong, nonatomic) id nextDelegate;

@end