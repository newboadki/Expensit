//
//  MyView.m
//  lineCharts
//
//  Created by Borja Arias Drake on 02/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import "LineGraph.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kGraphLeftMargin = 30.0f;
static const CGFloat kGraphLeftPadding = 5.0f;
static const CGFloat kGraphRightMargin = 0.0f;
static const CGFloat kGraphTopMargin = 20.0f;
static const CGFloat kGraphBottomMargin = 20.0f;
static const CGFloat kGraphDrawableAreaTopMargin = 20.0f; // This is inside the grid, so the lines don't reach the top of the grid

@interface LineGraph()

@property (retain, nonatomic) UIColor* backgroundColor;
@property (retain, nonatomic) UIColor* backgroundVerticalLinesColor;
@property (retain, nonatomic) UIColor* backgroundHorizontalLinesColor;

@end



@implementation LineGraph



#pragma mark - Init Methods

- (id) initWithCoder:(NSCoder *)aDecoder
{
    /*************************************************************************************************/
    /* Init Method.                                                                                  */
    /*************************************************************************************************/
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Set the colors
        UIColor* lightBlue = [UIColor colorWithRed:180.0/256.0 green:180.0/256.0 blue:180.0/256.0 alpha:0.4];
        UIColor* darkBlue = [UIColor colorWithRed:39.0/256.0 green:64.0/256.0 blue:139.0/256.0 alpha:1.0];
        _backgroundHorizontalLinesColor = lightBlue;
        _backgroundVerticalLinesColor = lightBlue;
        _backgroundColor = darkBlue;
    }
    
    return self;
}



#pragma mark - Draw Rect

