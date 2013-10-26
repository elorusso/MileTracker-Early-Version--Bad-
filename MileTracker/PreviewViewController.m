//
//  PreviewViewController.m
//  MileTracker
//
//  Created by Emanuel on 12/26/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *fullPdfPath = [documentDirectory stringByAppendingPathComponent:@"report.pdf"];
    NSURL *url = [NSURL fileURLWithPath:fullPdfPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
- (IBAction)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
