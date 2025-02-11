/******************************************************************************
 * Copyright (c) 2007-2012 Transmission authors and contributors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *****************************************************************************/

#import "DragOverlayView.h"

#define PADDING 10.0
#define ICON_WIDTH 64.0

@implementation DragOverlayView

- (instancetype)initWithFrame:(NSRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        //create attributes
        NSShadow* stringShadow = [[NSShadow alloc] init];
        stringShadow.shadowOffset = NSMakeSize(2.0, -2.0);
        stringShadow.shadowBlurRadius = 4.0;

        NSFont *bigFont = [NSFont boldSystemFontOfSize:18.0], *smallFont = [NSFont systemFontOfSize:14.0];

        NSMutableParagraphStyle* paragraphStyle = [NSParagraphStyle.defaultParagraphStyle mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;

        fMainLineAttributes = @{
            NSForegroundColorAttributeName : NSColor.whiteColor,
            NSFontAttributeName : bigFont,
            NSShadowAttributeName : stringShadow,
            NSParagraphStyleAttributeName : paragraphStyle
        };

        fSubLineAttributes = @{
            NSForegroundColorAttributeName : NSColor.whiteColor,
            NSFontAttributeName : smallFont,
            NSShadowAttributeName : stringShadow,
            NSParagraphStyleAttributeName : paragraphStyle
        };
    }
    return self;
}

- (void)setOverlay:(NSImage*)icon mainLine:(NSString*)mainLine subLine:(NSString*)subLine
{
    //create badge
    NSRect const badgeRect = NSMakeRect(0.0, 0.0, 325.0, 84.0);

    fBadge = [[NSImage alloc] initWithSize:badgeRect.size];
    [fBadge lockFocus];

    NSBezierPath* bp = [NSBezierPath bezierPathWithRoundedRect:badgeRect xRadius:15.0 yRadius:15.0];
    [[NSColor colorWithCalibratedWhite:0.0 alpha:0.75] set];
    [bp fill];

    //place icon
    [icon drawInRect:NSMakeRect(PADDING, (NSHeight(badgeRect) - ICON_WIDTH) * 0.5, ICON_WIDTH, ICON_WIDTH) fromRect:NSZeroRect
           operation:NSCompositeSourceOver
            fraction:1.0];

    //place main text
    NSSize const mainLineSize = [mainLine sizeWithAttributes:fMainLineAttributes];
    NSSize const subLineSize = [subLine sizeWithAttributes:fSubLineAttributes];

    NSRect lineRect = NSMakeRect(
        PADDING + ICON_WIDTH + 5.0,
        (NSHeight(badgeRect) + (subLineSize.height + 2.0 - mainLineSize.height)) * 0.5,
        NSWidth(badgeRect) - (PADDING + ICON_WIDTH + 2.0) - PADDING,
        mainLineSize.height);
    [mainLine drawInRect:lineRect withAttributes:fMainLineAttributes];

    //place sub text
    lineRect.origin.y -= subLineSize.height + 2.0;
    lineRect.size.height = subLineSize.height;
    [subLine drawInRect:lineRect withAttributes:fSubLineAttributes];

    [fBadge unlockFocus];

    self.needsDisplay = YES;
}

- (void)drawRect:(NSRect)rect
{
    if (fBadge)
    {
        NSRect const frame = self.frame;
        NSSize const imageSize = fBadge.size;
        [fBadge drawAtPoint:NSMakePoint((NSWidth(frame) - imageSize.width) * 0.5, (NSHeight(frame) - imageSize.height) * 0.5)
                   fromRect:NSZeroRect
                  operation:NSCompositeSourceOver
                   fraction:1.0];
    }
}

@end
