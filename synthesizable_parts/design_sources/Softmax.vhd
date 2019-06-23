library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library xil_defaultlib;
use xil_defaultlib.Package_Utility.ALL;


entity Softmax is
    generic (N: integer := 4);
    Port(
        aclk : in std_logic;
        input_vector : in vector_32 (0 to N-1);
        output_vector : out vector_32 (0 to N-1);
        valid_in : in std_logic;
        valid_out : out std_logic);
end Softmax;

architecture Behavioral of Softmax is
    COMPONENT to_float_from_32 PORT (
        aclk : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    
    COMPONENT to_fixed_32 PORT (
        aclk : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    
    COMPONENT exp_float PORT (
        aclk : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    
    COMPONENT add_float PORT (
        aclk : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axis_b_tvalid : IN STD_LOGIC;
        s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    
    COMPONENT divide_float PORT (
        aclk : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axis_b_tvalid : IN STD_LOGIC;
        s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    
    signal float_cast_valid : std_logic;
    signal input_float_data : vector_32 (0 to N-1);
    signal exp_data : vector_32 (0 to N-1);
    signal exp_valid : std_logic_vector(0 to N-1);
    signal sums_out : vector_32 (0 to N-1);
    signal sums_valid : std_logic_vector(0 to N-1);
    signal divided_out : vector_32 (0 to N-1);
    signal divided_valid : std_logic_vector(0 to N-1);
    signal output_cast_valid : std_logic_vector(0 to N-1);
    
begin

    add_first_cell : add_float PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => exp_valid (0),
        s_axis_a_tdata => exp_data (0),
        s_axis_b_tvalid => exp_valid (1),
        s_axis_b_tdata => exp_data (1),
        m_axis_result_tvalid => sums_valid (0),
        m_axis_result_tdata => sums_out (0));
        
    F: for i in 0 to N-1 generate
        input_to_float : to_float_from_32 PORT MAP (
            aclk => aclk,
            s_axis_a_tvalid => valid_in,
            s_axis_a_tdata => input_vector (i),
            m_axis_result_tvalid => float_cast_valid,
            m_axis_result_tdata => input_float_data (i));
            
        exponential : exp_float PORT MAP (
            aclk => aclk,
            s_axis_a_tvalid => float_cast_valid,
            s_axis_a_tdata => input_float_data (i),
            m_axis_result_tvalid => exp_valid (i),
            m_axis_result_tdata => exp_data (i));
            
        divide : divide_float PORT MAP (
            aclk => aclk,
            s_axis_a_tvalid => exp_valid (i),
            s_axis_a_tdata => exp_data (i),
            s_axis_b_tvalid => sums_valid (N - 2),
            s_axis_b_tdata => sums_out (N - 2),
            m_axis_result_tvalid => divided_valid (i),
            m_axis_result_tdata => divided_out (i));
            
        final_result : to_fixed_32 PORT MAP (
            aclk => aclk,
            s_axis_a_tvalid => divided_valid (i),
            s_axis_a_tdata => divided_out (i),
            m_axis_result_tvalid => output_cast_valid(i),
            m_axis_result_tdata => output_vector (i));
    end generate F;
    
    G: for j in 2 to N-1 generate
        sum_compute : add_float PORT MAP (
            aclk => aclk,
            s_axis_a_tvalid => sums_valid (j - 2),
            s_axis_a_tdata => sums_out (j - 2),
            s_axis_b_tvalid => exp_valid (j),
            s_axis_b_tdata => exp_data (j),
            m_axis_result_tvalid => sums_valid (j - 1),
            m_axis_result_tdata => sums_out (j - 1));
    end generate G;
    
    valid_out <= '1' when (not output_cast_valid = (output_cast_valid'range => '0')) else '0';
end Behavioral;
