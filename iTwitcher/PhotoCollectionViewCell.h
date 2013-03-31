//
//  PhotoCollectionViewCell.h
//  iTwitcher
//
//  Created by Raymond Harrison on 3/15/13.
//  Copyright (c) 2013 Raymond Harrison. All rights reserved.
//

#import "CBetterCollectionViewCell.h"
#import "CReflectionView.h"
@class CReflectionView;
@interface PhotoCollectionViewCell : CBetterCollectionViewCell
@property (readwrite, nonatomic, weak) IBOutlet UIImageView *imageView;
@property (readwrite, nonatomic, weak) IBOutlet CReflectionView *reflectionImageView;

@end
