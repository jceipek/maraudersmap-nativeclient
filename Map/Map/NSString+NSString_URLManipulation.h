//
//  NSString+NSString_URLManipulation.h
//  Map
//
//  Created by Julian Ceipek on 6/15/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_URLManipulation)

-(NSString*)urlEncodeString;
-(NSString*)urlDecodeString;
-(NSString*)addQueryStringToUrlStringWithDictionary:(NSDictionary *)dictionary;

@end
