LIBRARY ieee;
USE ieee.std_logic_1164.all;

--LIBRARY work;
use work.lpm_components.all;
use work.lpm_shiftreg16;
use work.lpm_mux16;

ENTITY SRL16E IS
	generic(INIT : bit_vector := x"0000");
	port
	(
	CE :  IN STD_LOGIC;
--	A :   IN  STD_LOGIC_VECTOR(3 downto 0);
	A0 : IN STD_LOGIC;
	A1 : IN STD_LOGIC;
	A2 : IN STD_LOGIC;
	A3 : IN STD_LOGIC;
   CLK : IN STD_LOGIC;
   D :   IN STD_LOGIC;
   Q :   OUT STD_LOGIC
	);

END SRL16E;
	
ARCHITECTURE arch OF SRL16E IS

   SIGNAL adr_sig	: STD_LOGIC_VECTOR (3 DOWNTO 0);


-- component lpm_shiftreg16 
--    PORT 
--    ( 
--       clock : IN STD_LOGIC; 
--       shiftin : IN STD_LOGIC;
--       enable : IN STD_LOGIC;
--       q  : OUT STD_LOGIC_VECTOR(15 downto 0) 
--    ); 
-- end component; 
-- 
-- 	component lpm_mux16to1 
-- 	PORT 
-- 	( 
-- 		data15 : IN STD_LOGIC; 
-- 		data14 : IN STD_LOGIC; 
-- 		data13 : IN STD_LOGIC; 
-- 		data12 : IN STD_LOGIC; 
-- 		data11 : IN STD_LOGIC; 
-- 		data10 : IN STD_LOGIC; 
-- 		data9 : IN STD_LOGIC; 
-- 		data8 : IN STD_LOGIC; 
-- 		data7 : IN STD_LOGIC; 
-- 		data6 : IN STD_LOGIC; 
-- 		data5 : IN STD_LOGIC; 
-- 		data4 : IN STD_LOGIC; 
-- 		data3 : IN STD_LOGIC; 
-- 		data2 : IN STD_LOGIC; 
-- 		data1 : IN STD_LOGIC; 
-- 		data0 : IN STD_LOGIC; 
-- 		sel : IN STD_LOGIC_VECTOR(3 downto 0); 
-- 		result : OUT STD_LOGIC 
-- 	); 
-- end component; 
-- 
	
	signal shift_out : STD_LOGIC_VECTOR(15 downto 0); 
BEGIN 

--shiftreg_inst : shiftreg PORT MAP (
--		clock	 => CLK,
--		enable	 => CE,
--		shiftin	 => D,
--		q	 => Q
--	);

--mux16_inst : mux16 PORT MAP (
--		data0	 => data0_sig,
--		data1	 => data1_sig,
--		data10	 => data10_sig,
--		data11	 => data11_sig,
--		data12	 => data12_sig,
--		data13	 => data13_sig,
--		data14	 => data14_sig,
--		data15	 => data15_sig,
--		data2	 => data2_sig,
--		data3	 => data3_sig,
--		data4	 => data4_sig,
--		data5	 => data5_sig,
--		data6	 => data6_sig,
--		data7	 => data7_sig,
--		data8	 => data8_sig,
--		data9	 => data9_sig,
--		sel	 => sel_sig,
--		result	 => result_sig
--		result	 => result_sig
--	);
--	

		adr_sig(0)	<=		A0; 	
		adr_sig(1)	<=		A1; 	
		adr_sig(2)	<=		A2; 	
		adr_sig(3)	<=		A3; 	


   i1 : lpm_shiftreg16
   PORT MAP(clock => CLK, 
         shiftin => D, 
         enable => CE, 
         q => shift_out); 

   i2 : lpm_mux16 

   PORT MAP(data15 => shift_out(15), 
         data14 => shift_out(14), 
         data13 => shift_out(13), 
         data12 => shift_out(12), 
         data11 => shift_out(11), 
         data10 => shift_out(10), 
         data9 => shift_out(9), 
         data8 => shift_out(8), 
         data7 => shift_out(7), 
         data6 => shift_out(6), 
         data5 => shift_out(5), 
         data4 => shift_out(4), 
         data3 => shift_out(3), 
         data2 => shift_out(2), 
         data1 => shift_out(1), 
         data0 => shift_out(0), 
         sel => adr_sig, 
         result => Q); 

END;