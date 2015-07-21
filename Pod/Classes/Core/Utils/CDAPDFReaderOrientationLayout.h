//
//  CDAPDFReaderOrientationLayout.h
//  Pods
//
//  Created by Gerardo Garrido on 16/07/15.
//
//

#ifndef Pods_CDAPDFReaderOrientationLayout_h
#define Pods_CDAPDFReaderOrientationLayout_h

/// The way the pages of the PDFReader can be displayed
typedef NS_OPTIONS(NSUInteger, CDAPDFReaderOrientationLayout){
    CDAPDFReaderOrientationLayoutNone = 0,
    /// The pages are displayed in portrait when the device is in Portrait or PortraitUpsideDown
    CDAPDFReaderOrientationLayoutPortrait = 1 << 0,
    /// The pages are displayed in landscape when the device is in LandscapeLeft or LandscapeRight
    CDAPDFReaderOrientationLayoutLandscape = 1 << 1
};

#endif
