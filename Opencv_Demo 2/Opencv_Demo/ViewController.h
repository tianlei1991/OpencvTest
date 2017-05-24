//
//  ViewController.h
//  Opencv_Demo
//
//  Created by dzr on 16/6/28.
//  Copyright © 2016年 jcj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/videoio/cap_ios.h>
//#import <opencv2/highgui/highgui.hpp>
//#import <opencv2/imgproc/imgproc.hpp>
//#import <opencv2/core/core.hpp>
//#import <opencv2/objdetect/objdetect.hpp>

using namespace cv;
using namespace std;

@interface ViewController : UIViewController<CvVideoCameraDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property CvVideoCamera *videoCamera;

@end

