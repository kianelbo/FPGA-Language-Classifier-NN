library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library xil_defaultlib;
use xil_defaultlib.datatypes_package.all;


entity mini_argument is
    Port (
        clk : in std_logic;
        read_en : in std_logic;
        x : in vector_4;
        w : in matrix_4_8;
        h : in vector_8;
        u : in matrix_8_8;
        b : in vector_8;
        s : out real);
end mini_argument;

architecture Behavioral of mini_argument is

begin
    process (read_en)
        variable sum : real := 0.0;
    begin
--        for i in 0 to M-1 loop
--            for j in 0 to N-1 loop
--                sum := 0;
--                for k in 0 to P-1 loop
--                    sum := sum + to_integer(signed(matrix_a(i, k)) * signed(matrix_b(k, j)));
--                end loop;
--                matrix_c(i, j) <= std_logic_vector(to_signed(sum, 32));
--            end loop;
--        end loop;
    end process;
end Behavioral;
