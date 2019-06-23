# FPGA-Language-Classifier-NN
A recurrent neural network which classifies the language of a given word (either English or Greek).  
Only the prediction function is implemented and learning is done priorly.  
Biases and weights can be found [here](https://github.com/kianelbo/FPGA-Language-Classifier-NN/blob/master/docs/Weights%20and%20Biases.txt).  

## Design Notes
For being fittable in FPGA, the design is partly sequential and partly parallel. Sequential modules are pipelined for better performance.

## Datapath
Cell architecture
<p align="center">
  <img src="https://github.com/kianelbo/FPGA-Language-Classifier-NN/blob/master/docs/lstm_cell.JPG?raw=true" width="80%" height="80%">
</p>

Network architecture
<p align="center">
  <img src="https://github.com/kianelbo/FPGA-Language-Classifier-NN/blob/master/docs/network.JPG?raw=true" width="80%" height="80%">
</p>

## Synthesis Notes
The design sources are written for simulation (using 'real' datatypes). However, synthesizable modules are available as well.  
The synthesizable modules are written using [CORDIC IP cores](https://www.xilinx.com/products/intellectual-property/cordic.html) and [Floating point IP cores](https://www.xilinx.com/products/intellectual-property/floating_pt.html)
