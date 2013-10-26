//
//  WizardNotesViewController.h
//  MileTracker
//
//  Created by Emanuel on 10/28/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "InfoViewController.h"

@protocol WizardNotesDelegate <NSObject>
- (void) createTripWithNotes:(NSString *)notes;
@end

@interface WizardNotesViewController : InfoViewController

@property (strong, nonatomic) id <WizardNotesDelegate> notesDelegate;

@end