- (void)drawRect:(CGRect)rect
{    
    /*************************************************************************************************/
    /* Custom drawing code.                                                                          */
    /*************************************************************************************************/
    // COLORS
    UIColor *greenLineColor = [UIColor colorWithRed:168.0/255.0 green:209.0/255.0 blue:141.0/255.0 alpha:1.0];
    UIColor *redLineColor = [UIColor colorWithRed:209.0/255.0 green:91.0/255.0 blue:82.0/255.0 alpha:1.0];

    // DEFINE DRAWABLE AREAS
    CGRect backgroundRect = rect;
    CGRect gridRect = CGRectMake(kGraphLeftMargin,
                                 kGraphTopMargin,
                                 self.bounds.size.width - kGraphLeftMargin - kGraphRightMargin,
                                 self.bounds.size.height - kGraphTopMargin - kGraphBottomMargin);
    
    CGRect graphsRect = CGRectMake(kGraphLeftMargin,
                                   kGraphTopMargin,
                                   self.bounds.size.width - kGraphLeftMargin - kGraphRightMargin,
                                   self.bounds.size.height - kGraphTopMargin - kGraphBottomMargin - kGraphDrawableAreaTopMargin);

    
    // MODIFY DATA FOR DRAWING
    NSMutableArray *moneyIn = [[self.dataSource moneyIn] mutableCopy];
    NSMutableArray *moneyOut = [[self.dataSource moneyOut] mutableCopy];
    
    if (!moneyIn || !moneyOut) {
        return;
    }
    NSMutableArray *pointsIn = [NSMutableArray array];
    NSMutableArray *pointsOut = [NSMutableArray array];
    CGFloat numberOfHorizontalPoints = [[self.dataSource xValues] count];
    CGFloat sum = 0;
    CGFloat step = graphsRect.size.width / (numberOfHorizontalPoints - 1 );
    
    
    NSMutableArray *maxArray = [NSMutableArray array];
    [maxArray addObject:[moneyIn valueForKeyPath:@"@max.self"]];
    [maxArray addObject:[moneyOut valueForKeyPath:@"@max.self"]];
    CGFloat maxPhysicalHeight = graphsRect.size.height;
    CGFloat maxDomainValue = [[maxArray valueForKeyPath:@"@max.self"] floatValue];
    CGFloat scalingFactor = 1.0f;
    
    if (maxDomainValue > maxPhysicalHeight) {
        scalingFactor = maxPhysicalHeight / maxDomainValue;
    } else {
        scalingFactor = maxDomainValue / maxPhysicalHeight;
    }
        
    
    CGFloat numerator = 0;
    CGFloat denominator = 0;
    
    
    // Guarantee that the denominator is always bigger
    if (denominator < numerator) {
        CGFloat aux = numerator;
        numerator = denominator;
        denominator = aux;
    }

    
    for (int i = 0; i< [moneyIn count]; i++) {
        CGPoint point = CGPointZero;
        point.x = sum;
        point.y = [moneyIn[i] floatValue] * scalingFactor;
        
        pointsIn[i] = [NSValue valueWithCGPoint:point];
        
        sum += step;
    }
    
    sum = 0;
    
    for (int i=0; i<[moneyOut count]; i++) {
        CGPoint point = CGPointZero;
        point.x = sum;
        point.y = [moneyOut[i] floatValue] * scalingFactor;
        
        pointsOut[i] = [NSValue valueWithCGPoint:point];
        
        sum += step;
    }

    // MOVE THE ORIGIN TO THE LEFT BOTTOM CORNER
    
    
    
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(theContext);
    CGContextTranslateCTM(theContext, 0, self.bounds.size.height);
    CGContextScaleCTM(theContext, 1, -1);
    
    // DRAW BACKGROUND + GRID
    [self drawBackgroundInRect:backgroundRect];
    [self drawGridInRect:gridRect horizontalLines:9 verticalLines:[moneyIn count]];
    
    // DRAW GRAPH
    CGContextTranslateCTM(theContext, kGraphLeftMargin, kGraphBottomMargin);
    
    [self strokeGraphLineWithPoints:pointsIn andLength:[pointsIn count] lineColor:greenLineColor];
    [self strokeGraphLineWithPoints:pointsOut andLength:[pointsOut count] lineColor:redLineColor];
    
    // DRAW SUBPATHS
    NSMutableArray *subpaths = [[NSMutableArray alloc] init];
    
    int lastGradient = [self gradientBetweenMoneyIn:[(NSValue*)pointsIn[0] CGPointValue] andMoneyOut:[(NSValue*)pointsOut[0] CGPointValue]];
    int index = 1;
    int initialSubpathIndex = 0;
    
    while (index < [moneyIn count])
    {
        int currentPairGradient = [self gradientBetweenMoneyIn:[pointsIn[index] CGPointValue] andMoneyOut:[(NSValue*)pointsOut[index] CGPointValue]];
        
        if ((lastGradient != 0) && (lastGradient != currentPairGradient))
        {
            // There's an interecsection
            CGPoint intersectionPoint = CGPointZero;
            if (currentPairGradient == 0) {
                intersectionPoint = [pointsIn[index] CGPointValue];
            } else {
                intersectionPoint = [self intersectionPointBwetweenWithFirstLineFirstPoint:[pointsIn[index-1] CGPointValue]
                                                                      firstLineSecondPoint:[pointsIn[index] CGPointValue]
                                                                      secondLineFirstPoint:[pointsOut[index-1] CGPointValue]
                                                                     secondLineSecondPoint:[pointsOut[index] CGPointValue]];
            }

            if (currentPairGradient != 0 ) {
                [pointsIn insertObject:[NSValue valueWithCGPoint:intersectionPoint] atIndex:index];
                [pointsOut insertObject:[NSValue valueWithCGPoint:intersectionPoint] atIndex:index];
            }
            
            [self addNewSubpathTo:subpaths withMoneyIn:pointsIn moneyOut:pointsOut initialSubPathIndex:initialSubpathIndex currentIndex:index gradient:lastGradient];
            lastGradient = [self gradientBetweenMoneyIn:[(NSValue*)pointsIn[index] CGPointValue] andMoneyOut:[(NSValue*)pointsOut[index] CGPointValue]];
            

            initialSubpathIndex = index;
        }
        else
        {
            // There's no change
            
            lastGradient = currentPairGradient;
        }
        
        index++;
        
    }
    
    if (lastGradient != 0 ) {
        // we need to add the last path
        [self addNewSubpathTo:subpaths withMoneyIn:pointsIn moneyOut:pointsOut initialSubPathIndex:initialSubpathIndex currentIndex:[pointsIn count]-1 gradient:lastGradient];
    }
    
    
    [self strokeGraphLineWithPoints:pointsIn andLength:[pointsIn count] lineColor:greenLineColor];
    [self strokeGraphLineWithPoints:pointsOut andLength:[pointsOut count] lineColor:redLineColor];
    
    for (NSDictionary *subpathDic in subpaths)
    {
        CGContextSaveGState(UIGraphicsGetCurrentContext());
        [subpathDic[@"path"] addClip];
        // Draw a gradient
        CGPoint startPoint = CGPointMake(0.0, 0.0);
        CGPoint endPoint = CGPointMake(0.0, self.bounds.size.height);

        if ([subpathDic[@"gradient"] integerValue] > 0)
        {
            CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), [self greenGraphAreaGradient], startPoint, endPoint, 0);
        } else
        {
            CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), [self redGraphAreaGradient], startPoint, endPoint, 0);
        }
        
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
    
    CGContextRestoreGState(theContext);
}


