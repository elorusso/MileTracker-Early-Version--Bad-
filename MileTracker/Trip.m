//
//  Trip.m
//  MileTracker
//
//  Created by Emanuel on 10/26/13.
//  Copyright (c) 2013 Emanuel. All rights reserved.
//

#import "Trip.h"

@implementation Trip

- (id)init {
    self = [super init];
    if (self) {
        self.purpose = nil;
        self.type = kTripTypeNone;
        self.date = nil;
        self.origin = nil;
        self.destination = nil;
        self.distance = 0;
        self.expenses = 0;
        self.notes = nil;
        self.vehicle = nil;
    }
    return self;
}

- (id)initWithPurpose:(NSString *)purpose type:(kTripType)type date:(NSDate *)date origin:(NSString *)origin destination:(NSString *)dest notes:(NSString *)notes vehicle:(NSString *)v distance:(double)dist expenses:(double)exp {
    self = [self init];
    if (self) {
        self.purpose = purpose;
        self.type = type;
        self.date = date;
        self.origin = origin;
        self.destination = dest;
        self.distance = dist;
        self.expenses = exp;
        self.notes = notes;
        self.vehicle = v;
    }
    return self;
}

- (NSString *)typeToString {
    switch ((int) self.type) {
        case -1:
            NSLog(@"Tried to access invalid type. (Trip.m/typeToString)");
            return @"";
        case 0:
            return @"Business";
        case 1:
            return @"Charity";
        case 2:
            return @"Medical";
        case 3:
            return @"Personal";
        case 4:
            return @"Other";
        default:
            return nil;
    }
}

- (NSString *)dateToString {
    
}

@end
