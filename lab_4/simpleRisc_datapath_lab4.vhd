-- simpleRisc_datapath_lab4.vhd



-- entity reg_file (correct for simple Risc) 
use work.dlx_types.all; 
use work.bv_arithmetic.all;  

entity reg_file is
     port (data_in: in dlx_word; readnotwrite,clock : in bit; 
	   data_out: out dlx_word; reg_number: in register_index );
end entity reg_file; 

-- end entity regfile
architecture behavior of reg_file is
	type reg_type is array (0 to 31) of dlx_word;
begin
	reg_file: process(readnotwrite, clock, data_in, reg_number) is
		variable registers : reg_type;
	begin
		if (clock = '1') then
			if (readnotwrite = '1') then
				data_out <= registers(bv_to_integer(reg_number));
			else
				registers(bv_to_integer(reg_number)) := data_in;
			end if;
		else
			--placeholder
		end if;
	end process reg_file;
end architecture behavior;

-- entity simple_alu (correct for simple risc, different from Aubie) 
use work.dlx_types.all; 
use work.bv_arithmetic.all; 

entity simple_alu is 
     generic(prop_delay : Time := 5 ns);
     port(operand1, operand2: in dlx_word; operation: in alu_operation_code; 
          result: out dlx_word; error: out error_code); 
end entity simple_alu; 

-- alu_operation_code values (simpleRisc)
-- 0000 unsigned add
-- 0001 unsigned sub
-- 0010 2's compl add
-- 0011 2's compl sub
-- 0100 2's compl mul
-- 0101 2's compl divide
-- 0110 logical and
-- 0111 bitwise and
-- 1001 bitwise or 
-- 1011 bitwise not (op1)
-- 1100 copy op1 to output
-- 1101 copy op2 to output
-- 1110 output all zero's
-- 1111 output all one's

-- error code values
-- 0000 = no error
-- 0001 = overflow (too big or too small) 
-- 0011 = divide by zero 

-- end entity simple_alu
architecture behavior of simple_alu is
begin
	simple_alu: process(operand1,operand2, operation) is

	variable ofbit: boolean;
	variable dzbit: boolean;
	variable tout: dlx_word:= x"00000000";
	variable logic1: bit;
	variable logic2: bit;
	variable logictrue: dlx_word := x"FFFFFFFF";
	variable logicfalse: dlx_word := x"00000000";
	
	begin
		error <= "0000"; --clear
 		if operation = "0000" then
			bv_addu(operand1, operand2, tout, ofbit);
			if ofbit then 
				error <= "0001";
			end if;
			result <= tout after prop_delay;
		
		
		elsif operation = "0001" then
			bv_subu(operand1, operand2, tout, ofbit);
			if ofbit then 
				error <= "0001";
			end if;
			result <= tout after prop_delay;
		

		elsif operation = "0010" then
			bv_add(operand1, operand2, tout, ofbit);
			if ofbit then 
				error <= "0001";
			end if;
			result <= tout after prop_delay;


		elsif operation = "0011" then
			bv_sub(operand1, operand2, tout, ofbit);
			if ofbit then
				error <= "0001";
			end if;
			result <= tout after prop_delay;


		elsif operation = "0100" then
			bv_mult(operand1, operand2, tout, ofbit);
			if ofbit then 
				error <= "0001";
			end if;
			result <= tout after prop_delay;
		

		elsif operation = "0101" then
			bv_div(operand1, operand2, tout, dzbit, ofbit);
			if dzbit then
				error <= "0010";
			elsif ofbit then
				error <= "0001";
			end if;
			result <= tout after prop_delay;
		

		elsif operation = "0111" then
			for i in 0 to 31 loop
				tout(i) := operand1(i) and operand2(i);
			end loop;
			result <= tout after prop_delay;
		

		

		elsif operation = "1001" then
			for i in 0 to 31 loop
				tout(i) := operand1(i) or operand2(i);
			end loop;
			result <= tout after prop_delay;
		
		
		elsif operation = "1011" then
			for i in 0 to 31 loop
				tout(i) := not operand1(i);
			end loop;
			result <= tout after prop_delay;
		
		
		elsif operation = "1100" then
			for i in 0 to 31 loop
				tout(i) := operand1(i);
			end loop;
			result <= tout after prop_delay;

		elsif operation = "1101" then
			for i in 0 to 31 loop
				tout(i) := not operand2(i);
			end loop;

			result <= tout after prop_delay;
		elsif operation = "1110" then
			result <= logicfalse after prop_delay;
		
		elsif operation = "1111" then
			result <= logictrue after prop_delay;
		end if;

	end process simple_alu; 
