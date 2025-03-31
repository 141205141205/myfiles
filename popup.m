#import <Cocoa/Cocoa.h>
#import <stdlib.h>
#import <time.h>

@interface HydraWindow : NSWindow
@property (nonatomic, assign) int xVelocity;
@property (nonatomic, assign) int yVelocity;
@property (nonatomic, assign) int xPos;
@property (nonatomic, assign) int yPos;

- (void)move;
- (void)spawnTwo;
@end

@implementation HydraWindow

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithContentRect:frame styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable) backing:NSBackingStoreBuffered defer:NO];
    if (self) {
        self.xVelocity = arc4random_uniform(2) == 0 ? -10 : 10;
        self.yVelocity = arc4random_uniform(2) == 0 ? -10 : 10;
        
        NSScreen *screen = [NSScreen mainScreen];
        NSRect screenFrame = [screen frame];
        self.xPos = arc4random_uniform(screenFrame.size.width - 400);
        self.yPos = arc4random_uniform(screenFrame.size.height - 300);
        
        [self setFrame:NSMakeRect(self.xPos, self.yPos, 500, 300) display:YES];
        [self setLevel:NSFloatingWindowLevel];
        [self setStyleMask:[self styleMask] & ~NSWindowStyleMaskClosable];
        
        NSTextView *textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, 400, 300)];
        [textView setString:@"You Cant Close Me"];
        [textView setEditable:NO];
        [textView setBackgroundColor:[NSColor clearColor]];
        [textView setTextColor:[NSColor redColor]];
        [textView setFont:[NSFont systemFontOfSize:40]];

        NSDictionary *attributes = @{ NSFontAttributeName: [NSFont systemFontOfSize:40], NSForegroundColorAttributeName: [NSColor redColor] };
        NSSize textSize = [[textView string] sizeWithAttributes:attributes];
        CGFloat x = (self.frame.size.width - textSize.width) / 2;
        CGFloat y = (self.frame.size.height - textSize.height) / 2;
        
        [textView setFrame:NSMakeRect(x, y, textSize.width, textSize.height)];
        
        [self.contentView addSubview:textView];
    }
    return self;
}

- (void)move {
    NSScreen *screen = [NSScreen mainScreen];
    NSRect screenFrame = [screen frame];
    
    self.xPos += self.xVelocity;
    self.yPos += self.yVelocity;
    
    if (self.xPos <= 0 || self.xPos + 400 >= screenFrame.size.width)
        self.xVelocity *= -1;
    if (self.yPos <= 0 || self.yPos + 300 >= screenFrame.size.height)
        self.yVelocity *= -1;
    
    [self setFrame:NSMakeRect(self.xPos, self.yPos, 400, 300) display:YES];
    [self performSelector:@selector(move) withObject:nil afterDelay:0.03];
}

- (void)spawnTwo {
    HydraWindow *newWindow1 = [[HydraWindow alloc] initWithFrame:NSMakeRect(100, 100, 400, 300)];
    [newWindow1 makeKeyAndOrderFront:nil];
    [newWindow1 move];
    
    HydraWindow *newWindow2 = [[HydraWindow alloc] initWithFrame:NSMakeRect(200, 200, 400, 300)];
    [newWindow2 makeKeyAndOrderFront:nil];
    [newWindow2 move];

    HydraWindow *newWindow3 = [[HydraWindow alloc] initWithFrame:NSMakeRect(200, 200, 400, 300)];
    [newWindow3 makeKeyAndOrderFront:nil];
    [newWindow3 move];
    
    HydraWindow *newWindow4 = [[HydraWindow alloc] initWithFrame:NSMakeRect(200, 200, 400, 300)];
    [newWindow4 makeKeyAndOrderFront:nil];
    [newWindow4 move];
}

@end

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>
@property (nonatomic, strong) NSMutableArray *windows;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    srand((unsigned int)time(NULL));
    self.windows = [NSMutableArray array];
    
    [self spawnNewWindows];
}

- (void)spawnNewWindows {
    [self spawnNewWindow];
    [self performSelector:@selector(spawnNewWindows) withObject:nil afterDelay:3.0];
}

- (void)spawnNewWindow {
    HydraWindow *window = [[HydraWindow alloc] initWithFrame:NSMakeRect(100, 100, 400, 300)];
    [window makeKeyAndOrderFront:nil];
    [window move];
    
    [self.windows addObject:window];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return NO;
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        AppDelegate *delegate = [[AppDelegate alloc] init];
        [app setDelegate:delegate];
        [app run];
    }
    return 0;
}