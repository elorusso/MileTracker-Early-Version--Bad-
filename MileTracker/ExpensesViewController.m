//
//  ExpensesViewController.m
//  MileTracker
//
//  Created by Emanuel on 11/9/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "ExpensesViewController.h"

@interface ExpensesViewController () {
}
@end

@implementation ExpensesViewController

@synthesize expense = _expense;
@synthesize expenseDelegate = _expenseDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem.title = @"Save";
        self.navigationItem.leftBarButtonItem = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.textField.text = [self.expense substringFromIndex:1];
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    
    format = [[NSNumberFormatter alloc]init];
    format.maximumFractionDigits = 2;
    format.minimumFractionDigits = 2;
    format.minimumIntegerDigits = 1;
}

- (void)viewDidUnload {
    [self setExpenseDelegate:nil];
    
    [super viewDidUnload];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel_pressed {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
