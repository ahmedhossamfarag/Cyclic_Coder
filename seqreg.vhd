library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity seqreg is
  generic (
    n: integer range 0 to 100
  );
  port (
    CLK: in std_logic;
    reset: in std_logic;
    shift: in std_logic;
    correct: in std_logic;
    bin: in std_logic;
    c: out std_logic_vector(n-1 downto 0)
  );
end entity;

architecture seqreg of seqreg is
    signal flow: std_logic_vector(n downto 0);
begin
    with shift select
    flow(0) <= bin when '0',
                flow(n) xor correct when others;

    bits: for i in 0 to n-1 generate
        bitreg_inst: entity work.bitreg
        port map (
          CLK    => CLK,
          reset  => reset,
          inbit  => flow(i),
          outbit => flow(i+1)
        );
    end generate;

    c <= flow(n downto 1);
end architecture;
