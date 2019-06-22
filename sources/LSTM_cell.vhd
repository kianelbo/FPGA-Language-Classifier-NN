library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library xil_defaultlib;
use xil_defaultlib.datatypes_package.all;


entity LSTM_cell is
    Port (
        clk : in std_logic;
        start : in std_logic;
        xt : in vector_4;
        ht_1 : in vector_8;
        ct_1 : in vector_8;
        ct : out vector_8;
        ht : out vector_8;
        ready : out std_logic);
end LSTM_cell;

architecture Behavioral of LSTM_cell is
    component cell_datapath is Port (
        clk : in std_logic;
        init_mode : in std_logic;
        xt : in vector_4;
        ht_1 : in vector_8;
        ct_1 : in real;
        ct : out real;
        ht: out real);
    end component;
    
    component counter18 is Port (
        clk : in std_logic;
        rst : in std_logic;
        cnt : out integer range 0 to 18);
    end component;
    
    type state_type is (INIT, CALC);
    signal phase : state_type := INIT;
    signal index : integer;
    signal counter_rst : std_logic := '1';
    signal datapath_en : std_logic;
    signal done : std_logic := '0';
    signal temp_ct, temp_ht, temp_ct_1 : real;
    signal vector_ct, vector_ht : vector_8;
begin
    datapath_en <= not counter_rst;
    
    bulk : cell_datapath port map (
            clk => clk,
            init_mode => datapath_en,
            xt => xt,
            ht_1 => ht_1,
            ct_1 => temp_ct_1,
            ct => temp_ct,
            ht => temp_ht);

    counter : counter18 port map (
            clk => clk,
            rst => counter_rst,
            cnt => index);
    
    ct <= vector_ct;
    ht <= vector_ht;
    ready <= done;
    
    process (clk)
    begin
        if rising_edge(clk) then
            if start = '0' then                                 -- like reset state
                done <= '0';
                counter_rst <= '1';
                vector_ct <= (others => 0.0);
                vector_ht <= (others => 0.0);
                phase <= INIT;
            else
                if phase = INIT then
                    done <= '0';
                    counter_rst <= '0';
                    phase <= CALC;
                else
                    if index > 5 and index < 14 then            -- putting ct-1 and collecting ct
                        temp_ct_1 <= ct_1(index - 6);
                        vector_ct(index - 6) <= temp_ct;
                    end if;
                    if index = 18 then                          -- collecting ht
                        done <= '1';
                    elsif index > 9 and index < 18 then         -- all 8 entries done
                        vector_ht(index - 10) <= temp_ht;
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
