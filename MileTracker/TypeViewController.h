//
//  TypeViewController.h
//  MileTracker
//
//  Created by Emanuel on 9/23/12.
//  Copyright (c) 2012 Emanuel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@protocol TypeViewControllerDelegate <NSObject>
- (void)userDidSelectType: (NSString *)type;
@end

@interface TypeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate> {
    ADBannerView *adView;
}

@property (nonatomic, retain) NSMutableArray *catagories;
@property (nonatomic, retain) NSString *selectedCatagory;
@property (nonatomic, weak) id <TypeViewControllerDelegate> delegate;
@property (nonatomic) BOOL bannerIsVisible;



@end
