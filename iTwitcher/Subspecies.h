//
//  Subspecies.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/28/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Species;

@interface Subspecies : NSManagedObject

@property (nonatomic, retain) NSString * subspeciesLatinName;
@property (nonatomic, retain) NSString * breedingSubregion;
@property (nonatomic, retain) Species *species;

@end
