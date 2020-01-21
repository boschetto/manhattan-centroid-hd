----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/18/2018 07:41:17 PM
-- Design Name: 
-- Module Name: byte_registry - arch
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

entity byte_registry is
    port(
    reset, clk, en: in std_logic;
    d: in std_logic_vector(7 downto 0);
    q: out std_logic_vector(7 downto 0)
    );
end byte_registry;

architecture arch of byte_registry is
signal state : std_logic_vector(7 downto 0);
begin
    q <= state;
    --q_n <= not state;
    
    process (clk, reset)
    begin
        if (reset='1') then
            state <= x"00";
        else if (falling_edge(clk)) then
                if(en='1') then
                state <= d;
                else
                state <= state;
                end if;
            end if;
        end if;
    end process;
end arch;

architecture archrise of byte_registry is
signal state : std_logic_vector(7 downto 0);
begin
    q <= state;
    --q_n <= not state;
    
    process (clk, reset)
    begin
        if (reset='1') then
            state <= x"00";
        else if (rising_edge(clk)) then
                if(en='1') then
                state <= d;
                else
                state <= state;
                end if;
            end if;
        end if;
    end process;
end archrise;
