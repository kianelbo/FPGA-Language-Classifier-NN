library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library xil_defaultlib;
use xil_defaultlib.datatypes_package.all;
use xil_defaultlib.constants_package.all;


entity cell_datapath is
    Port (
        clk : in std_logic;
        init_mode : in std_logic;
        xt : in vector_4;
        ht_1 : in vector_8;
        ct_1 : in real;
        ct : out real;
        ht : out real);
end cell_datapath;

architecture RTL of cell_datapath is
    component mini_argument is
        Generic
            (delay : integer := 0);
        Port (
            clk : in std_logic;
            read_en : in std_logic;
            x : in vector_4;
            w : in matrix_4_8;
            h : in vector_8;
            u : in matrix_8_8;
            b : in vector_8;
            s : out real);
    end component;
    
    component sigmoid_module is Port (
        clk : in std_logic;
        enable : in std_logic;
        input : in real;
        output : out real);
    end component;
    
    component tanh_module is Port (
        clk : in std_logic;
        enable : in std_logic;
        input : in real;
        output : out real);
    end component;
    
    component adder_module is Port (
        inputx : in real;
        inputy : in real;
        output : out real);
    end component;
    
    component multiplier_module is Port (
        inputx : in real;
        inputy : in real;
        output : out real);
    end component;

    signal arg_f, arg_i, arg_c, arg_o : real;
    signal f_res, i_res, c_res, o_res : real;
    signal temp_ct, temp_f_c, temp_i_c, temp_tanh_c : real;
begin
    mini_f : mini_argument generic map (delay => 0) port map (
            clk => clk, read_en => init_mode, x => xt, w => w_f, h => ht_1, u => u_f, b => b_f, s => arg_f);
    mini_i : mini_argument generic map (delay => 0) port map (
            clk => clk, read_en => init_mode, x => xt, w => w_i, h => ht_1, u => u_i, b => b_i, s => arg_i);
    mini_c : mini_argument generic map (delay => 2) port map (
            clk => clk, read_en => init_mode, x => xt, w => w_c, h => ht_1, u => u_c, b => b_c, s => arg_c);
    mini_o : mini_argument generic map (delay => 4) port map (
            clk => clk, read_en => init_mode, x => xt, w => w_o, h => ht_1, u => u_o, b => b_o, s => arg_o);

    f_component : sigmoid_module port map (
            clk => clk, enable => init_mode, input => arg_f, output => f_res);
    i_component : sigmoid_module port map (
            clk => clk, enable => init_mode, input => arg_i, output => i_res);
    o_component : sigmoid_module port map (
            clk => clk, enable => init_mode, input => arg_o, output => o_res);
    c_component : tanh_module port map (
            clk => clk, enable => init_mode, input => arg_c, output => c_res);

    mult_f_c : multiplier_module port map (
            inputx => f_res, inputy => ct_1, output => temp_f_c);
    mult_i_c : multiplier_module port map (
            inputx => i_res, inputy => c_res, output => temp_i_c);
    
    sum_c : adder_module port map (
            inputx => temp_f_c, inputy => temp_i_c, output => temp_ct);
    
    tanh_c : tanh_module port map (
            clk => clk, enable => init_mode, input => temp_ct, output => temp_tanh_c);
    mult_h : multiplier_module port map (
            inputx => temp_tanh_c, inputy => o_res, output => ht);
    
    ct <= temp_ct;
end RTL;
