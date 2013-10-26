//
//  WizardExpenseViewController.m
//  MileTracker
//
//  Created by Emanuel on 11/8/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "WizardExpenseViewController.h"
#import "WizardNotesViewController.h"

@interface WizardExpenseViewController ()

@end

@implementation WizardExpenseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem.title = @"Next";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.textField.placeholder = @"0.0";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)next_pressed {
    double expense = 0;
    if (![self.textField.text isEqualToString:@""]) {
        expense = [self.textField.text doubleValue];
    }
    NSString *string = [format stringFromNumber:[NSNumber numberWithDouble:expense]];
    [self.expenseDelegate userEnteredExpense:[@"$" stringByAppendingString:string]];
    WizardNotesViewController *notesView = [[WizardNotesViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
    notesView.notesDelegate = self.nextDelegate;
    notesView.title = @"Notes (optional)";
    [self.navigationController pushViewController:notesView animated:YES];
}
@end
