//
//  PolygonShape.m
//  WhatATool
//
//  Created by Juan Rafael García Blanco on 7/5/10.
//  Copyright 2010 UPM. All rights reserved.
//

#import "PolygonShape.h"

#import <math.h>


@implementation PolygonShape

@synthesize numberOfSides;
@synthesize minimumNumberOfSides;
@synthesize maximumNumberOfSides;

- (void)setNumberOfSides:(int)newNumberOfSides {
    if (newNumberOfSides > maximumNumberOfSides) {
        NSLog(@"Invalid number of sides: %d is greater than the maximum of %d allowed", newNumberOfSides, maximumNumberOfSides);
        return;
    }
    if (newNumberOfSides < minimumNumberOfSides) {
        NSLog(@"Invalid number of sides: %d lesser than the minimum of %d allowed", newNumberOfSides, maximumNumberOfSides);
        return;
    }
    
    numberOfSides = newNumberOfSides;
}

- (float)angleInDegrees {
    return (180 * (numberOfSides - 2) / numberOfSides);
}

- (float)angleInRadians {
    return self.angleInDegrees * 2 * M_PI;
}

- (NSString *)name {
	NSString *str = nil;
    NSString *ret = nil;
    
    switch (numberOfSides) {
        case 3:
            str = @"Triangle";
            break;
        case 4:
            str = @"Square";
            break;
		case 5:
			str = @"Pentagon";
			break;
		case 6:
			str = @"Hexagon";
			break;
		case 7:
			str = @"Heptagon";
			break;
		case 8:
			str = @"Octagon";
			break;
		case 9:
			str = @"Enneagon";
			break;
		case 10:
			str = @"Decagon";
			break;
		case 11:
			str = @"Hendecagon";
			break;
		case 12:
			str = @"Dodecagon";
			break;
        default:
            break;
    }
	ret = [[NSString alloc] initWithString:str];
	[ret autorelease];
	return ret;
}

- (id)initWithNumberOfSides:(int)sides 
      minimumNumberOfSides:(int)min maximumNumberOfSides:(int)max {
    if (self = [super init]) {
        self.minimumNumberOfSides = min;
        self.maximumNumberOfSides = max;
        self.numberOfSides = sides;
    }
    return self;
}

- (id)init {
    return [self initWithNumberOfSides:5 minimumNumberOfSides:3 maximumNumberOfSides:10];
}

- (void)dealloc {
	[super dealloc];
}

- (NSString *)description {
	NSString *ret;
	
	ret = [[NSString alloc] initWithFormat: @"Hello I am a %d-sided polygon (aka a %@) with angles of %.0f degrees (%f radians).", numberOfSides, self.name, self.angleInDegrees, self.angleInRadians];
	[ret autorelease];
	return ret;
}

@end
