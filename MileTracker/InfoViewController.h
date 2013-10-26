//
//  InfoViewController.h
//  MileTracker
//
//  Created by Emanuel on 9/22/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol InfoViewControllerDelegate <NSObject>
@required
- (void)userDidEnterInfo:(NSString *)info;
@end

@interface InfoViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) id <InfoViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *text;


@end


