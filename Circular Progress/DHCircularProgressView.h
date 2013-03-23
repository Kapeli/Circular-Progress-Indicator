#import <Cocoa/Cocoa.h>

@interface DHCircularProgressView : NSView

- (void)incrementBy:(double)value;
- (void)setMaxValue:(double)maxValue;
- (void)setCurrentValue:(double)currentValue;
- (void)setIncrementalSteps:(NSArray *)incrementalSteps;

- (double)currentValue;
- (double)maxValue;

@end
