library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_textio.all;
library std;
use std.textio.all;
library xil_defaultlib;
use xil_defaultlib.datatypes_package.all;


entity Testbench is
end entity;


architecture TB of Testbench is
    component network Port (
        clk : in std_logic;
        start : in std_logic;
        x_array : in array_20_4;
        results : out vector_2;
        ready : out std_logic);
    end component;

    signal clk: std_logic := '0';
    signal reading_file : std_logic := '0';
    signal enable : std_logic := '0';
    signal x_array: array_20_4;
    signal results: vector_2;
    signal ready: std_logic;

begin
    clk <= not clk after 500 ps;
    
    reading_file <= '1' after 500 ps;
    
    uut : network port map (
        clk     => clk,
        start   => enable,
        x_array => x_array,
        results => results,
        ready   => ready );
       
        
    read_from_file : process (reading_file)
        variable in_line : line;
        file in_file : text;
        variable entry : real;
    begin
        if reading_file = '1' then
            file_open(in_file,"/inputs.txt", read_mode);
                    
            while not endfile(in_file) loop
                for i in 0 to 19 loop
                    for j in 0 to 3 loop
                        readline(in_file, in_line);
                        read(in_line, entry);
                        x_array(i)(j) <= entry;
                    end loop;
                    readline(in_file, in_line);
                end loop;
            end loop;
            
            enable <= '1';
        end if;
    end process;
    
    write_to_file : process (ready)
        variable out_line : line;
        file out_file : text;
    begin
        if ready = '1' then
            file_open(out_file, "output.txt", write_mode);
            write(out_line, results(0), right, 20);
            write(out_line, results(1), right, 20);
            writeline(out_file, out_line);
            file_close(out_file);
        end if;
    end process;
    
end TB;