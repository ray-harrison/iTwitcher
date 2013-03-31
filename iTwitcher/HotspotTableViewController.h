//
//  HotspotTableViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 3/31/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservationLocation+Query.h"
@class HotspotTableViewController;
@protocol HotspotDelegate <NSObject>
-(void) didSelectHotspot: (HotspotTableViewController *)controller hotspot: (ObservationLocation *)observationLocation;
-(void) didCancelHotspotSelection:(HotspotTableViewController *)controller;

@end

@interface HotspotTableViewController : UITableViewController



@property (nonatomic, strong) UIManagedDocument *birdDatabase;


@end
