#import "DHAppDelegate.h"

@implementation DHAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.progressView setMaxValue:100.0f];
    [self.progressView setCurrentValue:0.0f];
    [self.progressView setIncrementalSteps:[NSArray arrayWithObjects:[NSNumber numberWithDouble:25.0f], [NSNumber numberWithDouble:50.0f], [NSNumber numberWithDouble:75.0f], [NSNumber numberWithDouble:80.0f], nil]];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)tick
{
    if(self.progressView.currentValue == self.progressView.maxValue)
    {
        self.progressView.currentValue = 0.0f;
    }
    [self.progressView incrementBy:0.2f];
}


@end
