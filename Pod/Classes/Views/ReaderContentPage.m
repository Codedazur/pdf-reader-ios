//
//	ReaderContentPage.m
//	Reader v2.8.6
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2015 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ReaderConstants.h"
#import "ReaderContentPage.h"
#import "ReaderContentTile.h"

@implementation ReaderContentPage
{
	CGPDFPageRef _PDFPageRef;

	CGFloat _pageWidth;
	CGFloat _pageHeight;

	CGFloat _pageOffsetX;
	CGFloat _pageOffsetY;
}

#pragma mark - ReaderContentPage class methods

+ (Class)layerClass
{
	return [ReaderContentTile class];
}

#pragma mark - ReaderContentPage instance methods
- (instancetype)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.autoresizesSubviews = NO;
		self.userInteractionEnabled = NO;
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingNone;
		self.backgroundColor = [UIColor clearColor];
	}

	return self;
}
- (instancetype)initWithPageRef:(CGPDFPageRef)pageRef{

	CGRect viewRect = CGRectZero; // View rect
    _PDFPageRef = pageRef;

    CGPDFPageRetain(_PDFPageRef); // Retain the PDF page

    CGRect cropBoxRect = CGPDFPageGetBoxRect(_PDFPageRef, kCGPDFCropBox);
    CGRect mediaBoxRect = CGPDFPageGetBoxRect(_PDFPageRef, kCGPDFMediaBox);
    CGRect effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect);

    NSInteger pageAngle = CGPDFPageGetRotationAngle(_PDFPageRef); // Angle

    switch (pageAngle) // Page rotation angle (in degrees)
    {
        default: // Default case
        case 0: case 180: // 0 and 180 degrees
        {
            _pageWidth = effectiveRect.size.width;
            _pageHeight = effectiveRect.size.height;
            _pageOffsetX = effectiveRect.origin.x;
            _pageOffsetY = effectiveRect.origin.y;
            break;
        }

        case 90: case 270: // 90 and 270 degrees
        {
            _pageWidth = effectiveRect.size.height;
            _pageHeight = effectiveRect.size.width;
            _pageOffsetX = effectiveRect.origin.y;
            _pageOffsetY = effectiveRect.origin.x;
            break;
        }
    }

    NSInteger page_w = _pageWidth; // Integer width
    NSInteger page_h = _pageHeight; // Integer height

    if (page_w % 2) page_w--; if (page_h % 2) page_h--; // Even

    viewRect.size = CGSizeMake(page_w, page_h); // View size

	ReaderContentPage *view = [self initWithFrame:viewRect];

	return view;
}

- (void)removeFromSuperview
{
	self.layer.delegate = nil;

	//self.layer.contents = nil;

	[super removeFromSuperview];
}

- (void)dealloc
{
	CGPDFPageRelease(_PDFPageRef), _PDFPageRef = NULL;
}

#if (READER_DISABLE_RETINA == TRUE) // Option

- (void)didMoveToWindow
{
	self.contentScaleFactor = 1.0f; // Override scale factor
}

#endif // end of READER_DISABLE_RETINA Option

#pragma mark - CATiledLayer delegate methods

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)context
{
	ReaderContentPage *readerContentPage = self; // Retain self

	CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // White

	CGContextFillRect(context, CGContextGetClipBoundingBox(context)); // Fill

	//NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(CGContextGetClipBoundingBox(context)));

	CGContextTranslateCTM(context, 0.0f, self.bounds.size.height); CGContextScaleCTM(context, 1.0f, -1.0f);

	CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(_PDFPageRef, kCGPDFCropBox, self.bounds, 0, true));

	//CGContextSetRenderingIntent(context, kCGRenderingIntentDefault); CGContextSetInterpolationQuality(context, kCGInterpolationDefault);

	CGContextDrawPDFPage(context, _PDFPageRef); // Render the PDF page into the context

	if (readerContentPage != nil) readerContentPage = nil; // Release self
}
@end
