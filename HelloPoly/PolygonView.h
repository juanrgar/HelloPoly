//
//  PolygonView.h
//  HelloPolyNG
//
//  Created by Juan Rafael Garcia Blanco on 8/11/10.
//  Copyright 2010 UPM. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


@interface PolygonView : NSView {
	@private
	NSMutableArray *fillColor;
	int numberOfSides;
}
@property (assign, nonatomic) int numberOfSides;
@property (retain, nonatomic) NSArray *fillColor;

- (void)saveState:(NSUserDefaults *)defaults;
- (IBAction)resetRotation:(id)sender;

+ (NSArray *)pointsForPolygonInRect:(NSRect)rect numberOfSides:(int)numberOfSides;
@end
