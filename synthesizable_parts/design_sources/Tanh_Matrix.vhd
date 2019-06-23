library ieee;
use ieee.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.Package_Utility.ALL;


entity Tanh_Matrix is
    generic (M, N: integer := 2);
    Port(
        aclk : in std_logic;
        input_array : in matrix_16 (0 to M-1, 0 to N-1);
        output_array : out matrix_16 (0 to M-1, 0 to N-1);
        valid_in : in std_logic;
        valid_out : out std_logic);
end Tanh_Matrix;

architecture Behavioral of Tanh_Matrix is
    component tanh Port(
        aclk : in std_logic;
        valid_in : in std_logic;
        in_16 : in std_logic_vector (15 downto 0);
        valid_out : out std_logic;
        out_16 : out std_logic_vector (15 downto 0));
    end component;
    
begin
    F: for i in 0 to M-1 generate
    G: for j in 0 to N-1 generate
        tanh_unit : tanh port map (aclk, valid_in, input_array(i, j), valid_out, output_array(i, j));
    end generate G;
    end generate F;
end Behavioral;
