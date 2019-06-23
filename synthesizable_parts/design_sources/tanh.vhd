library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tanh is
    Port(
        aclk : in std_logic;
        valid_in : in std_logic;
        in_16 : in std_logic_vector (15 downto 0);
        valid_out : out std_logic;
        out_16 : out std_logic_vector (15 downto 0));
end tanh;

architecture Behavioral of tanh is
    COMPONENT right_shift Port(
        a_fixed : in std_logic_vector (15 downto 0);
        b_fixed : out std_logic_vector (15 downto 0));
    end COMPONENT;
    
    COMPONENT sinh_cosh PORT (
        aclk : IN STD_LOGIC;
        s_axis_phase_tvalid : IN STD_LOGIC;
        s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        m_axis_dout_tvalid : OUT STD_LOGIC;
        m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    
    COMPONENT to_float PORT (
        aclk : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
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
    
    COMPONENT to_fixed PORT (
        aclk : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT;
    
    signal sign : std_logic;
    signal unsigned_input : std_logic_vector (15 downto 0);
    signal sinhcosh_result_data : std_logic_vector (31 downto 0);
    signal sinhcosh_result_valid : std_logic;
    signal sinh_result_float_data : std_logic_vector (31 downto 0);
    signal sinh_result_float_valid : std_logic;
    signal cosh_result_float_data : std_logic_vector (31 downto 0);
    signal cosh_result_float_valid : std_logic;
    signal divided_float_data : std_logic_vector (31 downto 0);
    signal divided_float_valid : std_logic;
    signal fixed_data : std_logic_vector (15 downto 0);
    signal shifted_data : std_logic_vector (15 downto 0);
    
begin
    sign <= in_16(15);
    unsigned_input <= '0' & in_16(14 downto 0);
        
    sinhcosh : sinh_cosh PORT MAP (
        aclk => aclk,
        s_axis_phase_tvalid => valid_in,
        s_axis_phase_tdata => unsigned_input,
        m_axis_dout_tvalid => sinhcosh_result_valid,
        m_axis_dout_tdata => sinhcosh_result_data);
        
    sinh_to_float : to_float PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => sinhcosh_result_valid,
        s_axis_a_tdata => sinhcosh_result_data (31 downto 16),
        m_axis_result_tvalid => sinh_result_float_valid,
        m_axis_result_tdata => sinh_result_float_data);
        
    cosh_to_float : to_float PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => sinhcosh_result_valid,
        s_axis_a_tdata => sinhcosh_result_data (15 downto 0),
        m_axis_result_tvalid => cosh_result_float_valid,
        m_axis_result_tdata => cosh_result_float_data);
        
    divide_floats : divide_float PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => sinh_result_float_valid,
        s_axis_a_tdata => sinh_result_float_data,
        s_axis_b_tvalid => cosh_result_float_valid,
        s_axis_b_tdata => cosh_result_float_data,
        m_axis_result_tvalid => divided_float_valid,
        m_axis_result_tdata => divided_float_data);
        
    convert_to_fixed : to_fixed PORT MAP (
        aclk => aclk,
        s_axis_a_tvalid => divided_float_valid,
        s_axis_a_tdata => divided_float_data,
        m_axis_result_tvalid => valid_out,
        m_axis_result_tdata => fixed_data);
        
    apply_sign : right_shift PORT MAP (
        a_fixed => fixed_data,
        b_fixed => shifted_data);
        
    out_16 <= sign & shifted_data(14 downto 0);
end Behavioral;
