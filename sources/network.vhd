library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library xil_defaultlib;
use xil_defaultlib.datatypes_package.all;


entity network is
    Port (
        clk : in std_logic;
        start : in std_logic;
        x_array : in array_20_4;
        results : out vector_2;
        ready : out std_logic);
end network;

architecture RTL of network is
    component LSTM_cell is Port (
        clk : in std_logic;
        start : in std_logic;
        xt : in vector_4;
        ht_1 : in vector_8;
        ct_1 : in vector_8;
        ct : out vector_8;
        ht : out vector_8;
        ready : out std_logic);
    end component;
    
    component end_classifier is Port (
        clk : in std_logic;
        start : in std_logic;
        ht : in vector_8;
        results : out vector_2;
        ready : out std_logic);
    end component;
    
    signal zero_vector : vector_8 := (others => 0.0);
    signal ct_array, ht_array : array_20_8;
    signal ready_bits : std_logic_vector (0 to 19);
begin

    cell0 : LSTM_cell port map (
        clk => clk,
        start => start,
        xt => x_array(0),
        ht_1 => zero_vector,
        ct_1 => zero_vector,
        ct => ct_array(0),
        ht => ht_array(0),
        ready => ready_bits(0));
        
    F : for i in 1 to 19 generate
        cells : LSTM_cell port map (
            clk => clk,
            start => ready_bits(i - 1),
            xt => x_array(i),
            ht_1 => ht_array(i - 1),
            ct_1 => ct_array(i - 1),
            ct => ct_array(i),
            ht => ht_array(i),
            ready => ready_bits(i));
    end generate;
    
    classifier : end_classifier port map (
        clk => clk,
        start => ready_bits(19),
        ht => ht_array(19),
        results => results,
        ready => ready);

end RTL;
