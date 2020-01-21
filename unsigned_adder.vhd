----------------------------------------------------------------------------------
-- University: Politecnico di Milano
-- Student: Stefano Boschetto
-- 
-- Create Date: 12/18/2018 06:22:43 PM
-- Design Name: unsigned integer adder
-- Module Name: unsigned_adder - arch
-- Project Name: Progetto di Reti Logiche
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: ///
-- 
-- Revision: 0.0.1
-- Revision 0.0.1 - File Created
-- Additional Comments: ///
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity unsigned_adder is
    port(
        signal add1, add2 : in std_logic_vector(7 downto 0);
        signal res : out std_logic_vector(7 downto 0);
        signal big_res: out std_logic_vector(8 downto 0);
        signal ovf : out std_logic
    );
end unsigned_adder;

architecture arch of unsigned_adder is
    signal temp_res: std_logic_vector(8 downto 0);
begin
    temp_res <= ('0' & add1) + ('0' & add2);
    big_res <= temp_res;
    res <= temp_res(7 downto 0);
    ovf <= temp_res(8);
end arch;
