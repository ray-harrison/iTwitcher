//
//  SpeciesWatchlistDetail.h
//  iTwitcher
//
//  Created by Raymond Harrison on 3/28/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SpeciesWatchlist;

@interface SpeciesWatchlistDetail : NSManagedObject

@property (nonatomic, retain) NSString * watchType;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) SpeciesWatchlist *watchList;

@end
