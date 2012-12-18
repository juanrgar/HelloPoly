//
//  PolygonShape.h
//  WhatATool
//
//  Created by Juan Rafael García Blanco on 7/5/10.
//  Copyright 2010 UPM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PolygonShape : NSObject {
	int numberOfSides;
	int minimumNumberOfSides;
	int maximumNumberOfSides;
	float angleInDegrees;
	float angleInRadians;
	NSString *name;
}

@property int numberOfSides;
@property int minimumNumberOfSides;
@property int maximumNumberOfSides;
@property (readonly) float angleInDegrees;
@property (readonly) float angleInRadians;
@property (readonly) NSString *name;

- (id)init;
- (id)initWithNumberOfSides:(int)sides minimumNumberOfSides:(int)min maximumNumberOfSides:(int)max;

@end
