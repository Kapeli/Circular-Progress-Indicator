#import "DHCircularProgressView.h"

@interface DHCircularProgressView()

@property (strong) NSArray *steps;
@property (assign) double max;
@property (assign) double current;

@end

@implementation DHCircularProgressView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
    }
    return self;
}

- (void)incrementBy:(double)value
{
    self.current += value;
    if(self.current > self.max)
    {
        self.current = self.max;
    }
    [self setNeedsDisplay:YES];
}

- (void)setMaxValue:(double)maxValue
{
    self.max = maxValue;
    [self setNeedsDisplay:YES];
}

- (void)setCurrentValue:(double)currentValue
{
    self.current = currentValue;
    [self setNeedsDisplay:YES];
}

- (void)setIncrementalSteps:(NSArray *)incrementalSteps
{
    self.steps = incrementalSteps;
    [self setNeedsDisplay:YES];
}

- (double)currentStepMaxValue
{
    for(NSNumber *step in self.steps)
    {
        if([step doubleValue] >= self.current)
        {
            return [step doubleValue];
        }
    }
    return self.max;
}

- (double)previousStepMaxValue
{
    for(NSNumber *step in [[self.steps reverseObjectEnumerator] allObjects])
    {
        if([step doubleValue] < self.current)
        {
            return [step doubleValue];
        }
    }
    return 0;
}

- (double)currentValue
{
    return self.current;
}

- (double)maxValue
{
    return self.max;
}

