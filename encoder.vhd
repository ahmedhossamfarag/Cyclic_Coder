library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ecoder is
  generic (
    k: integer range 1 to 100;
    gn: integer range 1 to 100
  );
  port (
    CLK: in std_logic;
    u: in std_logic_vector(k-1 downto 0);
    g: in std_logic_vector(gn downto 0);
    encoded: out std_logic_vector(gn+k-1 downto 0)
  );
end entity;

architecture ecoder of ecoder is
    signal v: std_logic_vector(gn-1 downto 0);
    signal finish: std_logic;
begin
    encodecircuit_inst: entity work.encodecircuit
    generic map (
      k => k,
      gn => gn
    )
    port map (
      CLK    => CLK,
      g      => g,
      u      => u,
      v      => v,
      finish => finish
    );
    correct: process(CLK)
    begin
        if rising_edge(CLK) then
            if finish = '1' then
                encoded <= u & v;
            end if;
        end if;
    end process;
end architecture;