- (int) gradientBetweenMoneyIn:(CGPoint)moneyIn andMoneyOut:(CGPoint)moneyOut
{
    return (moneyIn.y > moneyOut.y) ? 1 : (moneyIn.y < moneyOut.y) ? -1 : 0;
}


- (CGPoint) intersectionPointBwetweenWithFirstLineFirstPoint:(CGPoint)firstLineFirstPoint
firstLineSecondPoint:(CGPoint)firstLineSecondPoint
secondLineFirstPoint:(CGPoint)secondLineFirstPoint
secondLineSecondPoint:(CGPoint)secondLineSecondPoint {
    
    //Calculate Line1 equation
    CGFloat L1_a = (firstLineSecondPoint.y - firstLineFirstPoint.y) / (firstLineSecondPoint.x - firstLineFirstPoint.x);
    CGFloat L1_b = firstLineFirstPoint.y - (L1_a * firstLineFirstPoint.x);
    
    //Calculate Line2 equation
    CGFloat L2_a = (secondLineSecondPoint.y - secondLineFirstPoint.y) / (secondLineSecondPoint.x - secondLineFirstPoint.x);
    CGFloat L2_b = secondLineFirstPoint.y - (L2_a * secondLineFirstPoint.x);
    
    // Calculate IPx
    CGFloat IPx = (L2_b - L1_b) / (L1_a - L2_a);
    
    // Calculate IPy, using the first line for example
    CGFloat IPy = L1_a * IPx + L1_b;
    
    return CGPointMake(IPx, IPy);
}


- (void) addNewSubpathTo:(NSMutableArray*)subpaths withMoneyIn:(NSMutableArray*)moneyIn moneyOut:(NSMutableArray*)moneyOut initialSubPathIndex:(int)initialIndex currentIndex:(int)currentIndex gradient:(int)gradient
{
    UIBezierPath *subpath = [UIBezierPath bezierPath];
    CGPoint initialPoint = [moneyIn[initialIndex] CGPointValue];
    [subpath moveToPoint:initialPoint];
    
    int initialLoopValue = initialIndex;
    if (initialIndex+1 < [moneyIn count]) {
        initialLoopValue = initialIndex + 1;
    }
    
    for (int i = initialLoopValue ; i<=currentIndex; i++) {
        [subpath addLineToPoint:[(NSValue*)moneyIn[i] CGPointValue]];
    }
    
    for (int i = currentIndex ; i>=initialIndex; i--) {
        [subpath addLineToPoint:[(NSValue*)moneyOut[i] CGPointValue]];
    }

    if (!CGPointEqualToPoint([(NSValue*)moneyIn[initialIndex] CGPointValue], [(NSValue*)moneyOut[initialIndex] CGPointValue])) {
        [subpath addLineToPoint:[(NSValue*)moneyIn[initialIndex] CGPointValue]];
    }
    
    [subpaths addObject:@{@"path" :subpath, @"gradient" : @(gradient)}];
}



#pragma mark - Drawing Helpers

