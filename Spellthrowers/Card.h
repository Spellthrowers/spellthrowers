//
//  Card.h
//  Spellthrowers
//
//  Created by Wesley Olson on 9/9/14.
//  Copyright (c) 2014 Spellthrowers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

//specify "weak" for object components that can be null
//specify (nonatomic) for objects that are thread-safe. Improves code speed.
@property int value;
@property NSString *cardType;
@property BOOL isFaceDownType;
@property NSString *name;


@end
