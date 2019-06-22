library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library xil_defaultlib;
use xil_defaultlib.datatypes_package.all;
use xil_defaultlib.constants_package.all;


entity last_argument is
    Port (
        clk : in std_logic;
        enable : in std_logic;
        in_vector : in vector_8;
        output : out real);
end last_argument;

architecture Behavioral of last_argument is

signal output_vector : vector_2 := (0.0, 0.0);
signal output_tmp : real := 0.0;
signal column_sel : std_logic := '0';
 
begin
    output <= output_tmp;
    
    process(clk) 
        variable sum: real := 0.0;
    begin
        if rising_edge(clk) then
            if enable = '1' then
                if column_sel = '0' then
                    sum := 0.0;
                    for j in 0 to 7 loop 
                        sum := sum + (in_vector(j)*w_n(j,0));
                    end loop;
                    output_tmp <= sum + b_n(0);
                    column_sel <= '1';
                else
                    sum := 0.0;
                    for j in 0 to 7 loop 
                        sum := sum + (in_vector(j)*w_n(j,1));
                    end loop;
                    output_tmp <= sum + b_n(1);
                end if;
            else
                output_tmp <= 0.0;
            end if;
        end if;
    end process;
    
end Behavioral;
