library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity decodecircuit is
  generic (
    n: integer range 1 to 100;
    gn: integer  range 1 to 100
  );
  port (
    CLK: in std_logic;
    r: in std_logic_vector(n-1 downto 0);
    g: in std_logic_vector(gn downto 0);
    syndrome: in std_logic_vector(gn-1 downto 0);
    cr: out std_logic_vector(n-1 downto 0);
    finish: out std_logic
  );
end entity;
architecture decodecircuit of decodecircuit is
    signal cnt: integer  range 0 to 2*n := 0;
    signal indx: integer range 0 to n-1 := 0;
    signal bin: std_logic;
    signal reset: std_logic := '0';
    signal shift: std_logic := '0';
    signal correct: std_logic := '0';
    signal s: std_logic_vector(gn-1 downto 0);
begin

    finish <= reset;
    bin <= r(r'high - indx) and not shift;

    syndromecircuit_inst: entity work.syndromecircuit
    generic map (
      n => gn
    )
    port map (
      CLK   => CLK,
      reset => reset,
      g     => g,
      b     => bin,
      s     => s
    );

    correct <= '1' when s = syndrome else '0';

    seqreg_inst: entity work.seqreg
    generic map (
      n => n
    )
    port map (
      CLK     => CLK,
      reset   => reset,
      shift   => shift,
      correct => correct,
      bin     => bin,
      c       => cr
    );

    count: process(CLK)
    begin
        if rising_edge(CLK) then
            if cnt = 2*n then
                shift <= '0';
                reset <= '0';
                indx <= 0;
                cnt <= 0;
            else
                if cnt = 2*n-1 then
                    reset <= '1';
                elsif cnt = n-1 then
                    shift <= '1';
                elsif cnt < n-1 then
                    indx  <= indx + 1;
                end if;
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

end architecture;

