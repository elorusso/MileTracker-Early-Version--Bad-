//
//  PreviewViewController.h
//  MileTracker
//
//  Created by Emanuel on 12/26/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)back:(UIBarButtonItem *)sender;
@end
