library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
-------------------------------------------------------------------------------
-- 32 bit Harvard Arch accumulator oriented processor ~520 slices: 
-- 1 clk/inst, only exception is conditional jumps:
-- 1 clock if not taken, 3 clocks if taken
-- ~80 MHz operation in Spartan3 ~50 MHz in Spartan2
-- 32 bit data, 24 bit instruction width
-- 64 JMP instructions: 
-- All Ored true, false, dont-care combinations of sign, zero and carry
-- 10 basic memory reference instructions:
-- OR, XOR, AND, ADD, ADDC, SUB, SUBB, LDA, STA, MUL, MULS
-- Multiply has pipelined mac option with aux 40 bit accumulator
-- 5 operate instructions, load immediate, rotate, mac clear and load bounded mac
-- LXWI, LLWI, LHWI, RCL, RCR, CLRMAC, LDMACB
-- 14 index load/store/increment: 
-- LDY, LDX, LDZ, LDT, STY, STX, STZ, STT, ADDIX, ADDIY, ADDIZ, ADDIT, RTT, TTR  
-- 4K words instruction space
-- 4K words data space
-- 4 index registers for indirect memory access
-- 12 bit offset for indirect addressing (ADD sinetable(6) etc)
-- 12 bit direct memory addressing range
-- 12 bit indirect addressing range with 12 bit offset range
-- 2 levels of subroutine call/return
-- Starts at address 0 from reset
-- THE BAD NEWS: pipelined processor with no locks so --->
-- Instruction hazards: 
--   TTR must precede JSR by at least 2 instructions
--   RTT must precede JSR by at least 2 instructions
--   TTR must precede JMP@R by at least 2 instructions
--   (option) No unconditional jumps in 2 instructions after a conditional jump 
-- Data hazards:
--   Stored data requires 3 instructions before fetch
--   MAC data needs one extra instruction time after last MUL before transfer to ACC
-- Address hazards:
--   Fetches via index register require 2 instructions from ST(X,Y,Z,T),ADDI(X,Y) 
--   to actual fetch (STA via index takes no extra delay) 
-------------------------------------------------------------------------------

entity Big32 is
	generic(
		width : integer := 32;			-- data width
		iwidth	: integer := 24;		-- instruction width
		maddwidth : integer := 12;	-- memory address width
		macwidth : integer := 40;	-- macwidth
		paddwidth : integer := 12	-- program counter width
       );
	port (
		clk      : in  std_logic;
		reset    : in  std_logic;
		iabus    : out std_logic_vector(paddwidth-1 downto 0);  	-- program address bus
		idbus    : in  std_logic_vector(iwidth-1 downto 0);  		-- program data bus       
		mradd    : out std_logic_vector(maddwidth-1  downto 0);  -- memory read address
		mwadd    : out std_logic_vector(maddwidth-1  downto 0);  -- memory write address
		mibus    : in  std_logic_vector(width-1 downto 0);  		-- memory data in bus     
		mobus    : out std_logic_vector(width-1 downto 0);  		-- memory data out bus
		mwrite   : out std_logic;           							-- memory write signal        
		mread		: out std_logic; 											-- memory read signal
		carryflg : out std_logic            							-- carry flag
		);
end Big32;


architecture Behavioral of Big32 is


