//
//  DateViewController.h
//  MileTracker
//
//  Created by Emanuel on 9/24/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateViewControllerDelegate <NSObject>
- (void)userDidSelectDate:(NSString *)date;
@end

@interface DateViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (nonatomic, weak) id <DateViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;


@end
