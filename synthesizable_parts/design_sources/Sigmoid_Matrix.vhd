library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library xil_defaultlib;
use xil_defaultlib.Package_Utility.ALL;


entity Sigmoid_Matrix is
    generic (M, N: integer := 2);
    Port(
        aclk : in std_logic;
        input_array : in matrix_16 (0 to M-1, 0 to N-1);
        output_array : out matrix_16 (0 to M-1, 0 to N-1);
        valid_in : in std_logic;
        valid_out : out std_logic);
end Sigmoid_Matrix;

architecture Behavioral of Sigmoid_Matrix is
    component sigmoid Port(
        aclk : in std_logic;
        valid_in : in std_logic;
        in_16 : in std_logic_vector (15 downto 0);
        valid_out : out std_logic;
        out_16 : out std_logic_vector (15 downto 0));
    end component;
    
begin
    F: for i in 0 to M-1 generate
    G: for j in 0 to N-1 generate
        sigmoid_unit : sigmoid port map (aclk, valid_in, input_array(i, j), valid_out, output_array(i, j));
    end generate G;
    end generate F;
end Behavioral;
