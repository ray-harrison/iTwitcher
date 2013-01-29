//
//  iTwitcher.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface iTwitcherAnnotationView : MKPinAnnotationView

@property (nonatomic, strong) MKMapView *map;
- (id) initWithAnnotation: (id <MKAnnotation>) annotation map:(MKMapView *)map;

@end
