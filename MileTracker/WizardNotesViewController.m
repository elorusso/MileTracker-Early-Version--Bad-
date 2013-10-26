//
//  WizardNotesViewController.m
//  MileTracker
//
//  Created by Emanuel on 10/28/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "WizardNotesViewController.h"

@interface WizardNotesViewController ()

@end

@implementation WizardNotesViewController

@synthesize notesDelegate = _notesDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload {
    [self setNotesDelegate:nil];
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)next_pressed {
    [self.notesDelegate createTripWithNotes:self.textView.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
