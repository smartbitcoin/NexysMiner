NexysMiner
==========

Litecoin FPGA Miner on  Nexys4 board.

please check the litecoin forum for the detail of this project.

https://litecointalk.org/index.php?topic=12597.0

basicly,  you need  vivado to do the synth and use  uart cable to write the bitstream into NEXYS4 board,  
after that,  you can run the mining software on it.



I leave the synth detail as a reference here.

Device utilization summary:
---------------------------

Selected Device : 7a100tcsg324-2 
Slice Logic Utilization: 
 Number of Slice Registers:           33925  out of  126800    26%  
 Number of Slice LUTs:                47875  out of  63400    75%  
    Number used as Logic:             43645  out of  63400    68%  
    Number used as Memory:             4230  out of  19000    22%  
       Number used as RAM:              112
       Number used as SRL:             4118
Slice Logic Distribution: 
 Number of LUT Flip Flop pairs used:  69375
   Number with an unused Flip Flop:   35450  out of  69375    51%  
   Number with an unused LUT:         21500  out of  69375    30%  
   Number of fully used LUT-FF pairs: 12425  out of  69375    17%  
   Number of unique control sets:        59
IO Utilization: 
 Number of IOs:                           8
 Number of bonded IOBs:                   7  out of    210     3%  
Specific Feature Utilization:
 Number of Block RAM/FIFO:              116  out of    135    85%  
    Number using Block RAM only:        116
 Number of BUFG/BUFGCTRLs:                5  out of     32    15%  
 Number of DSP48E1s:                    240  out of    240   100% 


