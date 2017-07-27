//
//  PresentacionCollectionViewCell.h
//  Covisur
//
//  Created by Christian Fernandez on 9/02/17.
//  Copyright © 2017 Sainet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentacionCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView * imgPresentacion;

@property (nonatomic, weak) IBOutlet UILabel * lblDescription;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLabel;

@end
