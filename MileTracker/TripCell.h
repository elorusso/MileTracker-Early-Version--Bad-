//
//  TripCell.h
//  MileTracker
//
//  Created by Emanuel on 9/18/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *miles;
@property (strong, nonatomic) IBOutlet UILabel *from_to;
@property (strong, nonatomic) IBOutlet UILabel *notes;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *savingsLabel;



@end
