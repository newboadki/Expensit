//
//  BSChartLegendCollectionViewCell.m
//  Expenses
//
//  Created by Borja Arias Drake on 07/06/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import "BSChartLegendCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation BSChartLegendCollectionViewCell


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
       _bulletPoint.layer.cornerRadius = 16.0;
    }
    return self;
    
}

@end
