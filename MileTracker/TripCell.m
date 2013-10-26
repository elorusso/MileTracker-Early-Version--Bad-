//
//  TripCell.m
//  MileTracker
//
//  Created by Emanuel on 9/18/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "TripCell.h"

@implementation TripCell
@synthesize name;
@synthesize miles;
@synthesize from_to;
@synthesize notes;
@synthesize date;
@synthesize savingsLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
