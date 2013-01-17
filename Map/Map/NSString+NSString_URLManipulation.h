//
//  NSString+NSString_URLManipulation.h
//  Map
//
//  Created by Julian Ceipek on 6/15/12.
//  Copyright (c) 2012-2013 ohack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_URLManipulation)

-(NSString*)urlEncodeString;
-(NSString*)urlDecodeString;
-(NSString*)addQueryStringToUrlStringWithDictionary:(NSDictionary *)dictionary;

@end
