----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/21/2018 01:55:01 PM
-- Design Name: 
-- Module Name: strange_registry - arch
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

entity strange_registry is
    port(
        reset, clk, en: in std_logic;
        d: in std_logic_vector(8 downto 0);
        q, q_n: out std_logic_vector(8 downto 0)
    );
end strange_registry;

architecture arch of strange_registry is
    signal state : std_logic_vector(8 downto 0);
begin
    q <= state;
    q_n <= not state;
    
    process (clk, reset)
    begin
        if (reset='1') then
            state <= '1'& x"FF";
        else if (rising_edge(clk)) then
                if(en='1') then
                    state <= d;
                else
                    state <= state;
                end if;
            end if;
        end if;
    end process;

end arch;
