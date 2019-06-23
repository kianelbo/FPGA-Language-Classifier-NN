library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity right_shift is
    Port(
        a_fixed : in std_logic_vector (15 downto 0);
        b_fixed : out std_logic_vector (15 downto 0));
end right_shift;

architecture Behavioral of right_shift is

begin
    b_fixed <= '0' & a_fixed (15 downto 1);
end Behavioral;