- (void) drawLineWithPointsInRect:(CGRect)rect points:(NSArray*) points length:(int)length lineColor:(UIColor*)lineColor
{
    /*************************************************************************************************/
    /* Draws the actual graph line and the area undeneath it.                                        */
    /* Draws in a different context as we do clipping, use strokes colors etc that won't be necessary*/
    /* In later drawings.                                                                            */
    /*************************************************************************************************/
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
        // Create a Path to represent the clipping area
        UIBezierPath* clippingPath = [self closedPathForPoints:points length:length];
        [clippingPath addClip];
        
        // Draw in the clipped area
    CGContextDrawLinearGradient(con, [self greenGraphAreaGradient], CGPointMake(0, 0), CGPointMake(0, self.bounds.size.height), 0);
        //[self drawHorizontalBackgroundLinesInRect: rect numberOfLines: 64 color: [UIColor colorWithRed:212.0/256.0 green:254.0/256.0 blue:199.0/256.0 alpha:0.4] lineWidth: 3.5 dashed: NO];
            
        // We Actually draw the graph line, in two segments 1. the line, 2. the segment that connects to the origin
    [self strokeGraphLineWithPoints:points andLength:length lineColor:lineColor];
    CGContextRestoreGState(con);
}


- (UIBezierPath*) closedPathForPoints:(NSArray*)points length:(int)length
{
    /*************************************************************************************************/
    /* Creates an autoreleased and closed UIBezierPath representing the area underneath the graph    */
    /* line. The first point is always on the y axis. The last one might not, in that case, we want  */
    /* To make some extra points to close the path. We'll connect with a point on the x axis, then to*/
    /* the origin, and finally to the first point.                                                   */
    /*************************************************************************************************/
    // TODO: Generalise the way we are closing the path! at the moment assumes some conditions
    
    UIBezierPath* clippingPath = [[UIBezierPath alloc] init];
    [[UIColor whiteColor] setStroke];
    [clippingPath moveToPoint:[(NSValue*)points[0] CGPointValue]];
    
    for (int i=1; i<length; i++)
    {
        [clippingPath addLineToPoint:[(NSValue*)points[i] CGPointValue]];
    } 
    
    [clippingPath addLineToPoint:[(NSValue*)points[0] CGPointValue]];

    return clippingPath;
}


- (void) strokeGraphLineWithPoints:(NSArray*)points andLength:(int)length lineColor:(UIColor*)lineColor
{
    /*************************************************************************************************/
    /* Creates a path following the points in point and stroke them.                                 */
    /*************************************************************************************************/
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    
    
        const float* colors = CGColorGetComponents( lineColor.CGColor );
        CGContextSetRGBStrokeColor(con, colors[0], colors[1], colors[2], 1.0);
        CGContextSetLineWidth(con, 1.5);
        
        // Create the visible part of the graph and stroke it
        CGContextMoveToPoint(con, [(NSValue*)points[0] CGPointValue].x, [(NSValue*)points[0] CGPointValue].y);
        
        for (int i=1; i<length; i++)
        {
            CGContextAddLineToPoint(con, [(NSValue*)points[i] CGPointValue].x, [(NSValue*)points[i] CGPointValue].y);
        }
        
        CGContextStrokePath(con);
    
    CGContextRestoreGState(con);
}


- (void) drawBackgroundInRect:(CGRect)rect
{
    /*************************************************************************************************/
    /* sets the Background color and draws the grid.                                                 */
    /*************************************************************************************************/
    // Round the corners
    UIBezierPath* roundedCornersPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(16.0, 16.0)];
    [roundedCornersPath addClip];
    
    // Draw a gradient
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(0.0, self.bounds.size.height);
    CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), [self backgroundGradient], startPoint, endPoint, 0);
}

- (void) drawGridInRect:(CGRect)rect horizontalLines:(int)horizontalLines verticalLines:(int)verticalLines
{
    [self drawVerticalBackgroundLinesInRect:rect numberOfLines:verticalLines color:self.backgroundVerticalLinesColor];
    [self drawHorizontalBackgroundLinesInRect:rect numberOfLines:horizontalLines color:self.backgroundHorizontalLinesColor lineWidth:1.0 dashed:YES];
}

