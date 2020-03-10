# FPGA-based-image-processing
## Feature
* Verilog实现Uart串口传输协议，可将图片从电脑串口发送至FPGA 
* 在Nexys4开发板上用Verilog流水线结构对图像进行灰度化、高斯模糊降噪、Sobel边缘检测、腐蚀、膨胀
* 可通过Nexy4板上的开关将各步骤中间结果输出到VGA显示屏上
* 
## Result
### Origin picture
![origin](fig/result_origin.jpg)

### Gray
![gray](fig/result_gray.jpg)

### Sobel Edge Detect
![edge](fig/result_edge_detect.jpg)

### Erosion
![erosion](fig/result_erosion.jpg)

### Dilate
![dilate](fig/result_dilate.jpg)

## Environment
* FPGA: Nexys 4
* Vivado 2016.4
* Verilog
* Modelsim