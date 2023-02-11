1. All the files have been sorted. Please put those files into corresponding dictory.
2. Set 3 types of latency in "pseudo_DRAM.sv" equal to "1"
3. The file with "_assertion_X" suffix means that it violates Xth assertion.
4. The file with "_wrong" suffix means that it is the wrong design.
5. There will be some errors after encrypting CHECKER. So we cannot provide you  this file.
   However, there's still some code written in the provided CHECKER.sv that needs to be added into your CHECKER.sv

========================================

Coverage: (TA’s correct DESIGN + TA’s CHECKER + Your PATTERN)
1. Use your own dram.dat
2. run "./02_run_conv". There should be Coverage 1~4 Pass shown on the terminal.
3. Replace TA’s correct DESIGN with wrong design. Your PATTERN should show "Wrong Answer" on the terminal.

wrong_1 : 
	Wrong out_info when action = CANCEL DELIVER ORDER

wrong_2 : 
	1. Wrong ser_FOOD1、2、3 when action = TAKE
	2. Wrong ser_FOOD1、2、3 when action = ORDER
	3. Wrong ctm_info when action = CANCEL

========================================

Assertion: (TA’s DESIGN + TA’s PATTERN+ Your CHECKER)
1. Use TA's dram.dat
2. Replace the original file with the one has "_assertion_X" suffix, and then run "./01_run". 
   Your CHECKER should show "Assertion X is violated" on the terminal.

