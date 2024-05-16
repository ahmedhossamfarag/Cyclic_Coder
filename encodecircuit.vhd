library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity encodecircuit is
  generic (
    k: integer range 1 to 100;
    gn: integer range 1 to 100
  );
  port (
    CLK: in std_logic;
    g: in std_logic_vector(gn downto 0);
    u: in std_logic_vector(k-1 downto 0);
    v: out std_logic_vector(gn-1 downto 0);
    finish: out std_logic
  );
end entity;

architecture encodecircuit of encodecircuit is
    signal flow: std_logic_vector(gn+1 downto 0);
    signal flowin: std_logic_vector(gn-1 downto 0);
    signal cnt: integer range 0 to k;
    signal indx: integer range 0 to k-1 := 0;
    signal b: std_logic;
    signal reset: std_logic := '0';
begin
    b <= u(u'high - indx);
    flow(0) <= '0';
    flow(gn+1) <= flow(gn) xor b;

    regs: for i in 0 to gn-1 generate
        flowin(i) <= flow(i) xor (flow(gn+1) and g(i));
        bitreg_inst: entity work.bitreg
        port map (
          CLK    => CLK,
          reset  => reset,
          inbit  => flowin(i),
          outbit => flow(i+1)
        );
    end generate;


    count: process(CLK)
    begin
        if rising_edge(CLK) then
            if cnt = k then
                reset <= '0';
                indx <= 0;
                cnt <= 0;
            else
                if cnt = k-1 then
                    reset <= '1';
                elsif cnt < k-1 then
                    indx  <= indx + 1;
                end if;
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    finish <= reset;
    v <= flow(gn downto 1);
end architecture;
