//
//  QuartzView.h
//  AreaPlan
//
//  Created by Jon on 11-12-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuartzView : UIView
{
    NSMutableArray *xCoords;
    NSMutableArray *yCoords;
    NSMutableArray *highlight;
    NSMutableArray *drawType;
    UIImage *img_restroom;
    UIImage *img_restaurant;
}

@property (retain, nonatomic) NSMutableArray *xCoords, *yCoords, *drawType;

@property (retain, nonatomic) NSMutableArray *highlight;

@end
