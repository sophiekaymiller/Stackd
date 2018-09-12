#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Filestack.h"

FOUNDATION_EXPORT double FilestackVersionNumber;
FOUNDATION_EXPORT const unsigned char FilestackVersionString[];

