//
//  ExpensesViewController.h
//  MileTracker
//
//  Created by Emanuel on 11/9/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "WizardInfoViewController.h"

@protocol ExpenseDelegate <NSObject>

- (void)userEnteredExpense:(NSString *)expense;

@end 

@interface ExpensesViewController : WizardInfoViewController {
    NSNumberFormatter *format;
}

@property (retain, nonatomic) NSString *expense;
@property (strong, nonatomic) id <ExpenseDelegate> expenseDelegate;

@end
