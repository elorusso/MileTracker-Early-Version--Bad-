//
//  NewTripData.m
//  MileTracker
//
//  Created by Emanuel on 10/6/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import "NewTripData.h"

static double businessRate = .555;
static double medicalRate = .23;
static double charityRate = .14;

@interface NewTripData () {
    NSNumberFormatter *moneyFormat;
}

- (NSString *)getInfoForRow:(NSUInteger)row inSection: (NSUInteger)section;
- (void) calculateSavings;

@end

@implementation NewTripData

@synthesize cells = _cells, cellCurrentlyEdited = _cellCurrentlyEdited;
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.cellCurrentlyEdited = nil;
        
        moneyFormat = [[NSNumberFormatter alloc]init];
        moneyFormat.minimumFractionDigits = 2;
        moneyFormat.maximumFractionDigits = 2;
        moneyFormat.minimumIntegerDigits = 1;
        
        self.cells = [[NSMutableArray alloc]init];
        
        //adding cells to the date section
        NSMutableArray *date_section = [[NSMutableArray alloc] init];
        [date_section addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Date", @"title",
                                 @"", @"detail", nil]];
        
        //adding cells to the info section
        NSMutableArray *info = [[NSMutableArray alloc]init];
        [info addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Purpose", @"title",
                         @"", @"detail", nil]];
        [info addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Type", @"title",
                         @"", @"detail", nil]];
        [info addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Origin", @"title",
                         @"", @"detail", nil]];
        [info addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Destination", @"title",
                         @"", @"detail", nil]];
        [info addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Notes", @"title",
                         @"", @"detail", nil]];
        //adding cells to the tracking section
        NSMutableArray *tracking = [[NSMutableArray alloc]init];
        [tracking addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Vehicle", @"title",
                         @"", @"detail",nil]];
        [tracking addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Map", @"title",
                             @"0.0", @"detail", nil]];
        [tracking addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Expenses", @"title",
                             @"$0.00", @"detail", nil]];
        [tracking addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Savings", @"title",
                             @"$0.00", @"detail", nil]];
        //putting all the sections togehter
        [self.cells addObject:date_section];
        [self.cells addObject:info];
        [self.cells addObject:tracking];
    }
    return self;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma  mark - delegate methods
- (void)userDidEnterInfo:(NSString *)info {
    [[[self.cells objectAtIndex:1]objectAtIndex:0]setObject:info forKey:@"detail"];
}

- (void)userDidSelectType:(NSString *)type {
    [[[self.cells objectAtIndex:1]objectAtIndex:1]setObject:type forKey:@"detail"];
    
    [self calculateSavings];
}

-(void)userDidSelectDate:(NSString *)date {
    [[[self.cells objectAtIndex:self.cellCurrentlyEdited.section]objectAtIndex:self.cellCurrentlyEdited.row]setObject:date forKey:@"detail"];
}

- (void)userDidTrackMiles:(NSString *)miles {
    [[[self.cells objectAtIndex:self.cellCurrentlyEdited.section]objectAtIndex:self.cellCurrentlyEdited.row]setObject:miles forKey:@"detail"];
    
    [self calculateSavings];
}

-(void)userDidSelectVehicle:(NSString *)vehicle {
    [[[self.cells objectAtIndex:2]objectAtIndex:0]setObject:vehicle forKey:@"detail"];
}

- (void)userEnteredExpense:(NSString *)expense {
    [[[self.cells objectAtIndex:2]objectAtIndex:2]setObject:expense forKey:@"detail"];
}

- (void)addMiles:(NSString *)miles date:(NSString *)date origin:(NSString *)origin destination:(NSString *)destination {
    [[[self.cells objectAtIndex:2]objectAtIndex:1]setObject:miles forKey:@"detail"];
    [[[self.cells objectAtIndex:0]objectAtIndex:0]setObject:date forKey:@"detail"];
    [[[self.cells objectAtIndex:1]objectAtIndex:2]setObject:origin forKey:@"detail"];
    [[[self.cells objectAtIndex:1]objectAtIndex:3]setObject:destination forKey:@"detail"];
    
    [self calculateSavings];
}

- (void)createTripWithNotes:(NSString *)notes {
    NSMutableDictionary *trip = [[NSMutableDictionary alloc]init];
    [trip setObject:[self getInfoForRow:0 inSection:1] forKey:@"trip name"];
    [trip setObject:[self getInfoForRow:1 inSection:1] forKey:@"trip type"];
    [trip setObject:[self getInfoForRow:0 inSection:0] forKey:@"trip start date"];
    [trip setObject:[self getInfoForRow:2 inSection:1] forKey:@"trip origin"];
    [trip setObject:[self getInfoForRow:3 inSection:1] forKey:@"trip destination"];
    [trip setObject:[self getInfoForRow:1 inSection:2] forKey:@"trip miles"];
    [trip setObject:[self getInfoForRow:2 inSection:2] forKey:@"trip expenses"];
    [trip setObject:notes forKey:@"trip notes"];
    [trip setObject:[self getInfoForRow:0 inSection:2] forKey:@"trip vehicle"];
    [trip setObject:[self getInfoForRow:3 inSection:2] forKey:@"trip savings"];
    
    [self.delegate addTrip:trip];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - other methods

-(NSString *)getInfoForRow:(NSUInteger)row inSection:(NSUInteger)section {
    return [[[self.cells objectAtIndex:section]objectAtIndex:row]objectForKey:@"detail"];
}

-(void)calculateSavings {
    if ([[self getInfoForRow:1 inSection:1] isEqualToString:@"Business"] && ![[self getInfoForRow:1 inSection:2] isEqualToString:@""]) {
        double save = [[self getInfoForRow:1 inSection:2] doubleValue] * businessRate;
        [[[self.cells objectAtIndex:2]objectAtIndex:3]setObject:[moneyFormat stringFromNumber:[NSNumber numberWithDouble:save]] forKey:@"detail"];
    }
    
    else if ([[self getInfoForRow:1 inSection:1] isEqualToString:@"Medical"] && ![[self getInfoForRow:1 inSection:2] isEqualToString:@""]) {
        double save = [[self getInfoForRow:1 inSection:2] doubleValue] * medicalRate;
        [[[self.cells objectAtIndex:2]objectAtIndex:3]setObject:[moneyFormat stringFromNumber:[NSNumber numberWithDouble:save]] forKey:@"detail"];
    }
    
    else if ([[self getInfoForRow:1 inSection:1] isEqualToString:@"Charity"] && ![[self getInfoForRow:1 inSection:2] isEqualToString:@""]) {
        double save = [[self getInfoForRow:1 inSection:2] doubleValue] * charityRate;
        [[[self.cells objectAtIndex:2]objectAtIndex:3]setObject:[moneyFormat stringFromNumber:[NSNumber numberWithDouble:save]] forKey:@"detail"];
    }
    
    else {
        [[[self.cells objectAtIndex:2]objectAtIndex:3]setObject:@"0.00" forKey:@"detail"];
    }
}


@end
