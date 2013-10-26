//
//  ExpensesViewController.h
//  MileTracker
//
//  Created by Emanuel on 11/8/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "WizardInfoViewController.h"

@protocol ExpenseDelegate <NSObject>
- (void)userEnteredExpense:(NSString *)expense;
@end

@interface ExpensesViewController : WizardInfoViewController

@property (weak, nonatomic) id <ExpenseDelegate> expenseDelegate;
@property (retain, nonatomic) NSString *expense;

@end
