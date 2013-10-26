//
//  InfoViewController.m
//  MileTracker
//
//  Created by Emanuel on 9/22/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

- (void)next_pressed;
- (void)cancel_pressed;

@end

@implementation InfoViewController
@synthesize textView = _textView;
@synthesize text = _text;
@synthesize delegate = _delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //add save button in the top right corner
        UIBarButtonItem *next = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(next_pressed)];
        self.navigationItem.rightBarButtonItem = next;
        
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel_pressed)];
        self.navigationItem.leftBarButtonItem = cancel;
    }
    return self;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //customize textView
    self.textView.layer.cornerRadius = 8;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.textView.layer.masksToBounds = YES;
    [self.textView becomeFirstResponder];
    self.textView.text = self.text;
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [self setDelegate:nil];
    [self setText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - other methods

- (void)next_pressed {
    if ([self.textView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Not Complete" message:@"Please enter a purpose." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [self.delegate userDidEnterInfo:self.textView.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancel_pressed {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
