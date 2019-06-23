library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
library xil_defaultlib;
use xil_defaultlib.Package_Utility.ALL;


entity Multiply_Matrix is
    generic (M, P, N: integer := 2);
    Port (
        enable : in std_logic;
        matrix_a : in matrix_16 (0 to M-1, 0 to P-1);
        matrix_b : in matrix_16 (0 to P-1, 0 to N-1);
        matrix_c : out matrix_32 (0 to M-1, 0 to N-1));
end Multiply_Matrix;

architecture Behavioral of Multiply_Matrix is

begin
    process (enable)
    variable sum : integer;
    begin
        for i in 0 to M-1 loop
            for j in 0 to N-1 loop
                sum := 0;
                for k in 0 to P-1 loop
                    sum := sum + to_integer(signed(matrix_a(i, k)) * signed(matrix_b(k, j)));
                end loop;
                matrix_c(i, j) <= std_logic_vector(to_signed(sum, 32));
            end loop;
        end loop;    
    end process;
end Behavioral;
