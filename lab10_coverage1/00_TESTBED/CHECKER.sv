integer test1, test2, test3, test4;
initial begin
	test1 = 0;
	test2 = 0;
	test3 = 0;
	test4 = 0;
	forever @(posedge clk) begin
		if ( coverage_1.get_coverage() == 100  && test1 == 0 ) begin
			test1 = test1 + 1;
			$display( "\033[32m--- Coverage 1 pass ---\033[0m" );
		end

		if ( coverage_2.get_coverage() == 100  && test2 == 0 ) begin
			test2 = test2 + 1;
			$display( "\033[32m--- Coverage 2 pass ---\033[0m" );
		end

		if ( coverage_3.get_coverage() == 100  && test3 == 0 ) begin
			test3 = test3 + 1;
			$display( "\033[32m--- Coverage 3 pass ---\033[0m" );
		end

		if ( coverage_4.get_coverage() == 100  && test4 == 0 ) begin
			test4 = test4 + 1;
			$display( "\033[32m--- Coverage 4 pass ---\033[0m" );
		end
	end
end