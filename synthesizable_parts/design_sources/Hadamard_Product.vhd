library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
library xil_defaultlib;
use xil_defaultlib.Package_Utility.ALL;


entity Hadamard_Product is
    generic (M, N: integer := 2);
    Port(
        enable : in std_logic;
        matrix_a : in matrix_16 (0 to M-1, 0 to N-1);
        matrix_b : in matrix_16 (0 to M-1, 0 to N-1);
        matrix_c : out matrix_32 (0 to M-1, 0 to N-1));
end Hadamard_Product;

architecture Behavioral of Hadamard_Product is
begin
    process (enable)
    begin
        for i in 0 to M-1 loop
            for j in 0 to N-1 loop
                matrix_c(i, j) <= std_logic_vector(to_signed(to_integer(signed(matrix_a(i, j)) * signed(matrix_b(i, j))), 32));
            end loop;
        end loop;    
    end process;
end Behavioral;
