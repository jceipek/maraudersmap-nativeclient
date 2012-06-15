//
//  AuthHTTPConnection.m
//  Map
//
//  Created by Julian Ceipek on 6/11/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import "AuthHTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPRedirectResponse.h"

@implementation AuthHTTPConnection

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
    
	// Add support for POST
	
	if ([method isEqualToString:@"POST"])
	{
        NSLog(@"AUTHPATH: %@", path);
        NSLog(@"requestContentLength: %llu", requestContentLength);
        //NSLog(@"request: %@", request);
        //NSLog(@"REQUEST URL: %@", [[NSString alloc] initWithContentsOfURL:[request url] encoding:NSUTF8StringEncoding error:nil]);
        //NSLog(@"REQUEST MESSAGE DATA: %@", [[NSString alloc] initWithData:[request messageData] encoding:NSUTF8StringEncoding]);
        //NSLog(@"Params: %@", [self parseGetParams]);
        //NSLog(@"REQUEST MESSAGE BODY: %@", [[NSString alloc] initWithData:[request body] encoding:NSUTF8StringEncoding]);
        
        NSString *postStr = nil;
        NSData *postData = [request body];
		if (postData)
		{
			postStr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
		}
        
        
		/*if ([path isEqualToString:@"/post.html"])
		{
			// Let's be extra cautious, and make sure the upload isn't 5 gigs
			
			return requestContentLength < 50;
		}*/
        return YES;
	}
	
	return [super supportsMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{

	
	if ([method isEqualToString:@"POST"])
	{

		
		NSString *postStr = nil;
		
		NSData *postData = [request body];
		if (postData)
		{
			postStr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            NSLog(@"THE POST STRING: %@", postStr);
		}
		
        //self.send_response(303)
		//self.send_header('Location', Settings.WEB_ADDRESS)
		//self.end_headers()
		//self.wfile.write('User authenticated. Redirecting to the map.')
		
		return [[HTTPRedirectResponse alloc] initWithPath:@"http://map.fwol.in/ui/index.html"];
	}
	
	return [super httpResponseForMethod:method URI:path];
}



@end
