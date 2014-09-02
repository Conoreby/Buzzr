//
//  TimeView.m
//  Buzzr
//
//  Created by Conor Eby on 11/21/13.
//  Copyright (c) 2013 Conor Eby. All rights reserved.
//

#import "TimeView.h"

@implementation TimeView

- (void) setTime:(NSString *)time
{
	_time = time;
	[self setNeedsDisplay];
}

- (void) setDim:(BOOL)dim
{
	_dim = dim;
	[self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect: self.bounds cornerRadius:[self cornerRadius]];
	[roundedRect addClip];
	
	UIColor *fillColor = [UIColor darkGrayColor];
	
	[fillColor setFill];
	UIRectFill(self.bounds);
	
	[[UIColor blackColor] setStroke];
	
	[roundedRect stroke];
	
	[self drawTime];
	
}

#define line_width 8.0

- (void) drawTime
{
	UIBezierPath *mainPath = [[UIBezierPath alloc]init];
	[mainPath setLineWidth:line_width];
	
	UIColor *strokeColor = [UIColor yellowColor];
	[self drawTimeOnPath: mainPath];
	
	[strokeColor setStroke];
	[mainPath stroke];
	
}

#define symbol_width_scale_factor .7
#define symbol_height_scale_factor .8

- (void)drawTimeOnPath: (UIBezierPath *) mainPath
{
	CGSize numberSize = CGSizeMake((self.bounds.size.width/5) * symbol_width_scale_factor, (self.bounds.size.height * symbol_height_scale_factor));
	int indent = (self.bounds.size.width/16);
	
	for (int i = 0; i < 5; i ++){
		CGFloat horizontalOffset = ((self.bounds.size.width/5) * i) + indent;
		CGPoint numberPlacement = CGPointMake(horizontalOffset, self.bounds.size.height/2);
		
		switch ([self.time characterAtIndex:i]) {
			case '0':
				[self drawZeroOnPath: mainPath atPoint: numberPlacement withSize:numberSize];
				break;
			case '1':
				[self drawOneOnPath: mainPath atPoint: numberPlacement withSize:numberSize];
				break;
			case '2':
				[self drawTwoOnPath: mainPath atPoint: numberPlacement withSize:numberSize];
				break;
			case '3':
				[self drawThreeOnPath: mainPath atPoint: numberPlacement withSize:numberSize];
				break;
			case '4':
				[self drawFourOnPath: mainPath atPoint: numberPlacement withSize:numberSize];
				break;
			case '5':
				[self drawFiveOnPath: mainPath atPoint: numberPlacement withSize:numberSize];
				break;
			case '6':
				[self drawSixOnPath: mainPath atPoint: numberPlacement withSize:numberSize];
				break;
			case '7':
				[self drawSevenOnPath: mainPath atPoint: numberPlacement withSize:numberSize];
				break;
			case '8':
				[self drawEightOnPath: mainPath atPoint: numberPlacement withSize:numberSize];
				break;
			case '9':
				[self drawNineOnPath: mainPath atPoint: numberPlacement withSize:numberSize];
				break;
			case ':':
				[self drawColonOnPath: mainPath atPoint: numberPlacement withSize:numberSize];
				indent = 0;
				break;
				
			default:
				break;
		}
	}
}

- (void)drawZeroOnPath:(UIBezierPath *) mainPath atPoint:(CGPoint) origin withSize:(CGSize)numberSize
{ //0
	//Upper right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint: CGPointMake(origin.x + numberSize.width, origin.y - (4*numberSize.height/8))];
	//Top
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16) , origin.y - (9*numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y - (9*numberSize.height/16))];
	//Upper left
	[mainPath moveToPoint:CGPointMake(origin.x, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x, origin.y - (4*numberSize.height/8))];
	//lower left
	[mainPath moveToPoint:CGPointMake(origin.x, origin.y + (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x, origin.y + (4*numberSize.height/8))];
	//lower right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (4*numberSize.height/8))];
	//Bottom
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16), origin.y + (9*numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y + (9*numberSize.height/16))];
	
	
	
}

- (void)drawOneOnPath:(UIBezierPath *) mainPath atPoint:(CGPoint) origin withSize:(CGSize)numberSize
{ //1
	//Upper right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint: CGPointMake(origin.x + numberSize.width, origin.y - (4*numberSize.height/8))];
	//lower right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (4*numberSize.height/8))];
}

- (void)drawTwoOnPath:(UIBezierPath *) mainPath atPoint:(CGPoint) origin withSize:(CGSize)numberSize
{ //2
	//Top
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16) , origin.y - (9*numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y - (9*numberSize.height/16))];
	//Upper right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint: CGPointMake(origin.x + numberSize.width, origin.y - (4*numberSize.height/8))];
	//Middle
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16), origin.y)];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y)];
	//lower left
	[mainPath moveToPoint:CGPointMake(origin.x, origin.y + (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x, origin.y + (4*numberSize.height/8))];
	//Bottom
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16), origin.y + (9*numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y + (9*numberSize.height/16))];
}

