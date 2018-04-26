`include "math_computer_macros.sv"

int MAX_RANDOM 	= 2**`DATASIZE-1;
int C_MAX_COND	= 999;

class input_class;
		rand bit [`DATASIZE-1 : 0] a;
		rand bit [`DATASIZE-1 : 0] b;
		rand bit [`DATASIZE-1 : 0] c;
endclass : input_class;

class const_input_class extends input_class;
    constraint a_dist {
			a dist {
					[0:9] :/ 1,
					[10 : MAX_RANDOM] :/ 1
			};
		}

		constraint abc {
			(a > b) -> c inside {[0:C_MAX_COND]};
		}

		constraint ab {
			((a[0] == 1'b1) || (b[0] == 1'b1));
		}
endclass : const_input_class;
