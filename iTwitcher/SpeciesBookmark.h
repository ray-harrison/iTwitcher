//
//  SpeciesBookmark.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/30/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SpeciesBookmark : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * recent;

@end
