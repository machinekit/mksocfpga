library ieee;
use ieee.std_logic_1164.all;

package reduction_pkg is
 function red_and(X : in std_logic_vector) return std_logic;
end reduction_pkg;

package body reduction_pkg is
	function red_and(X : in std_logic_vector) return std_logic is
		variable tmp : std_logic := '1';
	begin
		for i in X'range loop
			tmp := tmp and X(i);
		end loop;
		return tmp;
	end red_and; 
end package body;