-- basic op codes
-- Beware, certain bits are used to simpilfy decoding - dont change without knowing what you are doing...
  constant opr   : std_logic_vector (3 downto 0) := x"0";	-- operate
  constant free  : std_logic_vector (3 downto 0) := x"1";	-- unused 
  constant jmp   : std_logic_vector (3 downto 0) := x"2";	-- unconditional jump
  constant jmpc  : std_logic_vector (3 downto 0) := x"3";	-- conditional jump
  constant lda   : std_logic_vector (3 downto 0) := x"4";	-- load accumulator from memory
  constant lor   : std_logic_vector (3 downto 0) := x"5";	-- OR accumulator with memory	
  constant lxor  : std_logic_vector (3 downto 0) := x"6";	-- XOR accumulator with memory	
  constant land  : std_logic_vector (3 downto 0) := x"7";	-- AND accumulator with memory	
  constant idxo  : std_logic_vector (3 downto 0) := x"8";	-- IDX operate  
  constant mul   : std_logic_vector (3 downto 0) := x"9";	-- Multiply  
  constant muls  : std_logic_vector (3 downto 0) := x"A";	-- Signed Multiply  
  constant sta   : std_logic_vector (3 downto 0) := x"B";	-- store accumulator to memory
  constant add   : std_logic_vector (3 downto 0) := x"C";	-- add memory to accumulator
  constant addc  : std_logic_vector (3 downto 0) := x"D";	-- add memory and carry to accumulator
  constant sub   : std_logic_vector (3 downto 0) := x"E";	-- subtract memory from accumulator
  constant subc  : std_logic_vector (3 downto 0) := x"F";	-- subtract memory and carry from accumulator

-- operate instructions
  constant nop : std_logic_vector (3 downto 0) := x"0";

-- immediate load type
 
  constant lxwi : std_logic_vector (3 downto 0) := x"1";  
  constant llwi : std_logic_vector (3 downto 0) := x"2";  
  constant lhwi : std_logic_vector (3 downto 0) := x"3";  
  
-- accumulator operate type

  constant rotcl : std_logic_vector (3 downto 0) := x"4";
  constant rotcr : std_logic_vector (3 downto 0) := x"5";
  
  constant clrmac : std_logic_vector (3 downto 0) := x"8";
  constant ldmacb : std_logic_vector (3 downto 0) := x"9";
  constant ldmact : std_logic_vector (3 downto 0) := x"A";
  
-- index register load/store in address order
  constant ldx   : std_logic_vector (3 downto 0) := x"0";
  constant ldy   : std_logic_vector (3 downto 0) := x"1";
  constant ldz   : std_logic_vector (3 downto 0) := x"2";
  constant ldt   : std_logic_vector (3 downto 0) := x"3";
  constant stx   : std_logic_vector (3 downto 0) := x"4";
  constant sty   : std_logic_vector (3 downto 0) := x"5";
  constant stz   : std_logic_vector (3 downto 0) := x"6";
  constant stt   : std_logic_vector (3 downto 0) := x"7";
  constant addix : std_logic_vector (3 downto 0) := x"8";
  constant addiy : std_logic_vector (3 downto 0) := x"9";
  constant addiz : std_logic_vector (3 downto 0) := x"A";
  constant addit : std_logic_vector (3 downto 0) := x"B";
  
-- return register save/restore
  constant rtt   : std_logic_vector (3 downto 0) := x"C";
  constant ttr   : std_logic_vector (3 downto 0) := x"D";  
  constant ldrt   : std_logic_vector (3 downto 0) := x"E";
  constant strt   : std_logic_vector (3 downto 0) := x"F";  
