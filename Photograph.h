//
//  Photograph.h
//  iTwitcher
//
//  Created by Raymond Harrison on 2/6/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SpeciesObservation;

@interface Photograph : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) SpeciesObservation *speciesObservation;

@end
