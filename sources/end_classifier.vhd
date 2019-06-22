library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library xil_defaultlib;
use xil_defaultlib.datatypes_package.all;


entity end_classifier is
    Port (
        clk : in std_logic;
        start : in std_logic;
        ht : in vector_8;
        results : out vector_2;
        ready : out std_logic);
end end_classifier;

architecture Behavioral of end_classifier is
    component last_argument is Port (
        clk : in std_logic;
        enable : in std_logic;
        in_vector : in vector_8;
        output : out real);        
    end component;
    
    component sigmoid_module is Port (
        clk : in std_logic;
        enable : in std_logic;
        input : in real;
        output : out real);
    end component;
    
    type state_type is (RESET, W1, W2, W3, W4, W5, W6, W7, O1, O2);
    signal state : state_type := RESET;
    signal sigmoid_in, sigmoid_out : real;
    signal done, enable : std_logic := '0';
    signal tmp_result : vector_2 := (others => 0.0);
    
begin

    the_args : last_argument port map (clk => clk, enable => enable, in_vector => ht, output => sigmoid_in);
    
    sigmoid : sigmoid_module port map (clk => clk, enable => enable, input => sigmoid_in, output => sigmoid_out);
    
    ready <= done;
    results <= tmp_result;
    
    process (clk)
    begin
        if rising_edge(clk) then
            if start = '0' then
                done <= '0';
                enable <= '0';
                tmp_result <= (others => 0.0);
                state <= RESET;
            else
                case state is
                    when RESET =>
                        enable <= '1';
                        state <= W1;
                    when W1 =>
                        state <= W2;
                    when W2 =>
                        state <= W3;
                    when W3 =>
                        state <= W4;
                    when W4 =>
                        state <= W5;
                    when W5 =>
                        state <= W6;
                    when W6 =>
                        state <= W7;
                    when W7 =>
                        state <= O1;
                    when O1 =>
                        tmp_result(0) <= sigmoid_out;
                        state <= O2;
                    when O2 =>
                        tmp_result(1) <= sigmoid_out;
                        done <= '1';
                end case;
            end if;
        end if;
    end process;

end Behavioral;