-- basic signals

  signal accumcar  : std_logic_vector (width downto 0);  -- accumulator+carry
  alias accum      : std_logic_vector (width-1 downto 0) is accumcar(width-1 downto 0);
  alias carrybit   : std_logic is accumcar(width);
  alias signbit    : std_logic is accumcar(width-1);
  signal maskedcarry : std_logic;
  signal macc : std_logic_vector (macwidth-1 downto 0);  -- macccumulator
  alias mmsb : std_logic is macc(macwidth-1);
  alias mnmsbs : std_logic_vector(7 downto 0) is macc(macwidth-2 downto macwidth-8);
  signal macnext : std_logic;

  signal pc        : std_logic_vector (paddwidth -1 downto 0); -- program counter - 12 bits = 4k
  signal mra       : std_logic_vector (maddwidth -1 downto 0);  -- memory read address - 12 bits = 4k
  signal id1       : std_logic_vector (iwidth -1 downto 0);  -- instruction pipeline 1       
  signal id2       : std_logic_vector (iwidth -1 downto 0);  -- instruction pipeline 2           
  alias opcode0    : std_logic_vector (3 downto 0) is idbus (iwidth-1 downto iwidth-4);   -- main opcode at pipe0
  alias opcode2    : std_logic_vector (3 downto 0) is id2 (iwidth-1 downto iwidth-4);     -- main opcode at pipe2
  alias CarryMask2 : std_logic is id2 (iwidth-5);
  alias CarryXor2  : std_logic is id2 (iwidth-6); 
  alias ZeroMask2  : std_logic is id2 (iwidth-7);  
  alias ZeroXor2   : std_logic is id2 (iwidth-8); 
  alias SignMask2  : std_logic is id2 (iwidth-9);  
  alias SignXor2   : std_logic is id2 (iwidth-10);  
  alias OvflMask2  : std_logic is id2 (iwidth-11);  
  alias OvflXor2   : std_logic is id2 (iwidth-12);  
  signal jumpq     : std_logic;
  alias Arith		 : std_logic_vector (1 downto 0) is id2 (iwidth-1 downto iwidth-2);
  alias WithCarry  : std_logic is id2(iwidth-4);		-- indicates add with carry or subtract with borrow
  alias Minus      : std_logic is id2(iwidth-3);		-- indicates subtract
  alias opradd0    : std_logic_vector (maddwidth -1 downto 0) is idbus (maddwidth -1 downto 0);               -- operand address at pipe0
  alias opradd2    : std_logic_vector (maddwidth -1 downto 0) is id2 (maddwidth -1 downto 0);                 -- operand address at pipe2
  alias ind0       : std_logic is idbus(iwidth -5); 
  alias ind2       : std_logic is id2(iwidth -5); 
  alias domac      : std_logic is id2(iwidth -6); 
  alias ireg0      : std_logic_vector(1 downto 0) is idbus(iwidth -7 downto iwidth -8); 
  alias offset0    : std_logic_vector (maddwidth-1  downto 0) is idbus(maddwidth-1 downto 0);
  alias opropcode2 : std_logic_vector (3 downto 0) is id2 (iwidth-5 downto iwidth-8);    -- operate opcode at pipe2  alias iopr2      : std_logic_vector (7 downto 0) is id2 (7 downto 0);                 -- immediate operand at pipe2
  alias iopr2      : std_logic_vector (15 downto 0) is id2 (15 downto 0);                 -- immediate operand at pipe2
  signal oprr      : std_logic_vector (width -1 downto 0);                              -- operand register
  signal idx       : std_logic_vector (maddwidth -1 downto 0);
  signal idy       : std_logic_vector (maddwidth -1 downto 0);
  signal idz       : std_logic_vector (maddwidth -1 downto 0);
  signal idt       : std_logic_vector (maddwidth -1 downto 0);

  signal idn0		 : std_logic_vector (maddwidth -1 downto 0);
  signal idr       : std_logic_vector (paddwidth -1 downto 0);
  signal idrt		 : std_logic_vector (paddwidth -1 downto 0);
  signal nextpc    : std_logic_vector (paddwidth -1 downto 0);
  signal pcplus1   : std_logic_vector (paddwidth -1 downto 0);
  signal acczero   : std_logic;
  signal maddpipe1 : std_logic_vector (maddwidth -1 downto 0);
  signal maddpipe2 : std_logic_vector (maddwidth -1 downto 0);
  signal maddpipe3 : std_logic_vector (maddwidth -1 downto 0);
  
  function rotcleft(v : std_logic_vector ) return std_logic_vector is
    variable result   : std_logic_vector(width downto 0);
  begin
    result(width downto 1) := v(width-1 downto 0);
    result(0)              := v(width);
    return result;
  end rotcleft;

  function rotcright(v : std_logic_vector ) return std_logic_vector is
    variable result    : std_logic_vector(width downto 0);
  begin
    result(width -1 downto 0) := v(width downto 1);
    result(width)             := v(0);
    return result;
  end rotcright;

  function signextendword(v : std_logic_vector ) return std_logic_vector is
    variable result         : std_logic_vector(width -1 downto 0);
  begin
    if v(15) = '1' then
      result(width-1 downto 16) := x"FFFF";
    else
      result(width-1 downto 16) := x"0000";
    end if;
    result(15 downto 0)         := v(15 downto 0);
    return result;
  end signextendword;
   
