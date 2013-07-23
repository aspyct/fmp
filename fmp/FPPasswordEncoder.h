//
//  FPPasswordEncoder.h
//  fmp
//
//  Created by Antoine d Otreppe on 23/07/13.
//  Copyright (c) 2013 Aspyct. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPPasswordEncoder : NSObject

- (NSString *)generateWithPassword:(NSString *)password host:(NSString *)host master:(NSString *)master;

@end
