library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity counter18 is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        cout : out integer);
end counter18;

architecture behavorial of counter18 is
    signal i : integer := 0;
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
    
    cout <= i;
end behavorial;
