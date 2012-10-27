//
//  AuthHTTPConnection.m
//  Map
//
//  Created by Julian Ceipek on 6/11/12.
//  Copyright (c) 2012 ohack. All rights reserved.
//

#import "AuthHTTPConnection.h"

#import "NSString+NSString_URLManipulation.h"

@implementation AuthHTTPConnection

/*
- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
	// Add support for POST    
    if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/"]) {
        
        NSLog(@"requestContentLength: %llu", requestContentLength);
        // Make sure the request isn't too big!
        if (requestContentLength < 3000) {
            return TRUE;
        } else {
            NSLog(@"Request is too big!");
            return FALSE;
        }

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
            NSString *decodedPostStr = [[NSString alloc] initWithString:[postStr urlDecodeString]];
            
            NSLog(@"THE POST STRING: %@", postStr);
            NSLog(@"URL DECODED POST STRING: %@", decodedPostStr);
            
            NSDictionary *theParams = [self parseParams: decodedPostStr];
            
            NSError *error;
            NSString *errorDesc;
            NSURL *rootUrl = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                                    inDomain:NSUserDomainMask
                                                           appropriateForURL:nil
                                                                      create:YES
                                                                       error: &error];
            if (error != nil) {
                NSLog(@"Error getting 'Application Support' directory: %@", [error description]);
            }
            
            NSURL *maraudersMapUrl = [rootUrl URLByAppendingPathComponent:@"MaraudersMap"];
            
            [[NSFileManager defaultManager] createDirectoryAtURL:maraudersMapUrl
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error != nil) {
                NSLog(@"Error creating 'MaraudersMap' directory: %@", error);
            }
            
            NSURL *plistPath = [maraudersMapUrl URLByAppendingPathComponent: @"Secret.plist"];
            NSDictionary *plistDict = [NSDictionary dictionaryWithObject: theParams
                                                                  forKey: @"BrowserID"];
            NSData *plistData = [NSPropertyListSerialization dataFromPropertyList: plistDict
                                                                           format: NSPropertyListXMLFormat_v1_0
                                                                 errorDescription: &errorDesc];
            if(plistData) {
                if ([plistData writeToURL:plistPath atomically:YES]) {
                    NSLog(@"Wrote secrets to file: %@", plistPath);
                } else {
                    NSLog(@"Error writing to secrets file: %@", plistPath);
                }
            }
            else {
                NSLog(@"Error serializing plistDict: %@", errorDesc);
            }
        }

        return [[HTTPRedirectResponse alloc] initWithPath:@"http://map.fwol.in/ui/index.html"];
    }
    
    return [super httpResponseForMethod:method URI:path];
}

- (void)processBodyData:(NSData *)postDataChunk
{	
	// Remember: In order to support LARGE POST uploads, the data is read in chunks.
	// This prevents a 50 MB upload from being stored in RAM.
	// The size of the chunks are limited by the POST_CHUNKSIZE definition.
	// Therefore, this method may be called multiple times for the same POST request.
	
	BOOL result = [request appendData:postDataChunk];
	if (!result)
	{
		NSLog(@"Unable to append data to request!");
	}
}
*/
@end
