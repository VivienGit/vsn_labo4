/******************************************************************************
Project Math_computer

File : math_computer_tb.sv
Description : This module implements a test bench for a simple
              mathematic calculator.
              Currently it is far from being efficient nor useful.

Author : Y. Thoma
Team   : REDS institute

Date   : 13.04.2017

| Modifications |--------------------------------------------------------------
Ver    Date         Who    Description
1.0    13.04.2017   YTA    First version

******************************************************************************/

`include "math_computer_macros.sv"
`include "math_computer_itf.sv"
`include "class.sv"

module math_computer_tb#(integer testcase = 0,
                         integer errno = 0);

    // Déclaration et instanciation des deux interfaces
    math_computer_input_itf input_itf();
    math_computer_output_itf output_itf();

    // Seulement deux signaux
    logic      clk = 0;
    logic      rst;

		int MAX_RANDOM = 2**`DATASIZE-1;

		input_class my_inputs;
		const_input_class my_inputs_const;

    // instanciation du compteur
    math_computer dut(clk, rst, input_itf, output_itf);

    // génération de l'horloge
    always #5 clk = ~clk;

    // clocking block
    default clocking cb @(posedge clk);
        output #3ns rst,
               a            = input_itf.a,
               b            = input_itf.b,
               c            = input_itf.c,
               input_valid  = input_itf.valid,
               output_ready = output_itf.ready;
        input  input_ready  = input_itf.ready,
               result       = output_itf.result,
               output_valid = output_itf.valid;
    endclocking

		covergroup cov_input;
			cov_a						: coverpoint input_itf.a{
					bins petits = {[0:2]};
					ignore_bins autre = {[3:MAX_RANDOM]};
			}
			cov_b						: coverpoint input_itf.b{
					bins petits = {[0:2]};
					ignore_bins autre = {[3:MAX_RANDOM]};
			}
			cov_c 					: coverpoint input_itf.c{
					bins petits = {[0:2]};
					ignore_bins autre = {[3:MAX_RANDOM]};
			}
//			cov_cross 			: cross input_itf.b, input_itf.a;
//			cov_input_valid	: coverpoint input_itf.valid;
//			cov_output_ready: coverpoint output_itf.ready;
		endgroup

		covergroup cov_output;
//			cov_input_rady	: coverpoint input_itf.ready;
			cov_result			: coverpoint output_itf.result;
