----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2018 02:39:50 PM
-- Design Name: 
-- Module Name: project_reti_logiche - Behavioral
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
USE ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity project_reti_logiche is
port (
    i_clk : in  std_logic;
    i_start : in  std_logic;
    i_rst : in  std_logic;
    i_data : in  std_logic_vector(7 downto 0);
    o_address : out std_logic_vector(15 downto 0);
    o_done : out std_logic;
    o_en : out std_logic;
    o_we : out std_logic;
    o_data : out std_logic_vector (7 downto 0)
);
end project_reti_logiche;

architecture arch of project_reti_logiche is
    type s is (IDLE, s1, s2, s3, s4, s5, s6, s7, s8, s9);
    signal state, next_state : s;
    signal curr_addr, next_addr: std_logic_vector(15 downto 0); -- 16 bit di indirizzo
    signal w_input_mask, input_mask, w_output_mask, output_mask: std_logic_vector(7 downto 0); -- 8 bit di mask
    signal w_x_pivot, w_y_pivot, x_pivot, y_pivot: std_logic_vector(7 downto 0); -- 8 bit pivot coordinates
    signal w_point_num, point_num: std_logic_vector(7 downto 0);
    signal w_x_coord, w_y_coord, x_coord, y_coord: std_logic_vector(7 downto 0); -- 8 bit coordinates
    signal w_shortest_distance, shortest_distance: std_logic_vector(8 downto 0); -- 8 bit coordinates
    signal adder_op1, adder_op2 : std_logic_vector(7 downto 0); -- adder operators
    signal adder_res : std_logic_vector(7 downto 0); -- adder results
    signal adder_full_res : std_logic_vector(8 downto 0); -- adder result
    signal adder_ovf : std_logic;
    signal sub_res1, sub_res2 : std_logic_vector(8 downto 0);
    signal shortest_distance_en, input_mask_en, output_mask_en, x_pivot_en, y_pivot_en, x_coord_en,y_coord_en, point_num_en: std_logic;
    --signal output_mask_bit_selector, input_mask_bit_selector: std_logic_vector(2 downto 0);
    
