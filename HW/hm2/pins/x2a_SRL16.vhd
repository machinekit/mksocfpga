LIBRARY ieee;
USE ieee.std_logic_1164.all;

--LIBRARY work;
use work.lpm_components.all;
use work.Shiftreg16;
use work.Mux16x1;

ENTITY x2aSRL16 IS
	port
	(
--		A : IN STD_LOGIC_VECTOR(3 downto 0);
		CE : IN STD_LOGIC;
		A0 : IN STD_LOGIC;
		A1 : IN STD_LOGIC;
		A2 : IN STD_LOGIC;
		A3 : IN STD_LOGIC;
		CLK : IN STD_LOGIC;
		D : IN STD_LOGIC;
		Q : OUT STD_LOGIC
	);
	END x2aSRL16;
	
ARCHITECTURE arch OF x2aSRL16 IS

	SIGNAL q_sig	: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL adr_sig	: STD_LOGIC_VECTOR (3 DOWNTO 0);

--	SIGNAL 		addr0		: STD_LOGIC ;
--	SIGNAL 		addr1		: STD_LOGIC ;
--	SIGNAL 		addr2		: STD_LOGIC ;
--	SIGNAL 		addr3		: STD_LOGIC ;
----	SIGNAL 		data0		: STD_LOGIC ;
--	SIGNAL 		data1		: STD_LOGIC ;
--	SIGNAL 		data2		: STD_LOGIC ;
--	SIGNAL 		data3		: STD_LOGIC ;
--	SIGNAL 		data4		: STD_LOGIC ;
--	SIGNAL 		data5		: STD_LOGIC ;
--	SIGNAL 		data6		: STD_LOGIC ;
--	SIGNAL 		data7		: STD_LOGIC ;
--	SIGNAL 		data8		: STD_LOGIC ;
--	SIGNAL 		data9		: STD_LOGIC ;
--	SIGNAL 		data10		: STD_LOGIC ;
--	SIGNAL 		data11		: STD_LOGIC ;
--	SIGNAL 		data12		: STD_LOGIC ;
--	SIGNAL 		data13		: STD_LOGIC ;
--	SIGNAL 		data14		: STD_LOGIC ;
--	SIGNAL 		data15		: STD_LOGIC ;

BEGIN

--	port map
--	(
--		CE  => enable_sig,
--		A0  => sel_sig(0),
--		A1  => sel_sig(1),
--		A2  => sel_sig(2),
--		A3  => sel_sig(3),
--		CLK  => clock_sig,
--		D   => shiftin_sig,
--		Q   => result_sig
--	);

Shiftreg16_inst : Shiftreg16 PORT MAP (
		clock	 => CLK,
		enable	 => CE,
		shiftin	 => D,
		q	 => q_sig
	);


Mux16x1_inst : Mux16x1 PORT MAP (
		data0	 => q_sig(0), 
		data1	 => q_sig(0), 
		data2	 => q_sig(0), 
		data3	 => q_sig(0),
		data4	 => q_sig(0), 
		data5	 => q_sig(0),
		data6	 => q_sig(0),
		data7	 => q_sig(0),
		data8	 => q_sig(0),
		data9	 => q_sig(0),
		data10	 => q_sig(10),
		data11	 => q_sig(11),
		data12	 => q_sig(12),
		data13	 => q_sig(13),
		data14	 => q_sig(14),
		data15	 => q_sig(15),
		sel	 => adr_sig,
		result => Q
	);
	
		adr_sig(0)	<=		A0; 	
		adr_sig(1)	<=		A1; 	
		adr_sig(2)	<=		A2; 	
		adr_sig(3)	<=		A3; 	
	
--
--ux16x1_inst : Mux16x1 PORT MAP (
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
--		result => Q
--	);
--
--		q_sig(0)  <=	data0_sig;
--		q_sig(1)  <=	data1_sig;
--		q_sig(2)  <=	data2_sig;
--		q_sig(3)  <=	data3_sig;
--		q_sig(4)  <=	data4_sig;
--		q_sig(5)  <=	data5_sig;
--		q_sig(6)  <=	data6_sig;
--		q_sig(7)  <=	data7_sig;
--		q_sig(8)  <=	data8_sig;
--		q_sig(9)  <=	data9_sig;
--		q_sig(10)  <=	data10_sig;
--		q_sig(11)  <=	data11_sig;
--		q_sig(12)  <=	data12_sig;
--		q_sig(13)  <=	data13_sig;
--		q_sig(14)  <=	data14_sig;
--		q_sig(15)  <=	data15_sig;


		
END;