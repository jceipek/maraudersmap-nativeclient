//
//  NSString+NSString_URLManipulation.m
//  Map
//
//  Created by Julian Ceipek on 6/15/12.
//  Copyright (c) 2012-2013 SLAC. All rights reserved.
//

#import "NSString+NSString_URLManipulation.h"

@implementation NSString (NSString_URLManipulation)

// Based on http://stackoverflow.com/questions/718429/creating-url-query-parameters-from-nsdictionary-objects-in-objectivec
// Encode a percent escape encoded string.
-(NSString*)urlEncodeString {
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)self;
    NSString *encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
                                                                                                    originalStringRef, 
                                                                                                    NULL, 
                                                                                                    NULL,
                                                                                                    kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return encodedString;
}

// Based on http://stackoverflow.com/questions/7920071/how-to-url-decode-in-ios-objective-c
// Decode a percent escape encoded string.
-(NSString*)urlDecodeString {
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)self;
    NSString *decodedString = (__bridge NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, 
                                                                                                            originalStringRef,
                                                                                                            CFSTR(""),
                                                                                                            kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return decodedString;
}

// Based on http://stackoverflow.com/questions/718429/creating-url-query-parameters-from-nsdictionary-objects-in-objectivec
-(NSString*)addQueryStringToUrlStringWithDictionary:(NSDictionary *)dictionary {
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:self];
    for (id key in dictionary) {
        NSString *keyString = [key description];
        NSString *valueString = [[dictionary objectForKey:key] description];
        
        if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
            [urlWithQuerystring appendFormat:@"?%@=%@", [keyString urlEncodeString], [valueString urlEncodeString]];
        } else {
            [urlWithQuerystring appendFormat:@"&%@=%@", [keyString urlEncodeString], [valueString urlEncodeString]];
        }
    }
    return urlWithQuerystring;

}


@end
