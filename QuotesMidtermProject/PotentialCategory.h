//
//  PotentialCategory.h
//  QuotesMidtermProject
//
//  Created by Tenzin Phagdol on 2016-04-07.
//  Copyright © 2016 Jeffrey Ip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PotentialCategory : NSObject

@property BOOL didSelectCategory;
@property NSString *categoryName;

-(instancetype)initWithName: (NSString*)category;

@end
