library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity bitreg is
  port (
    CLK: in std_logic;
    reset: in std_logic;
    inbit: in std_logic;
    outbit: out std_logic := '0'
  );
end entity;

architecture bitreg of bitreg is
begin
    load: process(CLK)
    begin
        if rising_edge(CLK) then
            outbit <= inbit and not reset;
        end if;
    end process;
end architecture;