//			cov_output_valid: coverpoint output_itf.valid;
		endgroup

		cov_input cg_input = new;
		cov_output cg_output = new;

		task wait_for_coverage();
			do
				@(posedge clk);
			while (cg_input.get_inst_coverage() < 100);
			$display("Time to stop !!");
		endtask

    task test_case0();
        $display("Let's start the first test case");
        cb.a <= 0;
        cb.b <= 0;
        cb.c <= 0;
        cb.input_valid  <= 0;
        cb.output_ready <= 0;

        ##1;
        // Le reset est appliqué 5 fois d'affilée
        repeat (5) begin
            cb.rst <= 1;
            ##1 cb.rst <= 0;
            ##10;
        end

				repeat (10) begin
						cb.input_valid <= 1;
						cb.a <= 1;
						##1;
						##($urandom_range(100));
						cb.output_ready <= 1;

        end
    endtask

		// Exercice 1
		task test_case1();
				$display("Let's start the second test case");
				cb.a <= 0;
				cb.b <= 0;
				cb.c <= 0;
				cb.input_valid  <= 0;
				cb.output_ready <= 0;

				##1;
				// Le reset est appliqué 5 fois d'affilée
				repeat (5) begin
						cb.rst <= 1;
						##1 cb.rst <= 0;
						##10;
				end


				repeat (10) begin
						cb.output_ready <= 1;
						##2;
						cb.output_ready <= 0;
						##5;
	          cb.a <= $urandom_range(MAX_RANDOM);
						cb.b <= $urandom_range(MAX_RANDOM);
						if (cb.input_ready == 1)
								cb.input_valid <= 1;
						else
							$display("Computer is not ready");
						##10;
						cb.input_valid <= 0;
	          ##($urandom_range(80, 10));
				end
		endtask

		// Exercice 2
		task test_case2();
				$display("Let's start the third test case");
				cb.a <= 0;
				cb.b <= 0;
				cb.c <= 0;
				cb.input_valid  <= 0;
				cb.output_ready <= 0;

				##1;
				// Le reset est appliqué 5 fois d'affilée
				repeat (5) begin
						cb.rst <= 1;
						##1 cb.rst <= 0;
						##10;
				end

				my_inputs = new();

				repeat (10) begin
						cb.output_ready <= 1;
						##2;
						cb.output_ready <= 0;
						##5;
						if (!my_inputs.randomize()) $stop;
						cb.a <= my_inputs.a;
						cb.b <= my_inputs.b;
						cb.b <= my_inputs.c;
						if (cb.input_ready == 1)
								cb.input_valid <= 1;
						else
							$display("Computer is not ready");
						##10;
						cb.input_valid <= 0;
						##($urandom_range(80, 10));
					end
		endtask

		// Exercice 2
		task test_case3();
				$display("Let's start the fourth test case");
				cb.a <= 0;
				cb.b <= 0;
				cb.c <= 0;
				cb.input_valid  <= 0;
				cb.output_ready <= 0;

				##1;
				// Le reset est appliqué 5 fois d'affilée
				repeat (5) begin
						cb.rst <= 1;
						##1 cb.rst <= 0;
						##10;
				end

				my_inputs_const = new();

				repeat (10) begin
						cb.output_ready <= 1;
						##2;
						cb.output_ready <= 0;
						##5;
						if (!my_inputs_const.randomize()) $stop;
						cb.a <= my_inputs_const.a;
						cb.b <= my_inputs_const.b;
						cb.b <= my_inputs_const.c;
						if (cb.input_ready == 1)
								cb.input_valid <= 1;
						else
							$display("Computer is not ready");
						##10;
						cb.input_valid <= 0;
						##($urandom_range(80, 10));
				end
		endtask

		// Exercice 3
		task test_case4();
				$display("Let's start the fifth test case");
				cb.a <= 0;
				cb.b <= 0;
				cb.c <= 0;
				cb.input_valid  <= 0;
				cb.output_ready <= 0;

				##1;
				// Le reset est appliqué 5 fois d'affilée
				repeat (5) begin
						cb.rst <= 1;
						##1 cb.rst <= 0;
						##10;
				end

				my_inputs = new();

				forever begin
						cb.output_ready <= 1;
						##2;
						cb.output_ready <= 0;
						##5;
						if (!my_inputs.randomize()) $stop;
						cb.a <= my_inputs.a;
						cb.b <= my_inputs.b;
						cb.b <= my_inputs.c;
						if (cb.input_ready == 1)
								cb.input_valid <= 1;
						else
							$display("Computer is not ready");
						##10;
						cb.input_valid <= 0;
						##($urandom_range(80, 10));
						cg_input.sample();
						cg_output.sample();
				end
		endtask

    // Programme lancé au démarrage de la simulation
    program TestSuite;
        initial begin
            if (testcase == 0)
                test_case0();
						else if (testcase == 1)
								test_case1();
						else if (testcase == 2)
								test_case2();
						else if (testcase == 3)
								test_case3();
						else if (testcase == 4)
							begin
								fork
									wait_for_coverage();
									test_case4();
								join_any
								disable fork;
							end
            else
                $display("Ach, test case not yet implemented");
            $display("done!");
						$display("Coverage from input : %f", cg_input.get_inst_coverage());
						$display("Coverage from input a : %f", cg_input.cov_a.get_inst_coverage());
						$display("Coverage from output : %f", cg_output.get_inst_coverage());
            $stop;
        end
    endprogram

endmodule
