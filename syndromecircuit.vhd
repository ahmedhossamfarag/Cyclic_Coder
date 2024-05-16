library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity syndromecircuit is
  generic (
    n: integer range 1 to 100
  );
  port (
    CLK: in std_logic;
    reset: in std_logic;
    g: in std_logic_vector(n downto 0);
    b: in std_logic;
    s: out std_logic_vector(n-1 downto 0)
  );
end entity;

architecture syndromecircuit of syndromecircuit is
    signal flow: std_logic_vector(n downto 0);
    signal flowin: std_logic_vector(n-1 downto 0);
begin
    flow(0) <= b;
    regs: for i in 0 to n-1 generate
        flowin(i) <= flow(i) xor (flow(n) and g(i));
        bitreg_inst: entity work.bitreg
        port map (
          CLK    => CLK,
          reset  => reset,
          inbit  => flowin(i),
          outbit => flow(i+1)
        );
    end generate;
    s <= flow(n downto 1);
end architecture;
