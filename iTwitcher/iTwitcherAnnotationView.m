//
//  iTwitcher.m
//  iTwitcher
//
//  Created by Raymond Harrison on 1/27/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "iTwitcherAnnotationView.h"

@implementation iTwitcherAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithAnnotation: (id <MKAnnotation>) annotation map:(MKMapView *)map
{
    
    iTwitcherAnnotationView *view = (iTwitcherAnnotationView *)
    [map dequeueReusableAnnotationViewWithIdentifier:annotation.title];
    if (view == nil) {
        
        view = (iTwitcherAnnotationView *)[super initWithAnnotation:annotation reuseIdentifier:annotation.title];
    } else {
        
        self = view;
    }
    
    self.map = map;
    self.draggable = YES;
    self.canShowCallout = YES;
    self.animatesDrop = YES;
    
    return self;
    
    
    
}

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = (iTwitcherAnnotationView *) [_map dequeueReusableAnnotationViewWithIdentifier:annotation.title];
    if (self != nil) {
        
        return self;
    }
    else {
        
        return [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
