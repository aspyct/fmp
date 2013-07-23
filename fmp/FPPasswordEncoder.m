//
//  FPPasswordEncoder.m
//  fmp
//
//  Created by Antoine d Otreppe on 23/07/13.
//  Copyright (c) 2013 Aspyct. All rights reserved.
//

#import "FPPasswordEncoder.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation FPPasswordEncoder

- (NSString *)generateWithPassword:(NSString *)password host:(NSString *)host master:(NSString *)master {
    NSData *passHash = [self sha256HashFor:password];
    NSData *hostHash = [self sha256HashFor:host];
    NSData *masterHash = [self sha256HashFor:master];
    
    NSMutableData *mdata = [[NSMutableData alloc] initWithData:passHash];
    [mdata appendData:hostHash];
    [mdata appendData:masterHash];
    
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(mdata.bytes, mdata.length, result);
    
    NSData *resultData = [NSData dataWithBytes:result length:CC_SHA256_DIGEST_LENGTH];
    return [[self base64EncodedString:resultData] substringToIndex:16];
}

- (NSData *)sha256HashFor:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    return [NSData dataWithBytes:result length:CC_SHA256_DIGEST_LENGTH];
}

//  The next functions have originally been developed by:
//
//  Created by Nick Lockwood on 12/01/2012.
//  Copyright (C) 2012 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/Base64
//
//  Modified by Antoine d'Otreppe / aspyct.org in 2013 to include special
//  chars in the hash.

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth andData:(NSData *)data
{
    //ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth / 4) * 4;
    
    const char lookup[] = "AB4C&D1EFG~HIJK=2LMN#OP5Q'R9S$TU3VW*8XYZ0a-bc6de%fgh@ijk7lmno(pqr)stuvwxyz";
    
    long long inputLength = [data length];
    const unsigned char *inputBytes = [data bytes];
    
    long long maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth? (maxOutputLength / wrapWidth) * 2: 0;
    unsigned char *outputBytes = (unsigned char *)malloc(maxOutputLength);
    
    long long i;
    long long outputLength = 0;
    for (i = 0; i < inputLength - 2; i += 3)
    {
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];
        
        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
        {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] =   '=';
    }
    else if (i == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    if (outputLength >= 4)
    {
        //truncate data to match actual output length
        outputBytes = realloc(outputBytes, outputLength);
        return [[NSString alloc] initWithBytesNoCopy:outputBytes
                                              length:outputLength
                                            encoding:NSASCIIStringEncoding
                                        freeWhenDone:YES];
    }
    else if (outputBytes)
    {
        free(outputBytes);
    }
    return nil;
}

- (NSString *)base64EncodedString:(NSData *)data
{
    return [self base64EncodedStringWithWrapWidth:0 andData:data];
}

@end