- (void)drawThreeOnPath:(UIBezierPath *) mainPath atPoint:(CGPoint) origin withSize:(CGSize)numberSize
{ //3
	//Top
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16) , origin.y - (9*numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y - (9*numberSize.height/16))];
	//Upper right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint: CGPointMake(origin.x + numberSize.width, origin.y - (4*numberSize.height/8))];
	//Middle
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16), origin.y)];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y)];
	//lower right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (4*numberSize.height/8))];
	//Bottom
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16), origin.y + (9*numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y + (9*numberSize.height/16))];
}

- (void)drawFourOnPath:(UIBezierPath *) mainPath atPoint:(CGPoint) origin withSize:(CGSize)numberSize
{ //4
	//Middle
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16), origin.y)];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y)];
	//lower right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (4*numberSize.height/8))];
	//Upper right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint: CGPointMake(origin.x + numberSize.width, origin.y - (4*numberSize.height/8))];
	//Upper left
	[mainPath moveToPoint:CGPointMake(origin.x, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x, origin.y - (4*numberSize.height/8))];

}

- (void)drawFiveOnPath:(UIBezierPath *) mainPath atPoint:(CGPoint) origin withSize:(CGSize)numberSize
{ //5
	//Middle
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16), origin.y)];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y)];
	//Top
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/8) , origin.y - (9*numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (7*numberSize.width/8), origin.y - (9*numberSize.height/16))];
	//Bottom
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16), origin.y + (9*numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y + (9*numberSize.height/16))];
	//lower right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (4*numberSize.height/8))];
	//Upper left
	[mainPath moveToPoint:CGPointMake(origin.x, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x, origin.y - (4*numberSize.height/8))];
	
}

- (void)drawSixOnPath:(UIBezierPath *) mainPath atPoint:(CGPoint) origin withSize:(CGSize)numberSize
{ //6
	//Middle
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16), origin.y)];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y)];
	//Top
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16) , origin.y - (9*numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y - (9*numberSize.height/16))];
	//Bottom
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16), origin.y + (9*numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y + (9*numberSize.height/16))];
	//lower right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (4*numberSize.height/8))];
	//Upper left
	[mainPath moveToPoint:CGPointMake(origin.x, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x, origin.y - (4*numberSize.height/8))];
	//lower left
	[mainPath moveToPoint:CGPointMake(origin.x, origin.y + (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x, origin.y + (4*numberSize.height/8))];
}

- (void)drawSevenOnPath:(UIBezierPath *) mainPath atPoint:(CGPoint) origin withSize:(CGSize)numberSize
{ //7
	//Top
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16) , origin.y - (9*numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y - (9*numberSize.height/16))];
	//lower right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (4*numberSize.height/8))];
	//Upper right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint: CGPointMake(origin.x + numberSize.width, origin.y - (4*numberSize.height/8))];
}

- (void)drawEightOnPath:(UIBezierPath *) mainPath atPoint:(CGPoint) origin withSize:(CGSize)numberSize
{ //8
	//Middle
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16), origin.y)];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y)];
	//Upper right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint: CGPointMake(origin.x + numberSize.width, origin.y - (4*numberSize.height/8))];
	//Top
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16) , origin.y - (17*numberSize.height/32))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y - (17*numberSize.height/32))];
	//Upper left
	[mainPath moveToPoint:CGPointMake(origin.x, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x, origin.y - (4*numberSize.height/8))];
	//lower left
	[mainPath moveToPoint:CGPointMake(origin.x, origin.y + (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x, origin.y + (4*numberSize.height/8))];
	//lower right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (4*numberSize.height/8))];
	//Bottom
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16), origin.y + (17*numberSize.height/32))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y + (17*numberSize.height/32))];
}

- (void)drawNineOnPath:(UIBezierPath *) mainPath atPoint:(CGPoint) origin withSize:(CGSize)numberSize
{ //9
	//Upper right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint: CGPointMake(origin.x + numberSize.width, origin.y - (4*numberSize.height/8))];
	//Top
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16) , origin.y - (9*numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y - (9*numberSize.height/16))];
	//Upper left
	[mainPath moveToPoint:CGPointMake(origin.x, origin.y - (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x, origin.y - (4*numberSize.height/8))];
	//Middle
	[mainPath moveToPoint:CGPointMake(origin.x + (numberSize.width/16), origin.y)];
	[mainPath addLineToPoint:CGPointMake(origin.x + (15*numberSize.width/16), origin.y)];
	//lower right
	[mainPath moveToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (numberSize.height/16))];
	[mainPath addLineToPoint:CGPointMake(origin.x + numberSize.width, origin.y + (4*numberSize.height/8))];
}

- (void)drawColonOnPath:(UIBezierPath *) mainPath atPoint:(CGPoint) origin withSize:(CGSize)numberSize
{ //:
	
	//Top dot
	[mainPath moveToPoint:CGPointMake(origin.x + (2*numberSize.width/5), origin.y + (numberSize.height/4) +(numberSize.height/10))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (3*numberSize.width/5), origin.y + (numberSize.height/4) + (numberSize.height/10))];
	//Bottom dot
	[mainPath moveToPoint:CGPointMake(origin.x + (2*numberSize.width/5), origin.y - (numberSize.height/4) - (numberSize.height/10))];
	[mainPath addLineToPoint:CGPointMake(origin.x + (3*numberSize.width/5), origin.y - (numberSize.height/4) - (numberSize.height/10))];

}


@end
