library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


package Package_Utility is
--    constant N : integer := 2;
--    constant M : integer := 2;
--    constant P : integer := 2;
    
    type matrix_16 is array(natural range <>, natural range <>) of std_logic_vector(15 downto 0);
    type matrix_32 is array(natural range <>, natural range <>) of std_logic_vector(31 downto 0);
    type vector_32 is array(natural range <>) of std_logic_vector(31 downto 0);
--    type row_16bit is array (0 to N-1) of std_logic_vector (15 downto 0);
--    type matrix_nm_16 is array (0 to M-1) of row_16bit;
--    type row_32bit is array (0 to N-1) of std_logic_vector (31 downto 0);
--    type matrix_nm_32 is array (0 to M-1) of row_32bit;
end Package_Utility;

package body Package_Utility is
end Package_Utility;
