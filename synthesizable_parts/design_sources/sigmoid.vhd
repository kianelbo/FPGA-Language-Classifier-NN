library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sigmoid is
    Port(
        aclk : in std_logic;
        valid_in : in std_logic;
        in_16 : in std_logic_vector (15 downto 0);
        valid_out : out std_logic;
        out_16 : out std_logic_vector (15 downto 0));
end sigmoid;

architecture Behavioral of sigmoid is

    component tanh Port (
        aclk : in std_logic;
        valid_in : in std_logic;
        in_16 : in std_logic_vector (15 downto 0);
        valid_out : out std_logic;
        out_16 : out std_logic_vector (15 downto 0));
    end component;
    
    component right_shift Port(
        a_fixed : in std_logic_vector (15 downto 0);
        b_fixed : out std_logic_vector (15 downto 0));
    end component;
    
    COMPONENT to_float PORT (
        aclk : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
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
    
    COMPONENT to_fixed PORT (
        aclk : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT;
    
    signal half : std_logic_vector (31 downto 0) := "00111111000000000000000000000000";
    signal input_halfed : std_logic_vector (15 downto 0);
    signal tanh_valid : std_logic;
    signal tanh_output_data : std_logic_vector (15 downto 0);
    signal tanh_output_data_halfed : std_logic_vector (15 downto 0);
    signal float_valid : std_logic;
    signal tanh_output_data_halfed_float : std_logic_vector (31 downto 0);
    signal add_valid : std_logic;
    signal add_output_data : std_logic_vector (31 downto 0);
    
begin
    input_divider : right_shift PORT MAP (
        a_fixed => in_16,
        b_fixed => input_halfed);
        
    tanh_module : tanh PORT MAP (
        aclk => aclk,
        valid_in => valid_in,
        in_16 => input_halfed,
        valid_out => tanh_valid,
        out_16 => tanh_output_data);
        
    tanh_divider : right_shift PORT MAP (
        a_fixed => tanh_output_data,
        b_fixed => tanh_output_data_halfed);
        
    tanh_to_float : to_float PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => tanh_valid,
        s_axis_a_tdata => tanh_output_data_halfed,
        m_axis_result_tvalid => float_valid,
        m_axis_result_tdata => tanh_output_data_halfed_float);
        
    add : add_float PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => tanh_valid,
        s_axis_a_tdata => half,
        s_axis_b_tvalid => tanh_valid,
        s_axis_b_tdata => tanh_output_data_halfed_float,
        m_axis_result_tvalid => add_valid,
        m_axis_result_tdata => add_output_data);
        
    final_result : to_fixed PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => add_valid,
        s_axis_a_tdata => add_output_data,
        m_axis_result_tvalid => valid_out,
        m_axis_result_tdata => out_16);
        
end Behavioral;
