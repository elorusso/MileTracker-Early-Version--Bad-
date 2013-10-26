//
//  DateViewController.m
//  MileTracker
//
//  Created by Emanuel on 9/24/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController () {}
- (void)savePressed;
- (void)updateLabel;
@end

@implementation DateViewController
@synthesize dateLabel = _dateLabel;
@synthesize date = _date;
@synthesize datePicker = _datePicker;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
        self.navigationItem.rightBarButtonItem = save;
    }
    return self;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect newframe = self.datePicker.frame;
    newframe.origin.y = self.view.frame.size.height - self.datePicker.frame.size.height;
    self.datePicker.frame = newframe;
    
    [self.datePicker addTarget:self action:@selector(updateLabel) forControlEvents:UIControlEventValueChanged];
    [self updateLabel];
}

- (void)viewDidUnload
{
    [self setDateLabel:nil];
    [self setDate:nil];
    [self setDatePicker:nil];
    [self setDelegate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - other methods

- (void)updateLabel {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    self.dateLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.datePicker.date]];
}

- (void)savePressed {
    [self.delegate userDidSelectDate:self.dateLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
