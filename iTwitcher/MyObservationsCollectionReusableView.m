//
//  MyObservationsCollectionReusableView.m
//  iTwitcher
//
//  Created by Raymond Harrison on 3/4/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "MyObservationsCollectionReusableView.h"

@implementation MyObservationsCollectionReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (IBAction)addSpeciesAction:(id)sender {
    NSLog(@"Add Species %d",self.section);
}



@end