begin
    addr_reg : entity work.address_registry(arch) port map( reset=>i_rst, clk=>i_clk, d=>next_addr, q=>curr_addr);
    input_mask_reg : entity work.byte_registry(arch) port map( reset=>i_rst, clk=>i_clk, en=>input_mask_en, d=>w_input_mask, q=>input_mask);
    output_mask_reg : entity work.byte_registry(archrise) port map(reset=>i_rst, clk=>i_clk, en=>output_mask_en, d=>w_output_mask, q=>output_mask);
    x_pivot_coord_reg : entity work.byte_registry(arch) port map( reset=>i_rst, clk=>i_clk, en=>x_pivot_en, d=>w_x_pivot, q=>x_pivot);
    y_pivot_coord_reg : entity work.byte_registry(arch) port map( reset=>i_rst, clk=>i_clk, en=>y_pivot_en, d=>w_y_pivot, q=>y_pivot);
    x_coord_reg : entity work.byte_registry(arch) port map( reset=>i_rst, clk=>i_clk, en=>x_coord_en, d=>w_x_coord, q=>x_coord);
    y_coord_reg : entity work.byte_registry(arch) port map( reset=>i_rst, clk=>i_clk, en=>y_coord_en, d=>w_y_coord, q=>y_coord);
    shortest_distance_reg : entity work.strange_registry(arch) port map(reset=>i_rst, clk=>i_clk, en=>shortest_distance_en, d=>w_shortest_distance, q=>shortest_distance);
    point_num_reg: entity work.byte_registry(arch) port map( reset=>i_rst, clk=>i_clk, en=>point_num_en, d=>w_point_num, q=>point_num);
    
    
    uadd: entity work.unsigned_adder(arch) port map(add1=>adder_op1, add2=>adder_op2, res=>adder_res, big_res=>adder_full_res, ovf=>adder_ovf);
    
    o_address <= next_addr;
    o_data <= output_mask;
    
    
    process(i_rst, i_clk) -- regitro di stato
    begin
        if(falling_edge(i_clk)) then
            if(i_rst='1') then
                state <= IDLE;
            else
                state <= next_state;
            end if;
        end if;
    end process;
    
    CALC_OUTPUT_MASK: process(state, i_start, i_data, input_mask, x_coord, y_coord, x_pivot, y_pivot, adder_full_res, sub_res1, sub_res2, point_num, shortest_distance, output_mask)
    begin
    
    -- INITIALIZE SIGNALS AND REGs
    o_en<='1';
    o_we<='0';
    o_done<='0';
    shortest_distance_en<='0';
    input_mask_en<='0'; 
    output_mask_en<='0';
    x_pivot_en<='0';
    y_pivot_en<='0';
    x_coord_en<='0';
    y_coord_en<='0';
    point_num_en<='0';
    -- END SIGNAL INITIALIZATION
    
    if (i_start='0') then -- idle
        o_done<='0';
        if(state=IDLE) then
            next_state <= state;
        end if;
    else
        case (state) is
            when IDLE =>
                next_state <= s1;
            when s1 =>
                next_addr <= std_logic_vector(to_unsigned(0, 16)); -- address of input mask in RAM
                input_mask_en <= '1'; -- enable write of input mask registry
                w_input_mask <= i_data; -- input mask data from RAM to registry
                next_state <= s2; -- next state is S2
                
            when s2 =>
                next_addr <= std_logic_vector(to_unsigned(17, 16)); -- address of pivot point's X coordinates in RAM
                x_pivot_en <= '1'; -- enable write of x pivot point's registry
                w_x_pivot <= i_data; -- x coordinates from RAM to registry
                next_state <= s3; -- next state is S3
            when s3 =>
                next_addr <= std_logic_vector(to_unsigned(18, 16));
                w_y_pivot <= i_data;
                y_pivot_en <='1';
                next_state <= s4;
            when s4 =>
                w_point_num<=std_logic_vector(to_unsigned(0, 8));
                point_num_en<='1';
                next_state <= s5;
            when s5 =>
                if(input_mask(to_integer(unsigned(point_num)))='1') then --start computation
                    next_addr <=std_logic_vector((unsigned(point_num)*to_unsigned(2, 8))+to_unsigned(1, 8));
                    w_x_coord <= i_data;
                    x_coord_en <= '1';
                    next_state <= s6;
                else -- skip computation
                    if(unsigned(point_num)<7) then -- check if all points have been checked
                        
                        point_num_en<='1';
                        w_point_num<=std_logic_vector(unsigned(point_num)+to_unsigned(1,8)); -- move point number ahead of 1
                        next_state <= s5;         
                    else
                        next_state<=s8;
                    end if;
                end if;
            when s6 =>
                next_addr <= std_logic_vector((unsigned(point_num)*to_unsigned(2, 8))+to_unsigned(2, 8));
                w_y_coord <= i_data;
                y_coord_en<='1';
                next_state <= s7;
                
            when s7 =>
                if(unsigned('0'&x_pivot)>unsigned('0'&x_coord)) then
                    sub_res1 <= std_logic_vector(unsigned('0'&x_pivot)-unsigned('0'&x_coord));
                else
                    sub_res1 <= std_logic_vector(unsigned('0'&x_coord)-unsigned('0'&x_pivot));
                end if;
                
                if(unsigned('0'&y_pivot)>unsigned('0'&y_coord)) then
                    sub_res2 <= std_logic_vector(unsigned('0'&y_pivot)-unsigned('0'&y_coord));
                else
                    sub_res2 <= std_logic_vector(unsigned('0'&y_coord)-unsigned('0'&y_pivot));
                end if;
                
                adder_op1 <= sub_res1(7 downto 0);
                adder_op2 <= sub_res2(7 downto 0);
                                
                if(unsigned(adder_full_res)<unsigned(shortest_distance)) then
                    shortest_distance_en <='1';
                    w_shortest_distance <= adder_full_res;
                    
                    output_mask_en<='1';
                    w_output_mask<=(others => '0');
                    w_output_mask(to_integer(unsigned(point_num)))<='1';
                elsif(unsigned(adder_full_res)=unsigned(shortest_distance)) then
                    output_mask_en<='1';
                    w_output_mask<=output_mask;
                    w_output_mask(to_integer(unsigned(point_num)))<='1';
                end if;
                
                if(unsigned(point_num)<to_unsigned(7, 8)) then
                    next_state<=s5;
                    point_num_en<='1';
                    w_point_num<=std_logic_vector(unsigned(point_num)+to_unsigned(1, 8));            
                else
                    next_state<=s8;
                end if;
            when s8 =>
                next_addr <= "0000000000010011";
                --o_en <= '1';
                o_we <= '1';
                next_state <= s9;
            when s9 =>
                o_done <= '1';
                next_state <= s9;
        end case;
    
    end if;
    
    end process;

end arch;
