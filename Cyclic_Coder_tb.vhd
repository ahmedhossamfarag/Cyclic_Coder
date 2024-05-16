library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Cyclic_Coder_tb is
end entity Cyclic_Coder_tb;

architecture rtl of Cyclic_Coder_tb is

    constant period_time : time      := 83333 ps;
    signal   finished    : std_logic := '0';

    signal CLK : std_logic;

begin

    sim_time_proc: process
    begin
        wait for 200 ms;
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin
        while finished /= '1' loop
            CLK <= '0';
            wait for period_time/2;
            CLK <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    decoder_inst: entity work.decoder
    generic map (
        n  => 7,
        gn => 4
    )
    port map (
        CLK => CLK,
        r   => "1101101",    --r(n-1)~r(0)
        g   => "11101",  --g(gn)~g(0)
        syndrome => "1110"   --s(gn-1)~s(0)
    );

    -- ecoder_inst: entity work.ecoder
    -- generic map (
    --   k  => 2,
    --   gn => 6
    -- )
    -- port map (
    --   CLK     => CLK,
    --   u       => "10",  --u(k-1)~u(0)
    --   g       => "1010101"  --g(gn)~g(0)
    -- );

end architecture rtl;
