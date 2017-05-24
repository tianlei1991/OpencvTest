//
//  ViewController.m
//  Opencv_Demo
//
//  Created by dzr on 16/6/28.
//  Copyright © 2016年 jcj. All rights reserved.
//参看以下链接查看具体配置 http://blog.csdn.net/liufanghuangdi/article/details/51769593
#import "ViewController.h"
#import <mach/mach_time.h>
@interface ViewController () {
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;//调用摄像头前置或者后置
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;//设置图像分辨率
    self.videoCamera.rotateVideo=YES;// 解决图像显示旋转90°问题
    
    self.videoCamera.grayscaleMode = NO;//获取图像是灰度还是彩色图像
    
    self.videoCamera.defaultFPS = 30;//摄像头频率
    [self.videoCamera start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)processImage:(cv::Mat &)image {
    cv::Mat resutl;
//    resutl = image;
    cv::medianBlur(image,resutl, 3);//中值滤波/百分比滤波器

    cv::Mat matGrey;
    cv::cvtColor(resutl,//复制对象
                 matGrey,//赋值体
                 CV_BGR2GRAY);// grey 改变颜色            cv::Mat edges;
    cv::Mat matBinary;
    IplImage grey = matGrey;
    int metpthreshold = otsu2(&grey);
    //进行操作
    int sthreshold = metpthreshold;
    cv::threshold(matGrey,//复制对象
                  matBinary,//复制体
                  sthreshold,//最小
                  255,//最大
                  cv::THRESH_BINARY);//这个不知道
    
    
    self.imageView.image = MatToUIImage(resutl);
    
    
 }
int otsu2 (IplImage *image)
{
    int w = image->width;
    int h = image->height;
    
    unsigned char*np; // 图像指针
    unsigned char pixel;
    int thresholdValue=1; // 阈值阈值
    int ihist[256]; // 图像直方图，256个点
    
    int i, j, k; // various counters
    int n, n1, n2, gmin, gmax;
    double m1, m2, sum, csum, fmax, sb;
    
    // 对直方图置零...
    memset(ihist, 0, sizeof(ihist));
    
    gmin=255; gmax=0;
    // 生成直方图
    for (i =0; i < h; i++)
    {
        np = (unsigned char*)(image->imageData + image->widthStep*i);
        for (j =0; j < w; j++)
        {
            pixel = np[j];
            ihist[ pixel]++;
            if(pixel > gmax) gmax= pixel;
            if(pixel < gmin) gmin= pixel;
        }
    }
    
    // set up everything
    sum = csum =0.0;
    n =0;
    
    for (k =0; k <=255; k++)
    {
        sum += k * ihist[k]; /* x*f(x) 质量矩*/
        n += ihist[k]; /* f(x) 质量 */
    }
    
    if (!n)
    {
        // if n has no value, there is problems...
        //fprintf (stderr, "NOT NORMAL thresholdValue = 160\n");
        thresholdValue =160;
        goto L;
    }
    
    // do the otsu global thresholding method
    fmax =-1.0;
    n1 =0;
    for (k =0; k <255; k++)
    {
        n1 += ihist[k];
        if (!n1) { continue; }
        n2 = n - n1;
        if (n2 ==0) { break; }
        csum += k *ihist[k];
        m1 = csum / n1;
        m2 = (sum - csum) / n2;
        sb = n1 * n2 *(m1 - m2) * (m1 - m2);
        /* bbg: note: can be optimized. */
        if (sb > fmax)
        {
            fmax = sb;
            thresholdValue = k;
        }
    }
    
L:
    for (i =0; i < h; i++)
    {
        np = (unsigned char*)(image->imageData + image->widthStep*i);
        for (j =0; j < w; j++)
        {
            if(np[j] >= thresholdValue)
                np[j] =255;
            else np[j] =0;
        }
    }
    
    //cout<<"The Threshold of this Image in Otsu is:"<<thresholdValue<<endl;
    return(thresholdValue);
}

@end