begin  -- the CPU


  nextpcproc : process (clk, reset, pc, acczero, nextpc, id2,
                        ind0, ind2,idr, idbus, opcode0,
                        opcode2, carrybit, accumcar)  -- next pc calculation - jump decode
  begin
	 pcplus1 <= pc + '1';    
	 iabus <= nextpc;  							-- program memory address from combinatorial    
    jumpq <= (((SignBit xor SignXor2) and SignMask2) or
				 ((CarryBit xor CarryXor2) and CarryMask2) or
				 ((acczero xor ZeroXor2) and ZeroMask2)); 
	 
	 if reset = '1' then                   -- nextpc since blockram has built in addr register
      nextpc <= (others => '0');
    else
      if (opcode0 = jmp) then
        if ind0 = '1' then              	-- indirect (computed jump or return)
          nextpc <= idr;
        else                            	-- direct
          nextpc <= idbus(paddwidth -1 downto 0);
        end if;
      elsif (opcode2 = jmpc) and (jumpq = '1') then	-- direct only
        nextpc <= id2(paddwidth -1 downto 0);
      else
        nextpc <= pcplus1;
      end if;  -- opcode = jmp
    end if;  -- no reset

   if clk'event and clk = '1' then
		pc <= nextpc;
		id1  <= idbus;   									--	instruction pipeline
      id2  <= id1;     
		if reset = '1' or ((opcode2 = jmpc) and (jumpq = '1')) then
