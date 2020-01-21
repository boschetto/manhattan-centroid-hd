----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2018 02:47:29 PM
-- Design Name: 
-- Module Name: address_registry - arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity address_registry is
port(
    reset, clk: in std_logic;
    d: in std_logic_vector(15 downto 0);
    q: out std_logic_vector(15 downto 0)
    );
end address_registry;

architecture arch of address_registry is
begin
    process (clk, reset)
    begin
        if (reset='1') then
            q <= x"0000";
        elsif falling_edge(clk) then
            --if ld='1' then
                q <= d;
            --end if;
        end if;
    end process;
end arch;