- (CGGradientRef) backgroundGradient
{
    CGFloat colors[16] = {28.0/255, 39.0/255, 24.0/255, 1.0,
                          28.0/255, 39.0/255, 24.0/255, 1.0,
                          28.0/255, 39.0/255, 24.0/255, 1.0,
                          28.0/255, 39.0/255, 24.0/255, 1.0};

    CGFloat locations[4] = {0.0, 0.5f, 0.5f, 1.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 4);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}


- (CGGradientRef) greenGraphAreaGradient
{
    CGFloat colors[16] = {17.0/255, 49.0/255, 16.0/255, 0.6,
                          27.0/255, 78.0/255, 25.0/255, 0.1,
                          27.0/255, 78.0/255, 25.0/255, 0.2,
                          119.0/255, 193.0/255, 112.0/255, 0.9};
    CGFloat locations[4] = {0.0, 0.25f, 0.5f, 1.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 4);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}

- (CGGradientRef) redGraphAreaGradient
{
    CGFloat colors[16] = {248.0/255, 213.0/255, 200.0/255, 0.1,
        248.0/255, 213.0/255, 200.0/255, 0.1,
        209.0/255, 151.0/255, 136.0/255, 0.2,
        209.0/255, 107.0/255, 101.0/255, 0.9};
    CGFloat locations[4] = {0.0, 0.25f, 0.5f, 1.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 4);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}


- (void) drawVerticalBackgroundLinesInRect:(CGRect)rect numberOfLines:(int)numberOfLines color:(UIColor*)color
{
    /*************************************************************************************************/
    /*                                                                                               */
    /*************************************************************************************************/
    int numberOfRegions = numberOfLines - 1; // because we're creating lines at the edges too.
    float distanceBetweenLines = rect.size.width / numberOfRegions;
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);

    CGContextTranslateCTM(con, 0, self.bounds.size.height);
    CGContextScaleCTM(con, 1, -1);

        UIBezierPath* verticalLinePath = [UIBezierPath bezierPath];
        [color setStroke];
        [verticalLinePath setLineWidth:0.5];
        [verticalLinePath moveToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
        [verticalLinePath addLineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
        CGContextTranslateCTM(con, rint(distanceBetweenLines), 0.0);
        [verticalLinePath stroke];

        for (int i=1; i<numberOfLines-1; i++)
        {
            // Draw line
            CGContextTranslateCTM(con, rint(distanceBetweenLines), 0.0);
            [verticalLinePath stroke];
        }
    
    CGContextRestoreGState(con);
}


- (void) drawHorizontalBackgroundLinesInRect:(CGRect)rect numberOfLines:(int)numberOfLines color:(UIColor*)color lineWidth:(float)lineWidth dashed:(BOOL)dashed
{
    /*************************************************************************************************/
    /*                                                                                               */
    /*************************************************************************************************/
    int numberOfRegions = numberOfLines-1; // because we're creating lines at the edges too.
    float distanceBetweenLines = rect.size.height / numberOfRegions;
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    
        CGContextTranslateCTM(con, 0, self.bounds.size.height);
        CGContextScaleCTM(con, 1, -1);

        UIBezierPath* horizontalLinePath = [UIBezierPath bezierPath];
        [color setStroke];
        [horizontalLinePath setLineWidth:lineWidth];
        [horizontalLinePath moveToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
        [horizontalLinePath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
        [horizontalLinePath stroke];
            
        if (dashed)
        {
            const float sizes[2] = {1, 2};
            [horizontalLinePath setLineDash:sizes count:2 phase:0.0];
        }
        
        for (int i=1; i<numberOfLines; i++)
        {
            // Draw line
            CGContextTranslateCTM(con, 0.0, distanceBetweenLines);
            [horizontalLinePath stroke];
        }
    
    CGContextRestoreGState(con);
}




#pragma mark - Memory Management

- (void)dealloc
{
    /*************************************************************************************************/
    /* Tidy-Up                                                                                       */
    /*************************************************************************************************/
    
}

@end
