//
//  SpeciesListDetailTableViewController.h
//  iTwitcher
//
//  Created by Raymond Harrison on 3/22/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeciesObservationViewController.h"

@interface SpeciesListDetailTableViewController : UITableViewController <SpeciesObservationDelegate>

@property (nonatomic, strong) UIManagedDocument *birdDatabase;
@property (nonatomic, strong) NSString *speciesName;

@end
