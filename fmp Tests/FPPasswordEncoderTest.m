//
//  FPPasswordEncoderTest.m
//  fmp
//
//  Created by Antoine d'Otreppe on 24/07/13.
//  Copyright (c) 2013 Aspyct. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "FPPasswordEncoder.h"

@interface FPPasswordEncoderTest : XCTestCase

@property FPPasswordEncoder *encoder;

@end

@implementation FPPasswordEncoderTest

- (void)setUp
{
    [super setUp];

    self.encoder = [[FPPasswordEncoder alloc] init];
}

- (void)testGenerationIsAlwaysTheSame
{
    NSArray *masters = @[@"master",
                         @"hello",
                         @"makesurethat",
                         @"yetanother",
                         @"masterpassword"];
    NSArray *hosts = @[@"host",
                       @"aspyct.org",
                       @"password",
                       @"host.com",
                       @"github.com"];
    NSArray *passwords = @[@"password",
                           @"world",
                           @"isalwaysthesame",
                           @"andpassword",
                           @"helloworld"];
    NSArray *expectedResults = @[@"hG#lJA5m%#ZJ=1X9",
                                 @"LSVDmT7Tin&5ERg9",
                                 @"Aoj%RCCkK@mhZXW%",
                                 @"SnbeE1(qBBW(@QbU",
                                 @"M2OG&EMgRdBgm1AQ"];
    
    NSString *master;
    NSString *host;
    NSString *password;
    NSString *expectedResult;
    NSString *result;
    
    for (int i = 0; i < masters.count; ++i) {
        master = masters[i];
        host = hosts[i];
        password = passwords[i];
        expectedResult = expectedResults[i];

        result = [self.encoder generateWithPassword:password host:host master:master];
        XCTAssertEqualObjects(result, expectedResult, @"Incorrect result for %@, %@, %@", master, host, password);
    }
}

@end
