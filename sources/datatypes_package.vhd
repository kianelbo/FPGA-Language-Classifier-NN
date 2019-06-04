library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


package datatypes_package is
    type vector_4 is array(0 to 3) of real;
    type vector_8 is array(0 to 7) of real;
    type matrix_4_8 is array(0 to 3, 0 to 7) of real;
    type matrix_8_8 is array(0 to 7, 0 to 7) of real;
end datatypes_package;

package body datatypes_package is
end datatypes_package;
