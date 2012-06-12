//
//  AuthHTTPConnection.m
//  Map
//
//  Created by Julian Ceipek on 6/11/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import "AuthHTTPConnection.h"

@implementation AuthHTTPConnection

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
	
	// Add support for POST
	
	if ([method isEqualToString:@"POST"])
	{
		/*if ([path isEqualToString:@"/post.html"])
		{
			// Let's be extra cautious, and make sure the upload isn't 5 gigs
			
			return requestContentLength < 50;
		}*/
	}
	
	return [super supportsMethod:method atPath:path];
}


@end
