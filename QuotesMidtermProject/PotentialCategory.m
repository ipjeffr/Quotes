//
//  PotentialCategory.m
//  QuotesMidtermProject
//
//  Created by Tenzin Phagdol on 2016-04-07.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import "PotentialCategory.h"

@implementation PotentialCategory

-(instancetype)initWithName: (NSString*)category {
    self = [super init];
    if (self) {
        _categoryName = category;
    } return self;
}

@end
