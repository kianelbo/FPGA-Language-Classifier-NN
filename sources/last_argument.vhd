library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library xil_defaultlib;
use xil_defaultlib.datatypes_package.all;
use xil_defaultlib.constants_package.all;


entity last_argument is
    Port (
        clk : in std_logic;
        read_en : in std_logic;
        in_vector : in vector_8;
        output : out real);
end last_argument;

architecture Behavioral of last_argument is

signal output_vector : vector_2 := (0.0, 0.0);
 
begin

    process(clk) 
        variable sum: real := 0.0;
    begin
        if rising_edge(clk) then
           if read_en = '0' then
               for i in 0 to 1 loop
                  sum := 0.0;
                  for j in 0 to 7 loop 
                      sum := sum + (in_vector(j)*w_n(j,i));
                  end loop;
                  output_vector(i) <= sum + b_n(i);
                end loop;
            else
                output <= output_vector(0);
                output_vector <= output_vector(1) & 0.0;
            end if;
        end if;
    
    end process;
end Behavioral;
