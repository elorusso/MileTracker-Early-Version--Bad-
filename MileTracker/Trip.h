//
//  Trip.h
//  MileTracker
//
//  Created by Emanuel on 10/26/13.
//  Copyright (c) 2013 Emanuel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface Trip : NSObject

@property (nonatomic, copy) NSString *purpose;
@property (nonatomic) kTripType *type;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *origin;
@property (nonatomic, copy) NSString *destination;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *vehicle;
@property (nonatomic) double distance;
@property (nonatomic) double expenses;

- (id)initWithPurpose:(NSString *)purpose type:(kTripType)type date:(NSDate *)date origin:(NSString *)origin destination:(NSString *)dest notes:(NSString *)notes vehicle:(NSString *)v distance:(double)dist expenses:(double)exp;
- (NSString *)typeToString;
- (NSString *)dateToString;
- (NSString *)distanceToString;
- (NSString *)expensesToString;
- (double)savings;
- (NSString *)savingsToString;

@end