end architecture behavior;


-- entity dlx_register 
use work.dlx_types.all; 

entity dlx_register is
     generic(prop_delay : Time := 5 ns);
     port(in_val: in dlx_word; clock: in bit; out_val: out dlx_word);
end entity dlx_register;

-- end entity dlx_register
architecture behavior of dlx_register is
begin
	dlx_register: process(in_val, clock) is
	begin 
		if (clock = '1') then 
			out_val <= in_val after prop_delay;
		else
		--does anything go here ?
		end if;
	end process dlx_register;
end architecture behavior;
		
		

-- entity pcplusone (correct for simpleRisc)
use work.dlx_types.all;
use work.bv_arithmetic.all; 

entity pcplusone is
	generic(prop_delay: Time := 5 ns); 
	port (input: in dlx_word; clock: in bit;  output: out dlx_word); 
end entity pcplusone;

architecture behavior of pcplusone is
begin
	pcplusone: process(input, clock) is
	variable t : dlx_word;
	variable error : boolean;
	begin
		if (clock = '1' and clock'event) then
			bv_addu(input, x"00000001", t, error);
			output <= t after prop_delay;
		else
		--placeholder
		end if;
	end process pcplusone;
end architecture behavior; 




-- entity mux 
use work.dlx_types.all; 

entity mux is
     generic(prop_delay : Time := 5 ns);
     port (input_1,input_0 : in dlx_word; which: in bit; output: out dlx_word);
end entity mux;

-- end entity mux
architecture behavior of mux is
begin
	mux: process(input_0, input_1, which)
	begin
		if (which = '0') then
			output <= input_0 after prop_delay;
		else
			output <= input_1 after prop_delay;
		end if;
	end process mux;
end architecture behavior;



  
-- entity memory 
use work.dlx_types.all;
use work.bv_arithmetic.all;

entity memory is
  
  port (
    address : in dlx_word;
    readnotwrite: in bit; 
    data_out : out dlx_word;
    data_in: in dlx_word; 
    clock: in bit); 
end memory;

architecture behavior of memory is

begin  -- behavior

  mem_behav: process(address,clock) is
    -- note that there is storage only for the first 1k of the memory, to speed
    -- up the simulation
    type memtype is array (0 to 1024) of dlx_word;
    variable data_memory : memtype;
  begin
    -- fill this in by hand to put some values in there
    -- some instructions
   data_memory(0) :=  "00000000000000000000100000000000";   -- LD R1,R0(100)
   data_memory(1) :=  "00000000000000000000000100000000";
   data_memory(2) :=  "00000000000000000001000000000000";   -- LD R2,R0(101)
   data_memory(3) :=  "00000000000000000000000100000001";
   data_memory(4) :=  "00001000001000100001100100000000";   -- ADD R3,R1,R2
   data_memory(5) :=  "00000100011000000000000000000000";   -- STO R3,R0(102)
   data_memory(6) :=  "00000000000000000000000100000010";
   -- if the 3 instructions above run correctly for you, you get full credit for the assignment


   -- data for the first two loads to use 
    data_memory(256) := X"55550000"; 
    data_memory(257) := X"00005555";
    data_memory(258) := X"ffffffff";

    -- testing for extra credit 
    -- code to test JZ , should be taken unless value of R1 changed
    data_memory(7) := "00001100100000000000000000000000";         -- JMP R4(00000010)
    data_memory(8) := X"00000010";

    data_memory(16):=  "00010000100001010000000000000000";        -- JZ R5,R4(00000000)
    data_memory(17) := X"00000000";

   
    if clock = '1' then
      if readnotwrite = '1' then
        -- do a read
        data_out <= data_memory(bv_to_natural(address)) after 5 ns;
      else
        -- do a write
        data_memory(bv_to_natural(address)) := data_in; 
      end if;
    end if;


  end process mem_behav; 

end behavior;
-- end entity memory


