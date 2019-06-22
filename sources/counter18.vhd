library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity counter18 is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        cnt : out integer range 0 to 18);
end counter18;

architecture behavorial of counter18 is
    signal i : integer range 0 to 18 := 0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or i = 18 then
                i <= 0;
            else
                i <= i + 1;
            end if;
        end if;
    end process;
    
    cnt <= i;
end behavorial;
