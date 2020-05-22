use work.bv_arithmetic.all;
use work.dlx_types.all; 

entity mux_3 is
	generic(prop_delay : Time := 5 ns);
	port (input_2: in dlx_word; input_1: in dlx_word; input_0: in dlx_word; which: in threeway_muxcode; output: out dlx_word);
end entity mux_3;

architecture behavior03 of mux_3 is
begin
	mux_3: process(input_0, input_1, input_2, which)
	begin
		if (which(1) = '1') then
			output <= input_2 after prop_delay;
		elsif (which(0) = '1') then
			output <= input_1 after prop_delay;
		else 
			output <= input_0 after prop_delay;
		end if;
	end process mux_3;
end architecture behavior03;