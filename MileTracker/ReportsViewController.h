//
//  ReportsViewController.h
//  MileTracker
//
//  Created by Emanuel on 12/24/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ReportsViewController : UIViewController <MFMailComposeViewControllerDelegate>


- (IBAction)showPreview:(UIBarButtonItem *)sender;
- (IBAction)sendReport:(UIBarButtonItem *)sender;
@end
