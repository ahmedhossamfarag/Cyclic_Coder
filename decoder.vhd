library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity decoder is
  generic (
    n: integer range 1 to 100;
    gn: integer  range 1 to 100
  );
  port (
    CLK: in std_logic;
    r: in std_logic_vector(n-1 downto 0);
    g: in std_logic_vector(gn downto 0);
    syndrome: in std_logic_vector(gn-1 downto 0);
    corrected: out std_logic_vector(n-1 downto 0)
  );
end entity;

architecture decoder of decoder is
    signal cr: std_logic_vector(n-1 downto 0);
    signal finish: std_logic;
begin
    decodecircuit_inst: entity work.decodecircuit
    generic map (
      n  => n,
      gn => gn
    )
    port map (
      CLK      => CLK,
      r        => r,
      g        => g,
      syndrome => syndrome,
      cr       => cr,
      finish   => finish
    );

    correct: process(CLK)
    begin
        if rising_edge(CLK) then
            if finish = '1' then
                corrected <= cr;
            end if;
        end if;
    end process;
end architecture;
