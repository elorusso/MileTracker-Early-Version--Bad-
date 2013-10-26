//
//  VehicleViewController.h
//  MileTracker
//
//  Created by Emanuel on 10/17/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "TypeViewController.h"

@protocol VehicleViewControllerDelegate <NSObject>
@required
-(void)userDidSelectVehicle:(NSString *)vehicle;
@end

@interface VehicleViewController : TypeViewController

@property (nonatomic, weak) id <VehicleViewControllerDelegate> vehicleDelegate;

@end
