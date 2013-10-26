//
//  WizardInfoViewController.m
//  MileTracker
//
//  Created by Emanuel on 11/9/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "WizardInfoViewController.h"
#import "WizardTypeViewController.h"

@interface WizardInfoViewController ()

@end

@implementation WizardInfoViewController

@synthesize textField = _textField;
@synthesize nextDelegate = _nextDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *next = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(next_pressed)];
        self.navigationItem.rightBarButtonItem = next;
    }
    return self;
}
//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.textView.hidden = YES;
    self.textView.editable = NO;
    
    CGRect frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, 44);
    UITextField *textfield = [[UITextField alloc]initWithFrame:frame];
    textfield.placeholder = @"Enter Purpose";
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.font = [UIFont systemFontOfSize:20];
    textfield.autocorrectionType = UITextAutocorrectionTypeYes;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:textfield];
    self.textField = textfield;
    [self.textField becomeFirstResponder];
}

- (void)viewDidUnload {
    [self setTextField:nil];
    [self setNextDelegate:nil];
    
    [super viewDidUnload];
}
//////////////////////////////////////////////////////////////////////////////////////////////
- (void)next_pressed {
    if ([self.textField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Not Complete" message:@"Please enter a purpose." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        WizardTypeViewController *type = [[WizardTypeViewController alloc]initWithNibName:@"TypeViewController" bundle:nil];
        type.title = @"Business";
        type.delegate = self.nextDelegate;
        type.nextDelegate = self.nextDelegate;
        [self.delegate userDidEnterInfo:self.textField.text];
        [self.navigationController pushViewController:type animated:YES];
    }
}

- (void)cancel_pressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