--		if reset = '1'  then
        id1  <= (others => '0');                -- on reset or taken conditional jump
		  id2  <= (others => '0');						-- fill inst pipeline with two 0s (nop)
      end if;
   end if;
	
  end process nextpcproc;

  mraproc : process (idbus, idx, idy, idz, idt, mra, ind0,
                     ireg0,
                     offset0, opcode0, opradd0, clk)  -- memory read address generation
  begin
    mradd <= mra;
    -- idx reg mux
	 case ireg0 is
		when "00" => idn0 <= idx;
      when "01" => idn0 <= idy;
		when "10" => idn0 <= idz;
      when "11" => idn0 <= idt;
		when others => null;
     end case;
	 -- direct/ind mux 
	 if ((opcode0 /= opr) and (opcode0 /= idx) and (ind0 = '0')) then
		mra <= opradd0;
	 else
		mra <= idn0 + offset0;
	 end if;

	if clk'event and clk = '1' then
		if (opcode0 = lda) or (opcode0 = lor) or (opcode0 = lxor) or (opcode0 = land) or (opcode0 = mul)
		or (opcode0 = add) or (opcode0 = addc) or (opcode0 = sub) or (opcode0 = subc) then
			mread <= '1';
		else
			mread <= '0';
		end if;		
		maddpipe3 <= maddpipe2;
		maddpipe2 <= maddpipe1;
		maddpipe1 <= mra;
	end if;
	 	 
  end process mraproc;

	mwaproc : process (maddpipe3)          -- memory write address generation
	begin
		mwadd     <= maddpipe3;
	end process mwaproc;

  oprrproc : process (clk)  			-- memory operand register  -- could remove to
  begin  									-- reduce pipelining depth but would impact I/O read
    if clk'event and clk = '1' then	-- access time  --> not good for larger systems
      oprr <= mibus;
    end if;
  end process oprrproc;

  accumproc : process (clk, accumcar, accum, id2)  -- accumulator instruction decode - operate
  begin
    carryflg <= carrybit;
    if accum = x"00000000" then
      acczero <= '1';
    else
      acczero <= '0';
	end if;
	maskedcarry <= carrybit and WithCarry;
	
   if clk'event and clk = '1' then
		case opcode2 is 																-- memory reference first
			when land         	=> accum    <= accum and oprr;
  	    	when lor         	 	=> accum    <= accum or oprr;
      	when lxor         	=> accum    <= accum xor oprr;
      	when lda          	=> accum    <= oprr;
			when mul					=> accum    <= accum(31 downto 16) * oprr(15 downto 0);
											if domac = '1' then 
												macnext <= '1';
											else
												macnext <= '0';
											end if;			
			when muls				=> accum		<= signed(accum(31 downto 16)) * signed(oprr(15 downto 0));
											if domac = '1' then 
												macnext <= '1';
											else
												macnext <= '0';
											end if;			
			when opr					=>  												-- then operate
        		case opropcode2 is
					when lxwi      => accum <= signextendword(iopr2);		-- load sign extended word immediate
					when llwi      => accum(15 downto 0)  <= iopr2;			-- load low word immediate
					when lhwi      => accum(31 downto 16) <= iopr2;			-- load high word immediate
          		when rotcl     => accumcar <= rotcleft(accumcar);		-- rotate left through carry
          		when rotcr     => accumcar <= rotcright(accumcar); 	-- rotate right through carry
					when clrmac		=> macc <= (others => '0');				-- clear the macc
					when ldmacb		=>
										if mmsb = '0' then							-- positive case
											if mnmsbs = 0 then
												accum <= macc(31 downto 0);		-- no overflow
											else
												accum <= x"7FFFFFFF";				-- if overflow bound to max positive
											end if;
										else												-- negative case
											if mnmsbs = "1111111" then
												accum <= macc(31 downto 0);		-- no overflow
											else
												accum <= x"80000000";				-- if overflow bound to max negative
											end if;
										end if;	
          		when others    => null;
				end case;
			when idxo				=> 												-- then index register	operate
        		case opropcode2 is
         		when ldx       => accum(maddwidth-1 downto 0) <= idx;
         		when ldy       => accum(maddwidth-1 downto 0) <= idy;
         		when ldz       => accum(maddwidth-1 downto 0) <= idz;
         		when ldt       => accum(maddwidth-1 downto 0) <= idt;
					
          		when stx       => idx <= accum(maddwidth-1 downto 0);
          		when sty       => idy <= accum(maddwidth-1 downto 0);
          		when stz       => idz <= accum(maddwidth-1 downto 0);
          		when stt       => idt <= accum(maddwidth-1 downto 0);

					when addix		=> idx <= maddpipe2;							-- re-use the offset adder
					when addiy     => idy <= maddpipe2;							-- for add immediate to index
					when addiz		=> idz <= maddpipe2;
					when addit     => idt <= maddpipe2;

					when rtt	      => idrt <= idr;
					when ttr       => idr <= idrt;
					when ldrt		=> accum(maddwidth-1 downto 0) <= idr;
         		when strt      => idr <= accum(maddwidth-1 downto 0);
					
          		when others    => null;
				end case;
			when others       => null;
		end case;
      
      if Arith = "11" then
			if Minus = '0' then
				accumcar <= '0'&accum + oprr + maskedcarry; -- add/addc
			else
				accumcar <= '0'&accum - oprr - maskedcarry; -- sub/subc
			end if;
		end if;	
   	if (opcode0 = jmp) and ind0 = '1' then 			-- save return address -- note priority over ttr!     
      	idr  <= pcplus1;  
   	end if;   
		
		if macnext = '1' then
			macc <= macc + accum;
		end if;	
		
	end if;  -- clk
end process accumproc;

  staproc : process (clk, accumcar)  -- sta decode  -- not much to do but enable mwrite
  begin
    mobus <= accum;
    if clk'event and clk = '1' then
      if opcode2 = sta then
        mwrite <= '1';
      else
        mwrite <= '0';
      end if;
    end if;
  end process staproc;

end Behavioral;
