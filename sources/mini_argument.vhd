library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library xil_defaultlib;
use xil_defaultlib.datatypes_package.all;


entity mini_argument is
    generic (
        delay : integer := 0);
    Port (
        clk : in std_logic;
        read_en : in std_logic;
        x : in vector_4;
        w : in matrix_4_8;
        h : in vector_8;
        u : in matrix_8_8;
        b : in vector_8;
        s : out real := 0.0);
end mini_argument;

architecture Behavioral of mini_argument is
    signal output_vector : vector_8 := (others=>0.0);
begin
    process ( clk )
        variable sum : real := 0.0;
        variable xw : vector_8 := (others=>0.0);
        variable hu : vector_8 := (others=>0.0);
        variable delayed : integer := 0;
    begin
        if (rising_edge(clk)) then
            if (read_en = '0') then

                for i in 0 to 7 loop
                    sum := 0.0;
                    for j in 0 to 3 loop
                        sum := sum + (x(j) * w(j, i)) ;
                    end loop;
                    xw(i) := sum;
                end loop;                                       -- x*w matrix
           
                for i in 0 to 7 loop
                    sum := 0.0;
                    for j in 0 to 7 loop
                        sum := sum + (h(j) * u(j, i)) ;
                    end loop;
                    hu(i) := sum;
                end loop;                                       -- h*u matrix
            
                for i in 0 to 7 loop
                    output_vector(i) <=  xw(i) + hu(i) + b(i);
                end loop;                                       -- output vector
            
                s <= 0.0;
            elsif (read_en = '1') then
                if (delayed >= delay) then
                    s <= output_vector(0);
                    output_vector <= output_vector(1 to 7) & 0.0;
                else
                    delayed := delayed + 1;
                end if;           
            end if;
        end if;      
    end process;
end Behavioral;
