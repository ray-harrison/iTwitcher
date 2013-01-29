//
//  iTwitcherLocationAnnotationView.h
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherAnnotationView.h"
@class iTwitcherLocationAnnotation;
@interface iTwitcherLocationAnnotationView : iTwitcherAnnotationView
@property (nonatomic, assign) MKMapView *mapView;
@property (nonatomic, assign) iTwitcherLocationAnnotation *theAnnotation;

+ (id)initWithAnnotation:(id <MKAnnotation>)annotation map:(MKMapView *)annotationMap;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation;
- (void)updateRadiusOverlay;
- (void)removeRadiusOverlay;
@end
