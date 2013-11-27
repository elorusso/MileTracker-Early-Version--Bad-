//
//  Enums.h
//  MileTracker
//
//  Created by Emanuel on 10/26/13.
//  Copyright (c) 2013 Emanuel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kTripType) {
    kTripTypeNone = -1,
    kTripTypeBusiness = 0,
    kTripTypeCharity = 1,
    kTripTypeMedical = 2,
    kTripTypePersonal = 3,
    kTripTypeOther = 4
};
