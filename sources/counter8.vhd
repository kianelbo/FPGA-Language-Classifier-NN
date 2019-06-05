library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity counter8 is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        cout : out std_logic_vector (2 downto 0));
end counter8;

architecture RTL of counter8 is
    signal cur : std_logic_vector (2 downto 0) := "000";
    signal nxt : std_logic_vector (2 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cur <= "000";
            else
                case cur is
                    when "000" => nxt <= "001";
                    when "001" => nxt <= "010";
                    when "010" => nxt <= "011";
                    when "011" => nxt <= "100";
                    when "100" => nxt <= "101";
                    when "101" => nxt <= "110";
                    when "110" => nxt <= "111";
                    when others => nxt <= "000";
                end case;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                cur <= nxt;
            end if;
        end if;
    end process;
    
    cout <= cur;
end RTL;
