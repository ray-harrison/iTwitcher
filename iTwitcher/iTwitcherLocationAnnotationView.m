//
//  iTwitcherLocationAnnotationView.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherLocationAnnotationView.h"
#import "iTwitcherLocationAnnotation.h"

@implementation iTwitcherLocationAnnotationView
MKCircle *radiusOverlay;
BOOL isRadiusUpdated;


+ (id)initWithAnnotation:(id <MKAnnotation>)annotation map:(MKMapView *)annotationMap{
    
    
    iTwitcherLocationAnnotationView *annotationView =
    [[iTwitcherLocationAnnotationView alloc] initWithAnnotation:annotation map:annotationMap];
    
    
    
    
    
    annotationView.pinColor = MKPinAnnotationColorGreen;
    annotationView.canShowCallout = YES;
    
    if ([annotation isKindOfClass:[iTwitcherLocationAnnotation class]]) {
        annotationView.theAnnotation = (iTwitcherLocationAnnotation *)annotation;
        MKCircle *radiusOverlay = [MKCircle circleWithCenterCoordinate:annotationView.theAnnotation.coordinate
                                                                radius:annotationView.theAnnotation.radius];
        [annotationView.mapView addOverlay:radiusOverlay];
    }
    
    
    
    
    
	
	return annotationView;
}



-(id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"In Init With Annotation Reuse Identifier");
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    self.canShowCallout = YES;
    return self;
}

-(id) initWithAnnotation:(id<MKAnnotation>)annotation map:(MKMapView *)annotationMap
{
    
    return [super initWithAnnotation:annotation map:annotationMap];
    
}




- (void)removeRadiusOverlay {
	// Find the overlay for this annotation view and remove it if it has the same coordinates.
    NSLog(@"Called Remove Radius Overlay");
	for (id overlay in [self.map overlays]) {
		if ([overlay isKindOfClass:[MKCircle class]]) {
			MKCircle *circleOverlay = (MKCircle *)overlay;
            
			CLLocationCoordinate2D coord = circleOverlay.coordinate;
			
			if (coord.latitude == self.theAnnotation.coordinate.latitude && coord.longitude == self.theAnnotation.coordinate.longitude) {
				[self.map removeOverlay:overlay];
			}
		}
	}
	
	isRadiusUpdated = NO;
}


- (void)updateRadiusOverlay {
    NSLog(@"In Update Radius Overlay");
    self.canShowCallout = YES;
	if (!isRadiusUpdated) {
		isRadiusUpdated = YES;
		
		[self removeRadiusOverlay];
		
		self.canShowCallout = NO;
		
		[self.map addOverlay:[MKCircle circleWithCenterCoordinate:self.theAnnotation.coordinate
                                                           radius:self.theAnnotation.radius]];
		
		self.canShowCallout = YES;
        self.draggable = YES;
	}
}

@end
