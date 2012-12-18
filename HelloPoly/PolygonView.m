//
//  PolygonView.m
//  HelloPolyNG
//
//  Created by Juan Rafael Garcia Blanco on 8/11/10.
//  Copyright 2010 UPM. All rights reserved.
//

#import "PolygonView.h"


@implementation PolygonView

#define ROTATION_FACTOR 50

@synthesize numberOfSides;
@synthesize fillColor;

- (id)initWithFrame:(NSRect)frameRect {
	NSLog(@"PolygonView initWithFrame");
	if (self = [super initWithFrame:frameRect]) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		CGFloat	colorR, colorG, colorB;
		
		colorR = [defaults floatForKey:@"fillColorR"];
		colorG = [defaults floatForKey:@"fillColorG"];
		colorB = [defaults floatForKey:@"fillColorB"];
		
		if (colorR + colorG + colorB == 0.0) {
			colorR = 1.0;
			colorG = colorB = 0.0;
		}
		fillColor = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithFloat:colorR], [NSNumber numberWithFloat:colorG], [NSNumber numberWithFloat:colorB], [NSNumber numberWithFloat:1.0], nil];
		
		NSColor *fillNSColor = [NSColor colorWithDeviceRed:colorR green:colorG blue:colorB alpha:1.0];
		[[NSColorPanel sharedColorPanel] setColor:fillNSColor];
		
		CALayer *layer = [CALayer layer];
		layer.delegate = self;
		
		[self setLayer:layer];
		[self setWantsLayer:YES];
		[layer release];
	}
	return self;
}

- (void)dealloc {
	NSLog(@"PolygonView dealloc");
	[fillColor release];
	[super dealloc];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	NSLog(@"PolygonView drawLayer:inContext:");
	
	static int count = 0;
	
	NSArray *points = [PolygonView pointsForPolygonInRect:layer.bounds numberOfSides:numberOfSides];
	CGPoint curPoint, firstPoint;
	
	firstPoint = curPoint = NSPointToCGPoint([[points objectAtIndex:0] pointValue]);
	int nPoints = [points count];
	
	CGMutablePathRef path = CGPathCreateMutable();
	
	CGPathMoveToPoint(path, NULL, firstPoint.x, firstPoint.y);
	for (int i = 0; i < nPoints; i++) {
		curPoint = NSPointToCGPoint([[points objectAtIndex:i] pointValue]);
		CGPathAddLineToPoint(path, NULL, curPoint.x, curPoint.y);
	}
	CGPathAddLineToPoint(path, NULL, firstPoint.x, firstPoint.y);
	CGContextBeginPath(ctx);
	CGContextAddPath(ctx, path);
	
	CGFloat comp[4];
	for (int i = 0; i < 4; i++)
		comp[i] = [[fillColor objectAtIndex:i] floatValue];
	
	CGContextSetFillColorSpace(ctx, CGColorSpaceCreateWithName(kCGColorSpaceSRGB));
	CGContextSetFillColor(ctx, comp);
	CGContextFillPath(ctx);
	CGPathRelease(path);
	
	count++;
	if (count == 1) {
		CGFloat rotation = [[NSUserDefaults standardUserDefaults] floatForKey:@"rotation"];
		[layer setValue:[NSNumber numberWithFloat:rotation] forKeyPath:@"transform.rotation.z"];
	}
}

- (void)saveState:(NSUserDefaults *)defaults {
	NSLog(@"PolygonView saveState:");
	[defaults setFloat:[[fillColor objectAtIndex:0] floatValue] forKey:@"fillColorR"];
	[defaults setFloat:[[fillColor objectAtIndex:1] floatValue] forKey:@"fillColorG"];
	[defaults setFloat:[[fillColor objectAtIndex:2] floatValue] forKey:@"fillColorB"];
	[defaults setFloat:[[[self layer] valueForKeyPath:@"transform.rotation.z"] floatValue] forKey:@"rotation"];
}

- (void)changeColor:(id)sender {
	NSLog(@"PolygonView changeColor:");
	NSColorPanel *colPanel = (NSColorPanel *)sender;
	NSColor *color = [colPanel color];
	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
	NSArray *newColor = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[color redComponent]], [NSNumber numberWithFloat:[color greenComponent]], [NSNumber numberWithFloat:[color blueComponent]], nil];
	[fillColor replaceObjectsAtIndexes:indexes withObjects:newColor];
	[[self layer] setNeedsDisplay];
}

- (void)rotateWithEvent:(NSEvent *)event {
	NSLog(@"PolygonView rotateWithEvent: %f", [event rotation]);
	CALayer *layer = [self layer];
	float oldRotation = [[layer valueForKeyPath:@"transform.rotation.z"] floatValue];
	float newRotation = oldRotation + [event rotation] / ROTATION_FACTOR;
	[layer setValue:[NSNumber numberWithFloat:newRotation] forKeyPath:@"transform.rotation.z"];
}

- (IBAction)resetRotation:(id)sender {
	[[self layer] setValue:[NSNumber numberWithFloat:0.0] forKeyPath:@"transform.rotation.z"];
}

+ (NSArray *)pointsForPolygonInRect:(NSRect)rect numberOfSides:(int)numberOfSides {
	NSLog(@"PolygonView pointsForPolygonInRect:numberOfSides:");
	NSPoint center = NSMakePoint(rect.size.width / 2.0, rect.size.height / 2.0);
	float radius = 0.9 * center.x;
	NSMutableArray *result = [NSMutableArray array];
	float angle = (2.0 * M_PI) / numberOfSides;
	float exteriorAngle = M_PI - angle;
	float rotationDelta = angle - (0.5 * exteriorAngle);
	
	for (int currentAngle = 0; currentAngle < numberOfSides; currentAngle++) {
		float newAngle = (angle * currentAngle) - rotationDelta;
		float curX = cos(newAngle) * radius;
		float curY = sin(newAngle) * radius;
		[result addObject:[NSValue valueWithPoint:NSMakePoint(center.x + curX, center.y + curY)]];
	}
	return result;
}

@end