- (void)drawRect:(NSRect)dirtyRect
{
    //// Color Declarations
    NSColor* fillColor = [NSColor windowBackgroundColor];
    NSColor* secondaryProgressColor = [NSColor colorWithCalibratedRed: 0.128 green: 0.569 blue: 0.983 alpha: 1];
    NSColor* progressColor = [NSColor colorWithCalibratedRed: 0.135 green: 0.128 blue: 0.248 alpha: 1];
    NSColor* innerCircleColor = secondaryProgressColor;
    
    //// Image Declarations
    NSImage* progressImage = [NSImage imageNamed: @"progressImage"];
    
    //// Frames
    NSRect frame = NSMakeRect(0, 0, 36, 36);
    
    //// Subframes
    NSRect progressCircleGroup = NSMakeRect(NSMinX(frame), NSMinY(frame), NSWidth(frame), NSHeight(frame));
    NSRect innerCircleGroup = NSMakeRect(NSMinX(frame) + 8, NSMinY(frame) + 8, NSWidth(frame) - 16, NSHeight(frame) - 16);
    
    //// Abstracted Attributes
    CGFloat progressCircleStartAngle = 90;
    CGFloat secondaryProgressCircleStartAngle = 90;

    //pseudo math, seems to work:
    CGFloat progressCircleEndAngle = 360+(360-((self.current/self.max)*360))-270;
    progressCircleEndAngle = (progressCircleEndAngle > 360) ? progressCircleEndAngle-360 : progressCircleEndAngle;
    progressCircleEndAngle = (self.current == self.max) ? 90.001f : progressCircleEndAngle;
    
    double previousStepMaxValue = [self previousStepMaxValue];
    double currentStepMaxValue = [self currentStepMaxValue]-previousStepMaxValue;
    double currentStepValue = self.current-previousStepMaxValue;
    
    CGFloat secondaryProgressCircleEndAngle = 360+(360-((currentStepValue/currentStepMaxValue)*360))-270;
    secondaryProgressCircleEndAngle = (secondaryProgressCircleEndAngle > 360) ? secondaryProgressCircleEndAngle-360 : secondaryProgressCircleEndAngle;
    secondaryProgressCircleEndAngle = (currentStepValue == currentStepMaxValue) ? 90.001f : secondaryProgressCircleEndAngle;
    
    //// Progress Circle Group
    {
        //// Secondary Progress Circle Drawing
        NSRect secondaryProgressCircleRect = NSMakeRect(NSMinX(progressCircleGroup) + floor(NSWidth(progressCircleGroup) * 0.00000 + 0.5), NSMinY(progressCircleGroup) + floor(NSHeight(progressCircleGroup) * 0.00000 + 0.5), floor(NSWidth(progressCircleGroup) * 1.00000 + 0.5) - floor(NSWidth(progressCircleGroup) * 0.00000 + 0.5), floor(NSHeight(progressCircleGroup) * 1.00000 + 0.5) - floor(NSHeight(progressCircleGroup) * 0.00000 + 0.5));
        NSBezierPath* secondaryProgressCirclePath = [NSBezierPath bezierPath];
        [secondaryProgressCirclePath appendBezierPathWithArcWithCenter: NSMakePoint(NSMidX(secondaryProgressCircleRect), NSMidY(secondaryProgressCircleRect)) radius: NSWidth(secondaryProgressCircleRect) / 2 startAngle: secondaryProgressCircleStartAngle endAngle: secondaryProgressCircleEndAngle clockwise: YES];
        [secondaryProgressCirclePath lineToPoint: NSMakePoint(NSMidX(secondaryProgressCircleRect), NSMidY(secondaryProgressCircleRect))];
        [secondaryProgressCirclePath closePath];
        
        [secondaryProgressColor setFill];
        [secondaryProgressCirclePath fill];
        
        
        //// Trim Circle Drawing
        NSBezierPath* trimCirclePath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(NSMinX(progressCircleGroup) + floor(NSWidth(progressCircleGroup) * 0.11111 + 0.5), NSMinY(progressCircleGroup) + floor(NSHeight(progressCircleGroup) * 0.11111 + 0.5), floor(NSWidth(progressCircleGroup) * 0.88889 + 0.5) - floor(NSWidth(progressCircleGroup) * 0.11111 + 0.5), floor(NSHeight(progressCircleGroup) * 0.88889 + 0.5) - floor(NSHeight(progressCircleGroup) * 0.11111 + 0.5))];
        [fillColor setFill];
        [trimCirclePath fill];
        
        
        //// Progress Circle Drawing
        NSRect progressCircleRect = NSMakeRect(NSMinX(progressCircleGroup) + floor(NSWidth(progressCircleGroup) * 0.11111 + 0.5), NSMinY(progressCircleGroup) + floor(NSHeight(progressCircleGroup) * 0.11111 + 0.5), floor(NSWidth(progressCircleGroup) * 0.88889 + 0.5) - floor(NSWidth(progressCircleGroup) * 0.11111 + 0.5), floor(NSHeight(progressCircleGroup) * 0.88889 + 0.5) - floor(NSHeight(progressCircleGroup) * 0.11111 + 0.5));
        NSBezierPath* progressCirclePath = [NSBezierPath bezierPath];
        [progressCirclePath appendBezierPathWithArcWithCenter: NSMakePoint(NSMidX(progressCircleRect), NSMidY(progressCircleRect)) radius: NSWidth(progressCircleRect) / 2 startAngle: progressCircleStartAngle endAngle: progressCircleEndAngle clockwise: YES];
        [progressCirclePath lineToPoint: NSMakePoint(NSMidX(progressCircleRect), NSMidY(progressCircleRect))];
        [progressCirclePath closePath];
        
        [progressColor setFill];
        [progressCirclePath fill];
    }
    
    //// Inner Circle Group
    {
        //// Inner Circle Drawing
        NSBezierPath* innerCirclePath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(NSMinX(innerCircleGroup) + floor(NSWidth(innerCircleGroup) * 0.00000 + 0.5), NSMinY(innerCircleGroup) + floor(NSHeight(innerCircleGroup) * 0.00000 + 0.5), floor(NSWidth(innerCircleGroup) * 1.00000 + 0.5) - floor(NSWidth(innerCircleGroup) * 0.00000 + 0.5), floor(NSHeight(innerCircleGroup) * 1.00000 + 0.5) - floor(NSHeight(innerCircleGroup) * 0.00000 + 0.5))];
        [innerCircleColor setFill];
        [innerCirclePath fill];
        
        
        //// Image Circle Drawing
        NSRect imageCircleRect = NSMakeRect(NSMinX(innerCircleGroup) + floor(NSWidth(innerCircleGroup) * 0.00000 + 0.5), NSMinY(innerCircleGroup) + floor(NSHeight(innerCircleGroup) * 0.00000 + 0.5), floor(NSWidth(innerCircleGroup) * 1.00000 + 0.5) - floor(NSWidth(innerCircleGroup) * 0.00000 + 0.5), floor(NSHeight(innerCircleGroup) * 1.00000 + 0.5) - floor(NSHeight(innerCircleGroup) * 0.00000 + 0.5));
        NSBezierPath* imageCirclePath = [NSBezierPath bezierPathWithOvalInRect: imageCircleRect];
        [NSGraphicsContext saveGraphicsState];
        [imageCirclePath addClip];
        [progressImage drawInRect: NSMakeRect(floor(NSMinX(imageCircleRect) + 2 + 0.5), ceil(NSMinY(imageCircleRect) + 2 - 0.5), progressImage.size.width, progressImage.size.height) fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1];
        [NSGraphicsContext restoreGraphicsState];
    }
}

@end
